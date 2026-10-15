import '../../../../core/utils/result.dart';
import '../repositories/auth_repository.dart';

class UpdatePasswordUseCase {
  final AuthRepository _repository;

  UpdatePasswordUseCase(this._repository);

  Future<Result<void, Exception>> call({required String password}) {
    return _repository.updatePassword(password: password);
  }
}
