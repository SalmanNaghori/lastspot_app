import 'package:lastspot_app/core/base_import.dart';

/// Renders a category 3D icon or special achievement trophy badge.
class AchievementBadgeIcon extends StatelessWidget {
  final String? categorySlug;
  final bool isUnlocked;
  final double size;

  const AchievementBadgeIcon({
    super.key,
    required this.categorySlug,
    required this.isUnlocked,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveCategory = categorySlug ?? 'other';

    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(Dimensions.r4.dynamicH),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isUnlocked
            ? context.primaryColor.withValues(alpha: 0.12)
            : context.surfaceContainerLow,
      ),
      child: Center(
        child: Category3DIcon(
          category: effectiveCategory,
          size: size * 0.72,
          fit: BoxFit.contain,
          showBackground: false,
        ),
      ),
    );
  }
}
