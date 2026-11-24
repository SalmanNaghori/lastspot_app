import 'package:lastspot_app/core/base_import.dart';

import '../../domain/entities/achievement_entity.dart';
import 'achievement_badge_icon.dart';
import 'glowing_circular_progress.dart';

/// Bottom sheet displaying in-depth progress and reward information for an achievement.
class AchievementDetailBottomSheet extends StatelessWidget {
  final AchievementEntity achievement;

  const AchievementDetailBottomSheet({super.key, required this.achievement});

  static Future<void> show({
    required BuildContext context,
    required AchievementEntity achievement,
  }) {
    return AppBottomSheet.show(
      context: context,
      builder: (ctx) => AchievementDetailBottomSheet(achievement: achievement),
    );
  }

  void _onClosePressed(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final title = _getLocalizedTitle(context);
    final desc = _getLocalizedDesc(context);
    final reward = _getLocalizedReward(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.r20.dynamicW,
        vertical: Dimensions.r16.dynamicH,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Badge & Progress
          GlowingCircularProgress(
            progress: achievement.progressPercentage,
            isUnlocked: achievement.isUnlocked,
            size: Dimensions.r72.dynamicH,
            strokeWidth: Dimensions.r4.dynamicW,
            child: AchievementBadgeIcon(
              categorySlug: achievement.categorySlug,
              isUnlocked: achievement.isUnlocked,
              size: Dimensions.r48.dynamicH,
            ),
          ),
          SizedBox(height: Dimensions.r16.dynamicH),

          // 2. Status Badge
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.r12.dynamicW,
              vertical: Dimensions.r4.dynamicH,
            ),
            decoration: BoxDecoration(
              color: achievement.isUnlocked
                  ? context.successColor.withValues(alpha: 0.12)
                  : context.primaryColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
              border: Border.all(
                color: achievement.isUnlocked
                    ? context.successColor.withValues(alpha: 0.3)
                    : context.primaryColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  achievement.isUnlocked
                      ? Icons.check_circle_rounded
                      : Icons.hourglass_top_rounded,
                  size: Dimensions.r14.dynamicH,
                  color: achievement.isUnlocked
                      ? context.successColor
                      : context.primaryColor,
                ),
                SizedBox(width: Dimensions.r4.dynamicW),
                Text(
                  achievement.isUnlocked
                      ? context.loc.achievementStatusUnlocked
                      : context.loc.achievementStatusInProgress,
                  style: context.labelSmall?.copyWith(
                    color: achievement.isUnlocked
                        ? context.successColor
                        : context.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Dimensions.r12.dynamicH),

          // 3. Title & Description
          Text(
            title,
            style: context.titleLarge?.copyWith(
              color: context.textPrimary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Dimensions.r6.dynamicH),
          Text(
            desc,
            style: context.bodyMedium?.copyWith(color: context.textSecondary),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Dimensions.r20.dynamicH),

          // 4. Progress Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(Dimensions.r16.dynamicW),
            decoration: BoxDecoration(
              color: context.surfaceContainerLow,
              borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
              border: Border.all(
                color: context.borderColor.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.loc.achievementDetailsTitle,
                      style: context.labelMedium?.copyWith(
                        color: context.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${achievement.currentProgress} / ${achievement.targetCount}',
                      style: context.labelLarge?.copyWith(
                        color: context.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.r8.dynamicH),
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.r8.dynamicR),
                  child: LinearProgressIndicator(
                    value: achievement.progressPercentage,
                    minHeight: Dimensions.r8.dynamicH,
                    backgroundColor: context.isDarkMode
                        ? context.surfaceContainerHigh
                        : context.borderColor.withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      achievement.isUnlocked
                          ? context.successColor
                          : context.primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.r8.dynamicH),
                Text(
                  _getStatusText(context),
                  style: context.bodySmall?.copyWith(
                    color: achievement.isUnlocked
                        ? context.successColor
                        : context.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Dimensions.r16.dynamicH),

          // 5. Reward Milestone
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.r16.dynamicW,
              vertical: Dimensions.r12.dynamicH,
            ),
            decoration: BoxDecoration(
              color: context.primaryContainer.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.emoji_events_rounded,
                  size: Dimensions.r24.dynamicH,
                  color: context.primaryColor,
                ),
                SizedBox(width: Dimensions.r12.dynamicW),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.loc.achievementRewardMilestone,
                        style: context.labelSmall?.copyWith(
                          color: context.textTertiary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        reward,
                        style: context.titleSmall?.copyWith(
                          color: context.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Dimensions.r24.dynamicH),

          // 6. Action Button
          AppButton(
            label: context.loc.confirmAction,
            onPressed: () => _onClosePressed(context),
          ),
          SizedBox(height: Dimensions.r8.dynamicH),
        ],
      ),
    );
  }

  String _getLocalizedTitle(BuildContext context) {
    switch (achievement.titleKey) {
      case 'achievementCricketChampion':
        return context.loc.achievementCricketChampion;
      case 'achievementFootballStar':
        return context.loc.achievementFootballStar;
      case 'achievementEventOrganizer':
        return context.loc.achievementEventOrganizer;
      case 'achievementBadmintonPro':
        return context.loc.achievementBadmintonPro;
      case 'achievementActivityCreator':
        return context.loc.achievementActivityCreator;
      default:
        return achievement.titleKey;
    }
  }

  String _getLocalizedDesc(BuildContext context) {
    switch (achievement.descriptionKey) {
      case 'achievementCricketChampionDesc':
        return context.loc.achievementCricketChampionDesc;
      case 'achievementFootballStarDesc':
        return context.loc.achievementFootballStarDesc;
      case 'achievementEventOrganizerDesc':
        return context.loc.achievementEventOrganizerDesc;
      case 'achievementBadmintonProDesc':
        return context.loc.achievementBadmintonProDesc;
      case 'achievementActivityCreatorDesc':
        return context.loc.achievementActivityCreatorDesc;
      default:
        return achievement.descriptionKey;
    }
  }

  String _getLocalizedReward(BuildContext context) {
    switch (achievement.rewardTitleKey) {
      case 'achievementRewardGoldTrophy':
        return context.loc.achievementRewardGoldTrophy;
      case 'achievementRewardStarBadge':
        return context.loc.achievementRewardStarBadge;
      case 'achievementRewardHostBadge':
        return context.loc.achievementRewardHostBadge;
      case 'achievementRewardAceBadge':
        return context.loc.achievementRewardAceBadge;
      case 'achievementRewardCreatorTrophy':
        return context.loc.achievementRewardCreatorTrophy;
      default:
        return achievement.rewardTitleKey;
    }
  }

  String _getStatusText(BuildContext context) {
    if (achievement.isUnlocked) {
      return context.loc.achievementUnlocked;
    }
    if (achievement.remainingToUnlock == 1) {
      return context.loc.achievementOneMoreToUnlock;
    }
    return context.loc.achievementXMoreToUnlock(achievement.remainingToUnlock);
  }
}
