import '../../../../core/base_import.dart';

/// Single metric summary card for My Sports Space dashboard.
///
/// Displays:
/// - 3D Fareeq-style illustration
/// - Stat count (real number from Supabase)
/// - Label (Hosted, Joined, Upcoming, Completed)
/// - Interactive tap feedback
class SportsSummaryCard extends StatelessWidget {
  final String label;
  final int count;
  final AssetGenImage iconGen;
  final VoidCallback? onTap;
  final bool isSelected;

  const SportsSummaryCard({
    super.key,
    required this.label,
    required this.count,
    required this.iconGen,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$label: $count',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.r12.dynamicW,
            vertical: Dimensions.r12.dynamicH,
          ),
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
            border: Border.all(
              color: isSelected
                  ? context.primaryColor
                  : context.colorScheme.outlineVariant.withValues(alpha: 0.35),
              width: isSelected ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColor.blackColor.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: Dimensions.r32.dynamicW,
                    height: Dimensions.r32.dynamicH,
                    child: iconGen.image(
                      width: Dimensions.r32.dynamicW,
                      height: Dimensions.r32.dynamicH,
                      fit: BoxFit.contain,
                      cacheWidth: 160,
                      cacheHeight: 160,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                  Text(
                    '$count',
                    style: TextStyle(
                      fontSize: Dimensions.r20.dynamicSP,
                      fontWeight: FontWeight.w800,
                      color: context.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.r8.dynamicH),
              Text(
                label,
                style: TextStyle(
                  fontSize: Dimensions.r12.dynamicSP,
                  fontWeight: FontWeight.w600,
                  color: context.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
