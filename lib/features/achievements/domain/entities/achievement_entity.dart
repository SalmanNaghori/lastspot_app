import 'package:equatable/equatable.dart';

/// Represents a distinct gamified milestone or sport achievement.
class AchievementEntity extends Equatable {
  final String id;
  final String titleKey;
  final String descriptionKey;
  final String? categorySlug;
  final int targetCount;
  final int currentProgress;
  final bool isUnlocked;
  final bool isCelebrated;
  final String rewardTitleKey;

  const AchievementEntity({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    this.categorySlug,
    required this.targetCount,
    required this.currentProgress,
    required this.isUnlocked,
    required this.isCelebrated,
    required this.rewardTitleKey,
  });

  /// Progress clamped between 0.0 and 1.0 for circular and linear progress indicators.
  double get progressPercentage {
    if (targetCount <= 0) return 1.0;
    return (currentProgress / targetCount).clamp(0.0, 1.0);
  }

  /// Remaining count needed to unlock this achievement.
  int get remainingToUnlock {
    final remaining = targetCount - currentProgress;
    return remaining < 0 ? 0 : remaining;
  }

  /// Whether this achievement is eligible for immediate celebration (unlocked but not yet acknowledged).
  bool get needsCelebration => isUnlocked && !isCelebrated;

  AchievementEntity copyWith({
    String? id,
    String? titleKey,
    String? descriptionKey,
    String? categorySlug,
    int? targetCount,
    int? currentProgress,
    bool? isUnlocked,
    bool? isCelebrated,
    String? rewardTitleKey,
  }) {
    return AchievementEntity(
      id: id ?? this.id,
      titleKey: titleKey ?? this.titleKey,
      descriptionKey: descriptionKey ?? this.descriptionKey,
      categorySlug: categorySlug ?? this.categorySlug,
      targetCount: targetCount ?? this.targetCount,
      currentProgress: currentProgress ?? this.currentProgress,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isCelebrated: isCelebrated ?? this.isCelebrated,
      rewardTitleKey: rewardTitleKey ?? this.rewardTitleKey,
    );
  }

  @override
  List<Object?> get props => [
    id,
    titleKey,
    descriptionKey,
    categorySlug,
    targetCount,
    currentProgress,
    isUnlocked,
    isCelebrated,
    rewardTitleKey,
  ];
}
