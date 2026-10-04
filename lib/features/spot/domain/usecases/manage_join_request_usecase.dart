import '../repositories/spot_repository.dart';

class ManageJoinRequestUseCase {
  final SpotRepository _repository;

  ManageJoinRequestUseCase(this._repository);

  Future<void> accept(String joinRequestId) async {
    return _repository.acceptJoinRequest(joinRequestId);
  }

  Future<void> reject(String joinRequestId) async {
    return _repository.rejectJoinRequest(joinRequestId);
  }

  Future<void> cancel(String joinRequestId) async {
    return _repository.cancelJoinRequest(joinRequestId);
  }
}
