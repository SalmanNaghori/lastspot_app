import '../entities/join_request_entity.dart';
import '../repositories/spot_repository.dart';

class StreamSpotJoinRequestsUseCase {
  final SpotRepository _repository;

  StreamSpotJoinRequestsUseCase(this._repository);

  Stream<List<JoinRequestEntity>> call(String spotId) {
    return _repository.streamPendingRequests(spotId);
  }
}
