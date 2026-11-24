import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../categories/domain/entities/category.dart';
import '../../../spot/domain/entities/request_entity.dart';
import '../../domain/usecases/get_user_achievements_usecase.dart';
import '../../domain/usecases/mark_achievement_celebrated_usecase.dart';
import 'achievements_state.dart';

class AchievementsCubit extends Cubit<AchievementsState> {
  final GetUserAchievementsUseCase _getUserAchievementsUseCase;
  final MarkAchievementCelebratedUseCase _markAchievementCelebratedUseCase;

  AchievementsCubit({
    required GetUserAchievementsUseCase getUserAchievementsUseCase,
    required MarkAchievementCelebratedUseCase markAchievementCelebratedUseCase,
  }) : _getUserAchievementsUseCase = getUserAchievementsUseCase,
       _markAchievementCelebratedUseCase = markAchievementCelebratedUseCase,
       super(const AchievementsInitial());

  Future<void> loadAchievements({
    required String userId,
    required List<RequestEntity> userActivities,
    List<CategoryEntity>? categories,
  }) async {
    try {
      final achievements = await _getUserAchievementsUseCase(
        userId: userId,
        userActivities: userActivities,
        categories: categories,
      );

      // Check if any achievement requires celebration
      final newlyUnlocked = achievements
          .where((a) => a.needsCelebration)
          .toList();
      final toCelebrate = newlyUnlocked.isNotEmpty ? newlyUnlocked.first : null;

      emit(
        AchievementsLoaded(
          achievements: achievements,
          newlyUnlockedAchievement: toCelebrate,
        ),
      );
    } catch (e) {
      emit(AchievementsError(e.toString()));
    }
  }

  Future<void> acknowledgeCelebration({
    required String userId,
    required String achievementId,
  }) async {
    final currentState = state;
    if (currentState is! AchievementsLoaded) return;

    try {
      await _markAchievementCelebratedUseCase(
        userId: userId,
        achievementId: achievementId,
      );

      final updatedAchievements = currentState.achievements.map((item) {
        if (item.id == achievementId) {
          return item.copyWith(isCelebrated: true);
        }
        return item;
      }).toList();

      // Check if there are further achievements pending celebration
      final nextNewlyUnlocked = updatedAchievements
          .where((a) => a.needsCelebration)
          .toList();

      emit(
        currentState.copyWith(
          achievements: updatedAchievements,
          newlyUnlockedAchievement: nextNewlyUnlocked.isNotEmpty
              ? nextNewlyUnlocked.first
              : null,
          clearCelebration: nextNewlyUnlocked.isEmpty,
        ),
      );
    } catch (_) {
      // Even if marking failed in storage, dismiss popup locally
      emit(currentState.copyWith(clearCelebration: true));
    }
  }
}
