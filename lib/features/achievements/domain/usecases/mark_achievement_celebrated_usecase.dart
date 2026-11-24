import '../repositories/achievements_repository.dart';

class MarkAchievementCelebratedUseCase {
  final AchievementsRepository _repository;

  MarkAchievementCelebratedUseCase(this._repository);

  Future<void> call({
    required String userId,
    required String achievementId,
  }) async {
    return _repository.markAchievementCelebrated(
      userId: userId,
      achievementId: achievementId,
    );
  }
}
