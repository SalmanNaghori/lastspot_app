import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {}

class AuthProfileIncomplete extends AuthState {}

class AuthSuspended extends AuthState {}

class AuthBanned extends AuthState {}

class AuthDeleted extends AuthState {}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Emitted after a password-reset OTP email is sent successfully.
/// The UI should navigate to the OTP entry screen.
class AuthOtpSent extends AuthState {
  final String email;

  const AuthOtpSent({required this.email});

  @override
  List<Object?> get props => [email];
}

/// Emitted after OTP is successfully verified.
/// The UI should navigate to the new-password / home screen as appropriate.
class AuthOtpVerified extends AuthState {}
