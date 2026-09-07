import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/resend_otp_usecase.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/register_device_usecase.dart';
import '../../../../core/network/network_exceptions.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/user_profile.dart';
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
  final UpdateProfileUseCase _updateProfileUseCase;
  final RegisterDeviceUseCase _registerDeviceUseCase;

  AuthBloc({
    required LoginUseCase loginUseCase,
    required SignupUseCase signupUseCase,
    required LogoutUseCase logoutUseCase,
    required ResetPasswordUseCase resetPasswordUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
    required ResendOtpUseCase resendOtpUseCase,
    required CheckAuthStatusUseCase checkAuthStatusUseCase,
    required GetProfileUseCase getProfileUseCase,
    required UpdateProfileUseCase updateProfileUseCase,
    required RegisterDeviceUseCase registerDeviceUseCase,
  }) : _loginUseCase = loginUseCase,
       _signupUseCase = signupUseCase,
       _logoutUseCase = logoutUseCase,
       _resetPasswordUseCase = resetPasswordUseCase,
       _verifyOtpUseCase = verifyOtpUseCase,
       _resendOtpUseCase = resendOtpUseCase,
       _checkAuthStatusUseCase = checkAuthStatusUseCase,
       _getProfileUseCase = getProfileUseCase,
       _updateProfileUseCase = updateProfileUseCase,
       _registerDeviceUseCase = registerDeviceUseCase,
       super(AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthSignupRequested>(_onSignupRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<VerifyOtpRequested>(_onVerifyOtpRequested);
    on<ResendOtpRequested>(_onResendOtpRequested);
  }

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final userId = _checkAuthStatusUseCase();
      if (userId != null) {
        await _handleUserSession(userId, emit);
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
      emit(Unauthenticated());
    }
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _loginUseCase(email: event.email, password: event.password);
    switch (result) {
      case Success():
        final userId = _checkAuthStatusUseCase();
        if (userId != null) {
          await _handleUserSession(userId, emit);
        } else {
          emit(Unauthenticated());
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
  }

  Future<void> _onSignupRequested(
    AuthSignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _signupUseCase(
      email: event.email,
      password: event.password,
      fullName: event.fullName,
    );
    switch (result) {
      case Success():
        final userId = _checkAuthStatusUseCase();
        if (userId != null) {
          await Future.delayed(const Duration(seconds: 1)); // Wait for trigger to complete
          await _handleUserSession(userId, emit);
        } else {
          emit(Unauthenticated());
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
    final result = await _resetPasswordUseCase(email: event.email);
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
    emit(AuthLoading());
    String typeStr = event.type == OtpType.signup ? 'signup' : 'email';
    final result = await _verifyOtpUseCase(
      email: event.email,
      token: event.token,
      type: typeStr,
    );
    
    switch (result) {
      case Success():
        emit(AuthOtpVerified());
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

  Future<void> _handleUserSession(
    String userId,
    Emitter<AuthState> emit,
  ) async {
    try {
      final profile = await _getProfileUseCase(userId);
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

      // If active and profile complete, register device
      await _registerDeviceUseCase(userId);

      emit(Authenticated());
    } catch (e, st) {
      log(
        'Error handling user session',
        name: 'AuthBloc',
        error: e,
        stackTrace: st,
      );
      // Fallback in case profile fetch fails but session is valid
      emit(Unauthenticated());
    }
  }
}
