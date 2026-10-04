import '../../../../core/network/base/base_repository.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/repositories/device_repository.dart';
import '../datasources/device_remote_datasource.dart';

class DeviceRepositoryImpl extends BaseRepository implements DeviceRepository {
  final DeviceRemoteDataSource _remoteDataSource;

  DeviceRepositoryImpl({required DeviceRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<void> registerDevice(String userId) {
    return executeApiRaw(
      operationName: ApiEndpoints.deviceRegister,
      requestData: {'user_id': userId},
      operation: () => _remoteDataSource.registerDevice(userId),
    );
  }

  @override
  Future<void> unregisterDevice(String userId) {
    return executeApiRaw(
      operationName: 'device.unregister',
      requestData: {'user_id': userId},
      operation: () => _remoteDataSource.unregisterDevice(userId),
    );
  }
}
