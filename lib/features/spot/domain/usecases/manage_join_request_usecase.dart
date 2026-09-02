import '../repositories/spot_repository.dart';

class ManageJoinRequestUseCase {
  final SpotRepository _repository;

  ManageJoinRequestUseCase(this._repository);

  Future<void> call({
    required String joinRequestId,
    required String status,
  }) async {
    return _repository.updateJoinRequestStatus(
      joinRequestId: joinRequestId,
      status: status,
    );
  }
}
