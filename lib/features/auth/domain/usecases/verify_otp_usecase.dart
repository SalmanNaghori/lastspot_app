import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository _repository;

  VerifyOtpUseCase(this._repository);

  Future<void> call({
    required String email,
    required String token,
    required String type,
  }) async {
    return _repository.verifyOtp(email: email, token: token, type: type);
  }
}
