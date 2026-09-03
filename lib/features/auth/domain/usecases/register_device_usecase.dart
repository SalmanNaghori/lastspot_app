import '../repositories/device_repository.dart';

class RegisterDeviceUseCase {
  final DeviceRepository _repository;

  RegisterDeviceUseCase(this._repository);

  Future<void> call(String userId) {
    return _repository.registerDevice(userId);
  }
}
