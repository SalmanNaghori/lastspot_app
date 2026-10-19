import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../../../core/network/network_exceptions.dart';
import '../../../../core/network/password_recovery_config.dart';
import '../../../../core/services/account_session_service.dart';
import '../../../../core/services/password_recovery_link_monitor.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_device_usecase.dart';
import '../../domain/usecases/resend_otp_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/update_password_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  final SignupUseCase _signupUseCase;
  final LogoutUseCase _logoutUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final ResendOtpUseCase _resendOtpUseCase;
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final GetProfileUseCase _getProfileUseCase;
  final RegisterDeviceUseCase _registerDeviceUseCase;
  final AccountSessionService _accountSessionService;
  final UpdatePasswordUseCase _updatePasswordUseCase;
  final SupabaseClient _supabaseClient;
  final PasswordRecoveryLinkMonitor _recoveryLinkMonitor;
  late final StreamSubscription<supabase.AuthState> _supabaseAuthSubscription;
  late final StreamSubscription<bool> _recoveryLinkSubscription;
  bool _recoveryLinkPending = false;
  bool _passwordRecoverySessionActive = false;
  bool _isRegistrationInProgress = false;
  bool _isValidatingSession = false;
  Timer? _sessionRetryTimer;
  int _sessionRetryAttempt = 0;

  void _scheduleSessionRetry() {
    _sessionRetryTimer?.cancel();
    if (_sessionRetryAttempt >= 4) {
      log('Max session verification retries reached', name: 'AuthBloc');
      return;
    }
    _sessionRetryAttempt++;
    final backoffSeconds = (5 * math.pow(2, _sessionRetryAttempt - 1)).toInt();
    final jitter = math.Random().nextInt(3);
    final delay = Duration(seconds: math.min(backoffSeconds + jitter, 60));
    log(
      'Scheduling session verification retry $_sessionRetryAttempt in ${delay.inSeconds}s',
      name: 'AuthBloc',
    );
    _sessionRetryTimer = Timer(delay, () {
      if (!isClosed) {
        add(AuthSessionValidationRequested());
      }
    });
  }

  void _cancelSessionRetry() {
    _sessionRetryTimer?.cancel();
    _sessionRetryTimer = null;
    _sessionRetryAttempt = 0;
  }

  AuthBloc({
    required LoginUseCase loginUseCase,
    required SignupUseCase signupUseCase,
    required LogoutUseCase logoutUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
    required ResendOtpUseCase resendOtpUseCase,
    required CheckAuthStatusUseCase checkAuthStatusUseCase,
    required GetProfileUseCase getProfileUseCase,
    required RegisterDeviceUseCase registerDeviceUseCase,
    required AccountSessionService accountSessionService,
    required UpdatePasswordUseCase updatePasswordUseCase,
    required SupabaseClient supabaseClient,
    required PasswordRecoveryLinkMonitor recoveryLinkMonitor,
  }) : _loginUseCase = loginUseCase,
       _signupUseCase = signupUseCase,
       _logoutUseCase = logoutUseCase,
       _resetPasswordUseCase = resetPasswordUseCase,
       _verifyOtpUseCase = verifyOtpUseCase,
       _resendOtpUseCase = resendOtpUseCase,
       _checkAuthStatusUseCase = checkAuthStatusUseCase,
       _getProfileUseCase = getProfileUseCase,
       _registerDeviceUseCase = registerDeviceUseCase,
       _accountSessionService = accountSessionService,
       _updatePasswordUseCase = updatePasswordUseCase,
       _supabaseClient = supabaseClient,
       _recoveryLinkMonitor = recoveryLinkMonitor,
       super(AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthSessionValidationRequested>(_onSessionValidationRequested);
    on<AuthRecoveryLinkDetected>(_onRecoveryLinkDetected);
    on<AuthRecoverySessionEstablished>(_onRecoverySessionEstablished);
    on<AuthRecoveryExchangeFailed>(_onRecoveryExchangeFailed);
    on<PasswordRecoveryUpdateRequested>(_onPasswordRecoveryUpdateRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthSignupRequested>(_onSignupRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<VerifyOtpRequested>(_onVerifyOtpRequested);
    on<ResendOtpRequested>(_onResendOtpRequested);
    on<AuthProfileCompleted>(_onProfileCompleted);

    _recoveryLinkSubscription = _recoveryLinkMonitor.linkEvents.listen((
      malformed,
    ) {
      _recoveryLinkPending = !malformed;
      add(AuthRecoveryLinkDetected(malformed: malformed));
    });
    if (_recoveryLinkMonitor.isPending) {
      _recoveryLinkPending = !_recoveryLinkMonitor.lastWasMalformed;
      add(
        AuthRecoveryLinkDetected(
          malformed: _recoveryLinkMonitor.lastWasMalformed,
        ),
      );
    }
    _supabaseAuthSubscription = _supabaseClient.auth.onAuthStateChange.listen(
      (authState) {
        if (authState.event == AuthChangeEvent.passwordRecovery &&
            authState.session != null) {
          _passwordRecoverySessionActive = true;
          _recoveryLinkMonitor.clear();
          _recoveryLinkPending = false;
          add(AuthRecoverySessionEstablished());
        } else if (_recoveryLinkMonitor.isPending &&
            authState.event != AuthChangeEvent.initialSession) {
          add(AuthRecoveryExchangeFailed());
        }
      },
      onError: (Object error, StackTrace stackTrace) {
        if (_recoveryLinkMonitor.isPending || _recoveryLinkPending) {
          add(AuthRecoveryExchangeFailed());
        }
      },
    );
  }

  @override
  Future<void> close() async {
    _cancelSessionRetry();
    await _supabaseAuthSubscription.cancel();
    await _recoveryLinkSubscription.cancel();
    await super.close();
  }

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (_passwordRecoverySessionActive) {
      emit(AuthPasswordRecoveryReady());
      return;
    }
    if (_recoveryLinkPending || _recoveryLinkMonitor.isPending) return;
    try {
      final userId = _checkAuthStatusUseCase();
      if (userId != null) {
        await _validateRestoredSession(userId, emit);
      } else {
        emit(Unauthenticated());
      }
    } catch (e, st) {
      log(
        'Error checking auth session',
        name: 'AuthBloc',
        error: e,
        stackTrace: st,
      );
      emit(AuthSessionCheckUnavailable());
    }
  }

  Future<void> _onSessionValidationRequested(
    AuthSessionValidationRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (_isRegistrationInProgress || _isValidatingSession) {
      log(
        'Session validation skipped: registration or validation in progress',
        name: 'AuthBloc',
      );
      return;
    }
    if (_passwordRecoverySessionActive ||
        _recoveryLinkPending ||
        _recoveryLinkMonitor.isPending) {
      if (_passwordRecoverySessionActive) emit(AuthPasswordRecoveryReady());
      return;
    }

    _isValidatingSession = true;
    try {
      final wasProfileIncomplete = state is AuthProfileIncomplete;
      // CRITICAL: Do NOT emit AuthSessionValidationInProgress() during routine lifecycle checks.
      // Keeping Authenticated/AuthProfileIncomplete avoids blocking user with full-screen loader.
      final userId = _checkAuthStatusUseCase();
      if (userId == null) {
        _cancelSessionRetry();
        emit(Unauthenticated());
        return;
      }

      final status = await _accountSessionService.validateCurrentSession();
      if (_passwordRecoverySessionActive) {
        emit(AuthPasswordRecoveryReady());
        return;
      }
      if (_recoveryLinkPending || _recoveryLinkMonitor.isPending) return;
      switch (status) {
        case AccountSessionStatus.active:
          _cancelSessionRetry();
          if (wasProfileIncomplete) {
            emit(AuthProfileIncomplete());
          } else if (state is! Authenticated) {
            emit(Authenticated());
          }
          return;
        case AccountSessionStatus.inactiveOrUninitialized:
        case AccountSessionStatus.credentialsExpired:
          _cancelSessionRetry();
          await _accountSessionService.clearLocalSession();
          emit(AuthSessionNeedsSignIn(message: _signInRequiredMessage(status)));
          return;
        case AccountSessionStatus.noSession:
          _cancelSessionRetry();
          emit(Unauthenticated());
          return;
        case AccountSessionStatus.unavailable:
          // Network, DNS, timeout, SocketException.
          // This does NOT prove that session was revoked.
          // Keep current screen mounted without blocking UI or showing toasts.
          log(
            'Session validation unavailable (network/DNS). Preserving session and scheduling silent retry.',
            name: 'AuthBloc',
          );
          _scheduleSessionRetry();
          return;
      }
    } finally {
      _isValidatingSession = false;
    }
  }

  void _onRecoveryLinkDetected(
    AuthRecoveryLinkDetected event,
    Emitter<AuthState> emit,
  ) {
    _recoveryLinkPending = !event.malformed;
    if (event.malformed) {
      _recoveryLinkMonitor.clear();
      emit(AuthPasswordRecoveryInvalid());
    }
  }

  void _onRecoverySessionEstablished(
    AuthRecoverySessionEstablished event,
    Emitter<AuthState> emit,
  ) {
    if (_supabaseClient.auth.currentSession == null) {
      _recoveryLinkMonitor.clear();
      _recoveryLinkPending = false;
      emit(AuthPasswordRecoveryInvalid());
      return;
    }
    _recoveryLinkMonitor.clear();
    _recoveryLinkPending = false;
    _passwordRecoverySessionActive = true;
    emit(AuthPasswordRecoveryReady());
  }

  void _onRecoveryExchangeFailed(
    AuthRecoveryExchangeFailed event,
    Emitter<AuthState> emit,
  ) {
    _recoveryLinkMonitor.clear();
    _recoveryLinkPending = false;
    _passwordRecoverySessionActive = false;
    emit(AuthPasswordRecoveryInvalid());
  }

  Future<void> _onPasswordRecoveryUpdateRequested(
    PasswordRecoveryUpdateRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (!_passwordRecoverySessionActive ||
        _supabaseClient.auth.currentSession == null) {
      emit(AuthPasswordRecoveryInvalid());
      return;
    }

    emit(AuthPasswordRecoveryUpdating());
    final result = await _updatePasswordUseCase(password: event.password);
    switch (result) {
      case Success():
        try {
          await _accountSessionService.clearLocalSession();
          _passwordRecoverySessionActive = false;
          emit(AuthPasswordRecoveryCompleted());
        } catch (error, stackTrace) {
          log(
            'Password was updated, but the local recovery session could not be cleared',
            name: 'AuthBloc',
            error: error,
            stackTrace: stackTrace,
          );
          emit(
            const AuthPasswordRecoveryUpdateFailed(
              'Password changed. Please close the app and sign in again.',
            ),
          );
        }
      case Failure(exception: final exception):
        if (exception is AuthException) {
          emit(AuthPasswordRecoveryUpdateFailed(exception.message));
        } else if (exception is NoInternetException) {
          emit(const AuthPasswordRecoveryUpdateFailed('no_internet'));
        } else {
          emit(
            const AuthPasswordRecoveryUpdateFailed(
              'Unable to update your password. Please try again.',
            ),
          );
        }
    }
  }

  Future<void> _validateRestoredSession(
    String userId,
    Emitter<AuthState> emit,
  ) async {
    final status = await _accountSessionService.validateCurrentSession();
    if (_passwordRecoverySessionActive) {
      emit(AuthPasswordRecoveryReady());
      return;
    }
    if (_recoveryLinkPending || _recoveryLinkMonitor.isPending) return;
    await _handleValidationStatus(status, userId, emit);
  }

  Future<void> _handleValidationStatus(
    AccountSessionStatus status,
    String userId,
    Emitter<AuthState> emit,
  ) async {
    switch (status) {
      case AccountSessionStatus.active:
        await _handleUserSession(userId, emit);
      case AccountSessionStatus.inactiveOrUninitialized:
      case AccountSessionStatus.credentialsExpired:
        await _accountSessionService.clearLocalSession();
        emit(AuthSessionNeedsSignIn(message: _signInRequiredMessage(status)));
      case AccountSessionStatus.noSession:
        emit(Unauthenticated());
      case AccountSessionStatus.unavailable:
        emit(
          const AuthSessionCheckUnavailable(
            message:
                'KhelBhai could not confirm this device session. Check your connection and try again.',
          ),
        );
    }
  }

  Future<bool> _activateFreshSession(Emitter<AuthState> emit) async {
    final status = await _accountSessionService.activateFreshSession();
    switch (status) {
      case AccountSessionStatus.active:
        return true;
      case AccountSessionStatus.inactiveOrUninitialized:
        await _accountSessionService.clearLocalSession();
        emit(
          const AuthSessionNeedsSignIn(
            message:
                'Supabase sign-in succeeded, but KhelBhai did not confirm this device as active. Please try again.',
          ),
        );
        return false;
      case AccountSessionStatus.credentialsExpired:
        await _accountSessionService.clearLocalSession();
        emit(
          const AuthSessionNeedsSignIn(
            message:
                'Your sign-in credentials expired before KhelBhai could activate this device. Please try again.',
          ),
        );
        return false;
      case AccountSessionStatus.noSession:
        emit(
          const AuthSessionNeedsSignIn(
            message:
                'Supabase sign-in completed without a session. Please try again.',
          ),
        );
        return false;
      case AccountSessionStatus.unavailable:
        emit(
          const AuthSessionCheckUnavailable(
            message:
                'Sign-in completed, but KhelBhai could not confirm this device session. Check your connection and try again.',
          ),
        );
        return false;
    }
  }

  String _signInRequiredMessage(AccountSessionStatus status) {
    return switch (status) {
      AccountSessionStatus.credentialsExpired =>
        'Your sign-in credentials have expired. Please sign in again.',
      AccountSessionStatus.inactiveOrUninitialized =>
        'Supabase sign-in succeeded, but KhelBhai did not confirm this device as active. Please sign in again.',
      _ => 'Please sign in again to continue.',
    };
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    _isRegistrationInProgress = true;
    try {
      emit(AuthLoading());
      final result = await _loginUseCase(
        email: event.email,
        password: event.password,
      );
      switch (result) {
        case Success():
          final userId = _checkAuthStatusUseCase();
          if (userId != null && await _activateFreshSession(emit)) {
            await _handleUserSession(userId, emit, isFreshSession: true);
          } else {
            if (userId == null) emit(Unauthenticated());
          }
        case Failure(exception: final exception):
          if (exception is NoInternetException) {
            emit(const AuthError(message: 'no_internet'));
          } else if (exception is AuthException) {
            emit(AuthError(message: exception.message));
          } else {
            emit(AuthError(message: exception.toString()));
          }
          emit(Unauthenticated());
      }
    } finally {
      _isRegistrationInProgress = false;
    }
  }

  Future<void> _onSignupRequested(
    AuthSignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    _isRegistrationInProgress = true;
    try {
      emit(AuthLoading());
      final result = await _signupUseCase(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
      );
      switch (result) {
        case Success():
          final userId = _checkAuthStatusUseCase();
          if (userId != null && await _activateFreshSession(emit)) {
            await Future.delayed(
              const Duration(seconds: 1),
            ); // Wait for trigger to complete
            await _handleUserSession(userId, emit, isFreshSession: true);
          } else {
            if (userId == null) emit(Unauthenticated());
          }
        case Failure(exception: final exception):
          if (exception is NoInternetException) {
            emit(const AuthError(message: 'no_internet'));
          } else if (exception is AuthException) {
            emit(AuthError(message: exception.message));
          } else {
            emit(AuthError(message: exception.toString()));
          }
          emit(Unauthenticated());
      }
    } finally {
      _isRegistrationInProgress = false;
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _logoutUseCase();
    switch (result) {
      case Success():
        emit(Unauthenticated());
      case Failure(exception: final exception):
        if (exception is NoInternetException) {
          emit(const AuthError(message: 'no_internet'));
        } else {
          emit(AuthError(message: exception.toString()));
        }
        emit(Authenticated());
    }
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _resetPasswordUseCase(
      email: event.email,
      redirectTo: PasswordRecoveryConfig.mobileRedirectUrl,
    );
    switch (result) {
      case Success():
        emit(AuthOtpSent(email: event.email));
      case Failure(exception: final exception):
        if (exception is NoInternetException) {
          emit(const AuthError(message: 'no_internet'));
        } else if (exception is AuthException) {
          emit(AuthError(message: exception.message));
        } else {
          emit(AuthError(message: exception.toString()));
        }
    }
  }

  Future<void> _onVerifyOtpRequested(
    VerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    _isRegistrationInProgress = true;
    try {
      emit(AuthLoading());
      String typeStr = event.type == OtpType.signup ? 'signup' : 'email';
      final result = await _verifyOtpUseCase(
        email: event.email,
        token: event.token,
        type: typeStr,
      );

      switch (result) {
        case Success():
          if (event.type == OtpType.signup) {
            final userId = _checkAuthStatusUseCase();
            if (userId != null && await _activateFreshSession(emit)) {
              await _handleUserSession(userId, emit, isFreshSession: true);
            } else if (userId == null) {
              emit(AuthOtpVerified());
            }
          } else {
            emit(AuthOtpVerified());
          }
        case Failure(exception: final exception):
          if (exception is NoInternetException) {
            emit(const AuthError(message: 'no_internet'));
          } else if (exception is AuthException) {
            emit(AuthError(message: exception.message));
          } else {
            emit(AuthError(message: exception.toString()));
          }
      }
    } finally {
      _isRegistrationInProgress = false;
    }
  }

  Future<void> _onResendOtpRequested(
    ResendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    String typeStr = event.type == OtpType.signup ? 'signup' : 'email';
    final result = await _resendOtpUseCase(email: event.email, type: typeStr);

    switch (result) {
      case Success():
        emit(AuthOtpSent(email: event.email));
      case Failure(exception: final exception):
        if (exception is NoInternetException) {
          emit(const AuthError(message: 'no_internet'));
        } else if (exception is AuthException) {
          emit(AuthError(message: exception.message));
        } else {
          emit(AuthError(message: exception.toString()));
        }
    }
  }

  void _onProfileCompleted(
    AuthProfileCompleted event,
    Emitter<AuthState> emit,
  ) {
    final userId = _checkAuthStatusUseCase();
    if (userId == null) {
      emit(Unauthenticated());
      return;
    }
    emit(Authenticated());
  }

  Future<void> _handleUserSession(
    String userId,
    Emitter<AuthState> emit, {
    bool isFreshSession = false,
  }) async {
    try {
      if (isFreshSession) {
        try {
          await _registerDeviceUseCase(userId);
        } catch (e, st) {
          log(
            'Device registration failed after session activation',
            name: 'AuthBloc',
            error: e,
            stackTrace: st,
          );
          await _accountSessionService.clearLocalSession();
          emit(
            const AuthSessionNeedsSignIn(
              message:
                  'Could not register this device with KhelBhai. Please check your connection and sign in again.',
            ),
          );
          return;
        }
      }

      final profile = await _getProfileUseCase(userId);
      if (_passwordRecoverySessionActive) {
        emit(AuthPasswordRecoveryReady());
        return;
      }
      if (_recoveryLinkPending || _recoveryLinkMonitor.isPending) return;
      if (profile == null) {
        emit(AuthProfileIncomplete());
        return;
      }

      if (profile.deletedAt != null) {
        emit(AuthDeleted());
        return;
      }

      if (profile.status == AccountStatus.suspended) {
        emit(AuthSuspended());
        return;
      }

      if (profile.status == AccountStatus.banned) {
        emit(AuthBanned());
        return;
      }

      // Use the authoritative DB flag — set to true by ProfileCubit.saveProfile()
      if (!profile.isProfileCompleted) {
        emit(AuthProfileIncomplete());
        return;
      }

      if (_passwordRecoverySessionActive ||
          _recoveryLinkPending ||
          _recoveryLinkMonitor.isPending) {
        if (_passwordRecoverySessionActive) emit(AuthPasswordRecoveryReady());
        return;
      }

      emit(Authenticated());
    } catch (e, st) {
      log(
        'Error handling user session',
        name: 'AuthBloc',
        error: e,
        stackTrace: st,
      );
      // A profile fetch failure does not prove that the Auth session expired.
      emit(AuthSessionCheckUnavailable());
    }
  }
}
