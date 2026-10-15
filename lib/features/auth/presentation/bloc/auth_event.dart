import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

/// Rechecks the current account session when the app resumes.
class AuthSessionValidationRequested extends AuthEvent {}

class AuthRecoveryLinkDetected extends AuthEvent {
  final bool malformed;

  const AuthRecoveryLinkDetected({this.malformed = false});

  @override
  List<Object> get props => [malformed];
}

class AuthRecoverySessionEstablished extends AuthEvent {}

class AuthRecoveryExchangeFailed extends AuthEvent {}

class PasswordRecoveryUpdateRequested extends AuthEvent {
  final String password;

  const PasswordRecoveryUpdateRequested({required this.password});

  @override
  List<Object> get props => [password];
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthSignupRequested extends AuthEvent {
  final String email;
  final String password;
  final String fullName;

  const AuthSignupRequested({
    required this.email,
    required this.password,
    required this.fullName,
  });

  @override
  List<Object> get props => [email, password, fullName];
}

class AuthLogoutRequested extends AuthEvent {}

/// Triggers sending a password-reset OTP to [email].
class ForgotPasswordRequested extends AuthEvent {
  final String email;

  const ForgotPasswordRequested({required this.email});

  @override
  List<Object> get props => [email];
}

/// Submits the 6-digit OTP the user received via email.
class VerifyOtpRequested extends AuthEvent {
  final String email;
  final String token;
  final OtpType type;

  const VerifyOtpRequested({
    required this.email,
    required this.token,
    required this.type,
  });

  @override
  List<Object> get props => [email, token, type];
}

/// Resends the OTP to [email].
class ResendOtpRequested extends AuthEvent {
  final String email;
  final OtpType type;

  const ResendOtpRequested({required this.email, required this.type});

  @override
  List<Object> get props => [email, type];
}

/// Dispatched by the UI when the user finishes profile completion.
class AuthProfileCompleted extends AuthEvent {}
