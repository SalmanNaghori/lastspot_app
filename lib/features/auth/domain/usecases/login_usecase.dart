import '../../../../core/utils/result.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Result<void, Exception>> call({required String email, required String password}) async {
    return _repository.signIn(email: email, password: password);
  }
}

