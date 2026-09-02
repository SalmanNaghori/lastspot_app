import '../entities/join_request_entity.dart';
import '../repositories/spot_repository.dart';

class GetConfirmedPlayersUseCase {
  final SpotRepository _repository;

  GetConfirmedPlayersUseCase(this._repository);

  Future<List<JoinRequestEntity>> call(String spotId) async {
    return _repository.getConfirmedPlayers(spotId);
  }
}
