import 'dart:io';

import '../../../../core/network/network_exceptions.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/city_entity.dart';
import '../../domain/repositories/city_repository.dart';
import '../datasources/city_remote_datasource.dart';

class CityRepositoryImpl implements CityRepository {
  final CityRemoteDataSource _remoteDataSource;

  CityRepositoryImpl({required CityRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Result<List<CityEntity>, Exception>> getActiveCities() async {
    try {
      final cities = await _remoteDataSource.getActiveCities();
      return Success(cities);
    } on SocketException catch (_) {
      return const Failure(NoInternetException());
    } on Exception catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
