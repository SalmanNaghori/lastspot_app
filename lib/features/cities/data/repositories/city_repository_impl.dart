import 'package:lastspot_app/core/network/base/base_repository.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/city_entity.dart';
import '../../domain/repositories/city_repository.dart';
import '../datasources/city_remote_datasource.dart';

class CityRepositoryImpl extends BaseRepository implements CityRepository {
  final CityRemoteDataSource _remoteDataSource;

  CityRepositoryImpl({required CityRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Result<List<CityEntity>, Exception>> getActiveCities() {
    return executeApi(
      operationName: ApiEndpoints.cityGetActive,
      operation: () => _remoteDataSource.getActiveCities(),
    );
  }
}
