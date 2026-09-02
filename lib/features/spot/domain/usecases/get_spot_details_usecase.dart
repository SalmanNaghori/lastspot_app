import '../entities/spot_entity.dart';
import '../repositories/spot_repository.dart';

class GetSpotDetailsUseCase {
  final SpotRepository _repository;

  GetSpotDetailsUseCase(this._repository);

  Future<SpotEntity> call(String spotId) async {
    return _repository.getSpotDetails(spotId);
  }
}
