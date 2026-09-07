import '../../../../core/utils/result.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository _repository;

  ResetPasswordUseCase(this._repository);

  Future<Result<void, Exception>> call({required String email}) async {
    return _repository.sendPasswordResetEmail(email: email);
  }
}

