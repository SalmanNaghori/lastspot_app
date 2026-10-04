import '../../../../core/utils/result.dart';
import '../repositories/auth_repository.dart';
import '../repositories/device_repository.dart';

class LogoutUseCase {
  final AuthRepository _repository;
  final DeviceRepository _deviceRepository;

  LogoutUseCase(this._repository, this._deviceRepository);

  Future<Result<void, Exception>> call() async {
    final userId = _repository.getCurrentUserId();
    if (userId != null) {
      await _deviceRepository.unregisterDevice(userId);
    }
    return _repository.signOut();
  }
}
