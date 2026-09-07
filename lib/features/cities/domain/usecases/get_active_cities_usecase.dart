import '../../../../core/utils/result.dart';
import '../entities/city_entity.dart';
import '../repositories/city_repository.dart';

class GetActiveCitiesUseCase {
  final CityRepository _repository;

  GetActiveCitiesUseCase(this._repository);

  Future<Result<List<CityEntity>, Exception>> call() async {
    return _repository.getActiveCities();
  }
}
