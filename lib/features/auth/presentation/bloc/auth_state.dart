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

/// The backend does not confirm this session/device pair. The session is
/// cleared locally and interactive sign-in is required; the client cannot
/// tell an initial rollout from a session that was replaced elsewhere.
class AuthSessionNeedsSignIn extends AuthState {
  final String? message;

  const AuthSessionNeedsSignIn({this.message});

  @override
  List<Object?> get props => [message];
}

/// Session validation could not reach Supabase. Keep the local session and
/// retry later instead of treating a transport failure as a logout.
class AuthSessionCheckUnavailable extends AuthState {
  final String? message;

  const AuthSessionCheckUnavailable({this.message});

  @override
  List<Object?> get props => [message];
}

class AuthSessionValidationInProgress extends AuthState {}

class AuthPasswordRecoveryReady extends AuthState {}

class AuthPasswordRecoveryInvalid extends AuthState {}

class AuthPasswordRecoveryUpdating extends AuthState {}

class AuthPasswordRecoveryUpdateFailed extends AuthState {
  final String message;

  const AuthPasswordRecoveryUpdateFailed(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthPasswordRecoveryCompleted extends AuthState {}

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
