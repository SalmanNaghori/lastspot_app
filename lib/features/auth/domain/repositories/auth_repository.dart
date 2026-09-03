abstract class AuthRepository {
  /// Returns the ID of the currently signed-in user, or null if not signed in.
  String? getCurrentUserId();

  /// Signs up a new user with email and password.
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  });

  /// Signs in an existing user with email and password.
  Future<void> signIn({required String email, required String password});

  /// Signs out the current user.
  Future<void> signOut();

  /// Sends a password-reset OTP email to [email].
  Future<void> sendPasswordResetEmail({required String email});

  /// Verifies the OTP entered by the user.
  Future<void> verifyOtp({
    required String email,
    required String token,
    required String type, // OtpType mapped to string to decouple from Supabase
  });

  /// Resends an OTP to [email].
  Future<void> resendOtp({
    required String email,
    required String type, // OtpType mapped to string
  });
}
