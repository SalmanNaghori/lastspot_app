import '../../../../core/utils/result.dart';
import '../repositories/auth_repository.dart';

class ResendOtpUseCase {
  final AuthRepository _repository;

  ResendOtpUseCase(this._repository);

  Future<Result<void, Exception>> call({required String email, required String type}) async {
    return _repository.resendOtp(email: email, type: type);
  }
}

