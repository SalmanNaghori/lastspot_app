import 'package:lastspot_app/core/base_import.dart';
import '../../domain/entities/achievement_entity.dart';
import 'achievement_badge_icon.dart';
import 'glowing_circular_progress.dart';

/// Full celebration modal shown when an achievement is newly unlocked (hits 100%).
class AchievementCelebrationDialog extends StatefulWidget {
  final AchievementEntity achievement;
  final VoidCallback onContinue;

  const AchievementCelebrationDialog({
    super.key,
    required this.achievement,
    required this.onContinue,
  });

  static bool _isShowing = false;

  static Future<void> show({
    required BuildContext context,
    required AchievementEntity achievement,
    required VoidCallback onContinue,
  }) async {
    if (_isShowing) return;
    _isShowing = true;

    try {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        barrierColor: context.colorScheme.scrim.withValues(alpha: 0.75),
        builder: (dialogContext) => AchievementCelebrationDialog(
          achievement: achievement,
          onContinue: () {
            Navigator.of(dialogContext, rootNavigator: true).pop();
            onContinue();
          },
        ),
      );
    } finally {
      _isShowing = false;
    }
  }

  @override
  State<AchievementCelebrationDialog> createState() =>
      _AchievementCelebrationDialogState();
}

class _AchievementCelebrationDialogState
    extends State<AchievementCelebrationDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _badgeAnimController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _badgeAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _badgeAnimController,
      curve: Curves.elasticOut,
    );

    _badgeAnimController.forward();
  }

  @override
  void dispose() {
    _badgeAnimController.dispose();
    super.dispose();
  }

  void _handleContinuePressed() {
    widget.onContinue();
  }

  @override
  Widget build(BuildContext context) {
    final title = _getLocalizedTitle(context);
    final desc = _getLocalizedDesc(context);
    final reward = _getLocalizedReward(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: Dimensions.r20.dynamicW),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // 1. Modal Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.r20.dynamicW,
              vertical: Dimensions.r24.dynamicH,
            ),
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(Dimensions.r24.dynamicR),
              boxShadow: [
                BoxShadow(
                  color: context.colorScheme.shadow.withValues(alpha: 0.15),
                  blurRadius: Dimensions.r24.dynamicR,
                  spreadRadius: Dimensions.r4.dynamicR,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: Dimensions.r8.dynamicH),

                // Animated Pulsing Badge
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: GlowingCircularProgress(
                    progress: 1.0,
                    isUnlocked: true,
                    size: Dimensions.r80.dynamicH,
                    strokeWidth: Dimensions.r4.dynamicW,
                    child: AchievementBadgeIcon(
                      categorySlug: widget.achievement.categorySlug,
                      isUnlocked: true,
                      size: Dimensions.r56.dynamicH,
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.r20.dynamicH),

                // Unlocked Tag
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.r14.dynamicW,
                    vertical: Dimensions.r4.dynamicH,
                  ),
                  decoration: BoxDecoration(
                    color: context.successColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(
                      Dimensions.r16.dynamicR,
                    ),
                    border: Border.all(
                      color: context.successColor.withValues(alpha: 0.35),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.stars_rounded,
                        size: Dimensions.r16.dynamicH,
                        color: context.successColor,
                      ),
                      SizedBox(width: Dimensions.r6.dynamicW),
                      Text(
                        context.loc.achievementCelebrationTitle,
                        style: context.labelSmall?.copyWith(
                          color: context.successColor,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Dimensions.r12.dynamicH),

                // Achievement Title
                Text(
                  title,
                  style: context.headlineSmall?.copyWith(
                    color: context.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Dimensions.r6.dynamicH),

                // Description
                Text(
                  desc,
                  style: context.bodyMedium?.copyWith(
                    color: context.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Dimensions.r16.dynamicH),

                // Reward Showcase
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.r14.dynamicW,
                    vertical: Dimensions.r10.dynamicH,
                  ),
                  decoration: BoxDecoration(
                    color: context.primaryContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(
                      Dimensions.r12.dynamicR,
                    ),
                    border: Border.all(
                      color: context.primaryColor.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.military_tech_rounded,
                        size: Dimensions.r20.dynamicH,
                        color: context.primaryColor,
                      ),
                      SizedBox(width: Dimensions.r8.dynamicW),
                      Text(
                        '${context.loc.achievementRewardMilestone}: ',
                        style: context.bodySmall?.copyWith(
                          color: context.textTertiary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        reward,
                        style: context.titleSmall?.copyWith(
                          color: context.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Dimensions.r24.dynamicH),

                // Continue Button
                AppButton(
                  label: context.loc.achievementCelebrationContinue,
                  onPressed: _handleContinuePressed,
                ),
              ],
            ),
          ),

          // 2. Confetti Lottie Overlay
          Positioned.fill(
            child: IgnorePointer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.r24.dynamicR),
                child: Assets.ain.anCongratulationScreen.lottie(
                  fit: BoxFit.cover,
                  repeat: false,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getLocalizedTitle(BuildContext context) {
    switch (widget.achievement.titleKey) {
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
        return widget.achievement.titleKey;
    }
  }

  String _getLocalizedDesc(BuildContext context) {
    switch (widget.achievement.descriptionKey) {
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
        return widget.achievement.descriptionKey;
    }
  }

  String _getLocalizedReward(BuildContext context) {
    switch (widget.achievement.rewardTitleKey) {
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
        return widget.achievement.rewardTitleKey;
    }
  }
}
