import '../repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository _repository;

  ResetPasswordUseCase(this._repository);

  Future<void> call({required String email}) async {
    return _repository.sendPasswordResetEmail(email: email);
  }
}
