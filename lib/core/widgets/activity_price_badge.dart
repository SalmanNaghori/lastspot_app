import '../base_import.dart';

/// Reusable branded price indicator/badge for cards, carousels, and activity hero sections.
///
/// Features:
/// - Connects to [ActivityMetadataIcon.priceTag] with KhelBhai Sunset Orange (#F46A35) branding.
/// - Adaptive light and dark theme background, border, and text styling.
/// - Strict responsive [Dimensions] scaling.
/// - Support for custom text formatting or standard localized price display.
class ActivityPriceBadge extends StatelessWidget {
  final double pricePerPerson;
  final String? customText;
  final bool compact;
  final Color? backgroundColor;
  final Color? textColor;

  const ActivityPriceBadge({
    super.key,
    required this.pricePerPerson,
    this.customText,
    this.compact = false,
    this.backgroundColor,
    this.textColor,
  });

  const ActivityPriceBadge.compact({
    super.key,
    required this.pricePerPerson,
    this.customText,
    this.backgroundColor,
    this.textColor,
  }) : compact = true;

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final isFree = pricePerPerson <= 0;
    final text = customText ?? (isFree ? loc.free : '${AppUtils.formatCurrency(pricePerPerson)} / ${loc.perPerson}');

    final effectiveBg = backgroundColor ?? context.surfaceColor.withValues(alpha: 0.95);
    final effectiveText = textColor ?? (isFree ? context.primaryColor : context.textPrimary);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? Dimensions.r8 : Dimensions.r10.dynamicW,
        vertical: compact ? Dimensions.r2 : Dimensions.r4.dynamicH,
      ),
      decoration: BoxDecoration(
        color: effectiveBg,
        borderRadius: BorderRadius.circular(Dimensions.r20.dynamicR),
        border: Border.all(color: context.borderColor.withValues(alpha: 0.5), width: Dimensions.w1),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor.withValues(alpha: 0.08),
            blurRadius: Dimensions.r4.dynamicR,
            offset: Offset(0, Dimensions.r2.dynamicH),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ActivityMetadataIcon.priceTag(
            size: compact ? Dimensions.r12.dynamicH : Dimensions.r14.dynamicH,
            fallbackColor: context.primaryColor,
          ),
          SizedBox(width: Dimensions.r4.dynamicW),
          Text(
            text,
            style: TextStyle(
              color: effectiveText,
              fontSize: compact ? Dimensions.r10.dynamicSP : Dimensions.r11.dynamicSP,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
