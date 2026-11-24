import '../../../categories/domain/entities/category.dart';
import '../../../spot/domain/entities/request_entity.dart';
import '../entities/achievement_entity.dart';
import '../repositories/achievements_repository.dart';

class GetUserAchievementsUseCase {
  final AchievementsRepository _repository;

  GetUserAchievementsUseCase(this._repository);

  Future<List<AchievementEntity>> call({
    required String userId,
    required List<RequestEntity> userActivities,
    List<CategoryEntity>? categories,
  }) async {
    return _repository.calculateAchievements(
      userId: userId,
      userActivities: userActivities,
      categories: categories,
    );
  }
}
