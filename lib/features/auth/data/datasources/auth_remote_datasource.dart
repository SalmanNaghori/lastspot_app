import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/device_info_helper.dart';

abstract class AuthRemoteDataSource {
  String? getCurrentUserId();
  Future<void> signUp({required String email, required String password, required String fullName});
  Future<void> signIn({required String email, required String password});
  Future<void> signOut();
  Future<void> sendPasswordResetEmail({required String email});
  Future<void> verifyOtp({required String email, required String token, required String type});
  Future<void> resendOtp({required String email, required String type});
}

class SupabaseAuthDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _client;

  SupabaseAuthDataSourceImpl({required SupabaseClient client}) : _client = client;

  @override
  String? getCurrentUserId() => _client.auth.currentSession?.user.id;

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    await _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
    try {
      await DeviceInfoHelper.recordDevice(_client);
    } catch (_) {}
  }

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    try {
      await DeviceInfoHelper.recordDevice(_client);
    } catch (_) {}
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  @override
  Future<void> verifyOtp({required String email, required String token, required String type}) async {
    await _client.auth.verifyOTP(
      email: email,
      token: token,
      type: _mapOtpType(type),
    );
  }

  @override
  Future<void> resendOtp({required String email, required String type}) async {
    await _client.auth.resend(
      email: email,
      type: _mapOtpType(type),
    );
  }

  OtpType _mapOtpType(String type) {
    if (type == 'email') return OtpType.email;
    if (type == 'signup') return OtpType.signup;
    return OtpType.email; // Default fallback
  }
}
