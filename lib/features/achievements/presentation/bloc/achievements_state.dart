import 'package:equatable/equatable.dart';
import '../../domain/entities/achievement_entity.dart';

sealed class AchievementsState extends Equatable {
  const AchievementsState();

  @override
  List<Object?> get props => [];
}

class AchievementsInitial extends AchievementsState {
  const AchievementsInitial();
}

class AchievementsLoading extends AchievementsState {
  const AchievementsLoading();
}

class AchievementsLoaded extends AchievementsState {
  final List<AchievementEntity> achievements;
  final AchievementEntity? newlyUnlockedAchievement;

  const AchievementsLoaded({
    required this.achievements,
    this.newlyUnlockedAchievement,
  });

  AchievementsLoaded copyWith({
    List<AchievementEntity>? achievements,
    AchievementEntity? newlyUnlockedAchievement,
    bool clearCelebration = false,
  }) {
    return AchievementsLoaded(
      achievements: achievements ?? this.achievements,
      newlyUnlockedAchievement: clearCelebration
          ? null
          : (newlyUnlockedAchievement ?? this.newlyUnlockedAchievement),
    );
  }

  @override
  List<Object?> get props => [achievements, newlyUnlockedAchievement];
}

class AchievementsError extends AchievementsState {
  final String message;

  const AchievementsError(this.message);

  @override
  List<Object?> get props => [message];
}
