import '../repositories/auth_repository.dart';

class ResendOtpUseCase {
  final AuthRepository _repository;

  ResendOtpUseCase(this._repository);

  Future<void> call({required String email, required String type}) async {
    return _repository.resendOtp(email: email, type: type);
  }
}
