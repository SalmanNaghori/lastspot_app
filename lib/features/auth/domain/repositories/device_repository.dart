abstract class DeviceRepository {
  /// Registers or updates the current device for the given [userId].
  Future<void> registerDevice(String userId);
}
