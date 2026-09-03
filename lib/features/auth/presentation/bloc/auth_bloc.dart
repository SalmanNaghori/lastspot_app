import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/resend_otp_usecase.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/register_device_usecase.dart';
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
    required RegisterDeviceUseCase registerDeviceUseCase,
  }) : _loginUseCase = loginUseCase,
       _signupUseCase = signupUseCase,
       _logoutUseCase = logoutUseCase,
       _resetPasswordUseCase = resetPasswordUseCase,
       _verifyOtpUseCase = verifyOtpUseCase,
       _resendOtpUseCase = resendOtpUseCase,
       _checkAuthStatusUseCase = checkAuthStatusUseCase,
       _getProfileUseCase = getProfileUseCase,
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
    try {
      await _loginUseCase(email: event.email, password: event.password);
      final userId = _checkAuthStatusUseCase();
      if (userId != null) {
        await _handleUserSession(userId, emit);
      } else {
        emit(Unauthenticated());
      }
    } on AuthException catch (e, st) {
      log(
        'AuthException during login: ${e.message}',
        name: 'AuthBloc',
        error: e,
        stackTrace: st,
      );
      emit(AuthError(message: e.message));
      emit(Unauthenticated());
    } catch (e, st) {
      log(
        'Unexpected error during login',
        name: 'AuthBloc',
        error: e,
        stackTrace: st,
      );
      emit(AuthError(message: 'An unexpected error occurred.'));
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignupRequested(
    AuthSignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _signupUseCase(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
      );
      final userId = _checkAuthStatusUseCase();
      if (userId != null) {
        await _handleUserSession(userId, emit);
      } else {
        emit(Unauthenticated());
      }
    } on AuthException catch (e, st) {
      log(
        'AuthException during signup: ${e.message}',
        name: 'AuthBloc',
        error: e,
        stackTrace: st,
      );
      emit(AuthError(message: e.message));
      emit(Unauthenticated());
    } catch (e, st) {
      log(
        'Unexpected error during signup',
        name: 'AuthBloc',
        error: e,
        stackTrace: st,
      );
      emit(AuthError(message: 'An unexpected error occurred.'));
      emit(Unauthenticated());
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _logoutUseCase();
      emit(Unauthenticated());
    } catch (e, st) {
      log(
        'Unexpected error during logout',
        name: 'AuthBloc',
        error: e,
        stackTrace: st,
      );
      emit(AuthError(message: 'Logout failed.'));
      emit(Authenticated());
    }
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _resetPasswordUseCase(email: event.email);
      emit(AuthOtpSent(email: event.email));
    } on AuthException catch (e, st) {
      log(
        'AuthException during password reset: ${e.message}',
        name: 'AuthBloc',
        error: e,
        stackTrace: st,
      );
      emit(AuthError(message: e.message));
    } catch (e, st) {
      log(
        'Unexpected error during password reset',
        name: 'AuthBloc',
        error: e,
        stackTrace: st,
      );
      emit(AuthError(message: 'Failed to send reset email.'));
    }
  }

  Future<void> _onVerifyOtpRequested(
    VerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // Map OtpType enum back to string since UseCase expects string to decouple from Supabase
      String typeStr = event.type == OtpType.signup ? 'signup' : 'email';

      await _verifyOtpUseCase(
        email: event.email,
        token: event.token,
        type: typeStr,
      );
      emit(AuthOtpVerified());
    } on AuthException catch (e, st) {
      log(
        'AuthException during OTP verify: ${e.message}',
        name: 'AuthBloc',
        error: e,
        stackTrace: st,
      );
      emit(AuthError(message: e.message));
    } catch (e, st) {
      log(
        'Unexpected error during OTP verify',
        name: 'AuthBloc',
        error: e,
        stackTrace: st,
      );
      emit(AuthError(message: 'OTP verification failed.'));
    }
  }

  Future<void> _onResendOtpRequested(
    ResendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      String typeStr = event.type == OtpType.signup ? 'signup' : 'email';

      await _resendOtpUseCase(email: event.email, type: typeStr);
      emit(AuthOtpSent(email: event.email));
    } on AuthException catch (e, st) {
      log(
        'AuthException during OTP resend: ${e.message}',
        name: 'AuthBloc',
        error: e,
        stackTrace: st,
      );
      emit(AuthError(message: e.message));
    } catch (e, st) {
      log(
        'Unexpected error during OTP resend',
        name: 'AuthBloc',
        error: e,
        stackTrace: st,
      );
      emit(AuthError(message: 'Failed to resend OTP.'));
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
