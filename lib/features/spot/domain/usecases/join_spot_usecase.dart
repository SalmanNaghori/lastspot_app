import '../repositories/spot_repository.dart';

class JoinSpotUseCase {
  final SpotRepository _repository;

  JoinSpotUseCase(this._repository);

  Future<void> call(String spotId, {String message = ''}) async {
    return _repository.requestToJoin(spotId, message: message);
  }
}
