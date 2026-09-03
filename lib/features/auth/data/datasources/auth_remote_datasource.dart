import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lastspot_app/core/network/supabase_logger.dart';

abstract class AuthRemoteDataSource {
  String? getCurrentUserId();
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  });
  Future<void> signIn({required String email, required String password});
  Future<void> signOut();
  Future<void> sendPasswordResetEmail({required String email});
  Future<void> verifyOtp({
    required String email,
    required String token,
    required String type,
  });
  Future<void> resendOtp({required String email, required String type});
}

class SupabaseAuthDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _client;

  SupabaseAuthDataSourceImpl({required SupabaseClient client})
    : _client = client;

  @override
  String? getCurrentUserId() => _client.auth.currentSession?.user.id;

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    return SupabaseLogger.execute(
      operationName: 'Auth.signUp',
      requestData: {'email': email, 'full_name': fullName},
      operation: () => _client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      ),
    );
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    return SupabaseLogger.execute(
      operationName: 'Auth.signIn',
      requestData: {'email': email},
      operation: () =>
          _client.auth.signInWithPassword(email: email, password: password),
    );
  }

  @override
  Future<void> signOut() async {
    return SupabaseLogger.execute(
      operationName: 'Auth.signOut',
      operation: () => _client.auth.signOut(),
    );
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    return SupabaseLogger.execute(
      operationName: 'Auth.sendPasswordResetEmail',
      requestData: {'email': email},
      operation: () => _client.auth.resetPasswordForEmail(email),
    );
  }

  @override
  Future<void> verifyOtp({
    required String email,
    required String token,
    required String type,
  }) async {
    return SupabaseLogger.execute(
      operationName: 'Auth.verifyOtp',
      requestData: {'email': email, 'type': type},
      operation: () => _client.auth.verifyOTP(
        email: email,
        token: token,
        type: _mapOtpType(type),
      ),
    );
  }

  @override
  Future<void> resendOtp({required String email, required String type}) async {
    return SupabaseLogger.execute(
      operationName: 'Auth.resendOtp',
      requestData: {'email': email, 'type': type},
      operation: () =>
          _client.auth.resend(email: email, type: _mapOtpType(type)),
    );
  }

  OtpType _mapOtpType(String type) {
    if (type == 'email') return OtpType.email;
    if (type == 'signup') return OtpType.signup;
    return OtpType.email; // Default fallback
  }
}
