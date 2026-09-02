import '../repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository _repository;

  SignupUseCase(this._repository);

  Future<void> call({
    required String email,
    required String password,
    required String fullName,
  }) async {
    return _repository.signUp(email: email, password: password, fullName: fullName);
  }
}
