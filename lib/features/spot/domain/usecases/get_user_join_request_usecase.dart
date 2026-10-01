import '../entities/join_request_entity.dart';
import '../repositories/spot_repository.dart';

class GetUserJoinRequestUseCase {
  final SpotRepository _repository;

  GetUserJoinRequestUseCase(this._repository);

  Future<JoinRequestEntity?> call(String spotId) async {
    return _repository.getUserJoinRequest(spotId);
  }
}
