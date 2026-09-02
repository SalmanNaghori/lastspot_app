import '../entities/spot_entity.dart';
import '../repositories/spot_repository.dart';

class GetSpotsUseCase {
  final SpotRepository _repository;

  GetSpotsUseCase(this._repository);

  Future<List<SpotEntity>> call({String? category}) async {
    return _repository.getFeedSpots(category: category);
  }
}
