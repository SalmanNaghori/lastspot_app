import '../../../../core/utils/result.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  Future<Result<void, Exception>> call() async {
    return _repository.signOut();
  }
}

