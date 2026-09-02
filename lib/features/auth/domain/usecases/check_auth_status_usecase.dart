import '../repositories/auth_repository.dart';

class CheckAuthStatusUseCase {
  final AuthRepository _repository;

  CheckAuthStatusUseCase(this._repository);

  String? call() {
    return _repository.getCurrentUserId();
  }
}
