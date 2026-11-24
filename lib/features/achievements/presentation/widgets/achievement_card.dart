import 'package:lastspot_app/core/base_import.dart';
import '../../domain/entities/achievement_entity.dart';
import 'achievement_badge_icon.dart';
import 'achievement_detail_bottom_sheet.dart';
import 'glowing_circular_progress.dart';

/// Card displaying an individual achievement milestone in the horizontal carousel.
class AchievementCard extends StatelessWidget {
  final AchievementEntity achievement;

  const AchievementCard({super.key, required this.achievement});

  void _onCardTapped(BuildContext context) {
    AchievementDetailBottomSheet.show(
      context: context,
      achievement: achievement,
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = _getLocalizedTitle(context);
    final statusSubtitle = _getStatusSubtitle(context);

    return InkWell(
      onTap: () => _onCardTapped(context),
      borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
      child: Container(
        width: Dimensions.r160.dynamicW,
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.r12.dynamicW,
          vertical: Dimensions.r14.dynamicH,
        ),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
          border: Border.all(
            color: achievement.isUnlocked
                ? context.successColor.withValues(alpha: 0.35)
                : context.borderColor.withValues(alpha: 0.55),
            width: achievement.isUnlocked ? 1.2 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: context.colorScheme.shadow.withValues(
                alpha: context.isDarkMode ? 0.2 : 0.04,
              ),
              blurRadius: Dimensions.r8.dynamicR,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Circular Progress with 3D Badge
            GlowingCircularProgress(
              progress: achievement.progressPercentage,
              isUnlocked: achievement.isUnlocked,
              size: Dimensions.r56.dynamicH,
              strokeWidth: Dimensions.r4.dynamicW,
              child: AchievementBadgeIcon(
                categorySlug: achievement.categorySlug,
                isUnlocked: achievement.isUnlocked,
                size: Dimensions.r36.dynamicH,
              ),
            ),
            SizedBox(height: Dimensions.r10.dynamicH),

            // Achievement Title
            Text(
              title,
              style: context.titleSmall?.copyWith(
                color: context.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Dimensions.r4.dynamicH),

            // Progress Count: 3 / 5
            Text(
              '${achievement.currentProgress} / ${achievement.targetCount}',
              style: context.labelMedium?.copyWith(
                color: achievement.isUnlocked
                    ? context.successColor
                    : context.primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: Dimensions.r6.dynamicH),

            // Status Pill
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.r8.dynamicW,
                vertical: Dimensions.r2.dynamicH,
              ),
              decoration: BoxDecoration(
                color: achievement.isUnlocked
                    ? context.successColor.withValues(alpha: 0.12)
                    : context.primaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(Dimensions.r10.dynamicR),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    achievement.isUnlocked
                        ? Icons.check_circle_rounded
                        : Icons.timelapse_rounded,
                    size: Dimensions.r12.dynamicH,
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
                      fontSize: Dimensions.r10.dynamicSP,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.r6.dynamicH),

            // Remaining / Milestone Subtitle
            Text(
              statusSubtitle,
              style: context.bodySmall?.copyWith(
                color: achievement.isUnlocked
                    ? context.successColor
                    : context.textTertiary,
                fontSize: Dimensions.r10.dynamicSP,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
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

  String _getStatusSubtitle(BuildContext context) {
    if (achievement.isUnlocked) {
      return context.loc.achievementUnlocked;
    }
    if (achievement.remainingToUnlock == 1) {
      return context.loc.achievementOneMoreToUnlock;
    }
    return context.loc.achievementXMoreToUnlock(achievement.remainingToUnlock);
  }
}
