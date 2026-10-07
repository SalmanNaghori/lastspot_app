import '../repositories/profile_repository.dart';

class GetProfileStatsUseCase {
  final ProfileRepository _repository;

  GetProfileStatsUseCase(this._repository);

  Future<Map<String, int>> call(String userId) {
    return _repository.getProfileStats(userId);
  }
}
