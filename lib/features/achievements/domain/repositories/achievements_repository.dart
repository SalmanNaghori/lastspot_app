import '../../../categories/domain/entities/category.dart';
import '../../../spot/domain/entities/request_entity.dart';
import '../entities/achievement_entity.dart';

/// Contract for computing and persisting achievements.
abstract class AchievementsRepository {
  /// Computes the user's current achievements based on authentic activity records
  /// and local celebration persistence.
  Future<List<AchievementEntity>> calculateAchievements({
    required String userId,
    required List<RequestEntity> userActivities,
    List<CategoryEntity>? categories,
  });

  /// Marks a specific achievement as celebrated for the specified [userId]
  /// so celebration dialogs do not repeat.
  Future<void> markAchievementCelebrated({
    required String userId,
    required String achievementId,
  });

  /// Retrieves the set of achievement IDs already celebrated by [userId].
  Future<Set<String>> getCelebratedAchievementIds({required String userId});
}
