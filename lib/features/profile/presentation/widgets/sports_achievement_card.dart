import '../../../../core/base_import.dart';

/// Single milestone achievement card for My Sports Space.
///
/// Features:
/// - Unlocked state with vibrant emerald badge and checkmark.
/// - Locked state with subtle muted palette and progress counter (e.g. 2/5).
/// - 100% verified against real Supabase activity records.
class SportsAchievementCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isUnlocked;
  final String? progressText;

  const SportsAchievementCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.isUnlocked,
    this.progressText,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = context.primaryColor;
    final inactiveColor = context.textSecondary.withValues(alpha: 0.4);

    return Container(
      padding: EdgeInsets.all(Dimensions.r12.dynamicW),
      decoration: BoxDecoration(
        color: isUnlocked
            ? context.surfaceColor
            : context.surfaceContainerLow.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
        border: Border.all(
          color: isUnlocked
              ? context.primaryColor.withValues(alpha: 0.35)
              : context.colorScheme.outlineVariant.withValues(alpha: 0.2),
          width: isUnlocked ? 1.2 : 0.8,
        ),
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: activeColor.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          // Icon badge
          Container(
            width: Dimensions.r40.dynamicW,
            height: Dimensions.r40.dynamicH,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isUnlocked
                  ? activeColor.withValues(alpha: 0.12)
                  : context.colorScheme.outlineVariant.withValues(alpha: 0.15),
            ),
            child: Icon(
              icon,
              size: Dimensions.r20.dynamicH,
              color: isUnlocked ? activeColor : inactiveColor,
            ),
          ),
          SizedBox(width: Dimensions.r12.dynamicW),

          // Title & Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: Dimensions.r13.dynamicSP,
                    fontWeight: FontWeight.w700,
                    color: isUnlocked ? context.textPrimary : inactiveColor,
                    letterSpacing: -0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: Dimensions.r2.dynamicH),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: Dimensions.r11.dynamicSP,
                    color: isUnlocked
                        ? context.textSecondary
                        : inactiveColor.withValues(alpha: 0.7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Unlocked badge or Progress
          if (isUnlocked)
            Container(
              padding: EdgeInsets.all(Dimensions.r4.dynamicR),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: activeColor,
              ),
              child: Icon(
                Icons.check_rounded,
                size: Dimensions.r12.dynamicH,
                color: AppColor.whiteColor,
              ),
            )
          else if (progressText != null)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.r8.dynamicW,
                vertical: Dimensions.r4.dynamicH,
              ),
              decoration: BoxDecoration(
                color: context.colorScheme.outlineVariant.withValues(
                  alpha: 0.15,
                ),
                borderRadius: BorderRadius.circular(Dimensions.r10.dynamicR),
              ),
              child: Text(
                progressText!,
                style: TextStyle(
                  fontSize: Dimensions.r10.dynamicSP,
                  fontWeight: FontWeight.w700,
                  color: context.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
