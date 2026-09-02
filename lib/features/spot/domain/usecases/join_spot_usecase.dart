import '../repositories/spot_repository.dart';

class JoinSpotUseCase {
  final SpotRepository _repository;

  JoinSpotUseCase(this._repository);

  Future<void> call(String spotId) async {
    return _repository.requestToJoin(spotId);
  }
}
