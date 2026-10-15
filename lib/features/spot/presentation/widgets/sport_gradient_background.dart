import 'package:lastspot_app/core/base_import.dart';

/// Reusable gradient background displaying the 3D sports equipment illustration
/// when an activity has no user-uploaded cover image.
class SportGradientBackground extends StatelessWidget {
  final String categoryId;

  const SportGradientBackground({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final softTint = AppAssets.getCategorySoftTint(categoryId);
    final fallbackIcon = AppAssets.getCategoryFallbackIcon(categoryId);

    final gradientColors = isDark
        ? [context.surfaceContainer, context.surfaceColor]
        : [softTint.withValues(alpha: 0.9), context.backgroundColor];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(Dimensions.r16.dynamicH),
          child: AppAssets.getCategoryGen(categoryId).image(
            fit: BoxFit.contain,
            cacheWidth: 320,
            cacheHeight: 320,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                fallbackIcon,
                size: Dimensions.r64.dynamicH,
                color: context.primaryColor.withValues(alpha: 0.35),
              );
            },
          ),
        ),
      ),
    );
  }
}
