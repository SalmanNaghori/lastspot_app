import '../../../../core/utils/result.dart';
import '../entities/city_entity.dart';

abstract class CityRepository {
  Future<Result<List<CityEntity>, Exception>> getActiveCities();
}
