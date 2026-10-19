import '../base_import.dart';

/// Reusable studio-quality 3D sports category icon component.
///
/// Features:
/// - Automatically resolves category UUID, slug, or activity title through [AppAssets].
/// - Enforces responsive [Dimensions] scaling.
/// - Optional soft dimensional background tint matched to the sport category.
/// - Memory-efficient cached asset decoding.
/// - Graceful semantic fallback to category Material icon.
class Category3DIcon extends StatelessWidget {
  final String? category;
  final double? size;
  final double? width;
  final double? height;
  final bool showBackground;
  final double? backgroundPadding;
  final double? borderRadius;
  final BoxFit fit;
  final Color? fallbackColor;

  const Category3DIcon({
    super.key,
    required this.category,
    this.size,
    this.width,
    this.height,
    this.showBackground = false,
    this.backgroundPadding,
    this.borderRadius,
    this.fit = BoxFit.contain,
    this.fallbackColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveWidth = width ?? size ?? Dimensions.r20.dynamicW;
    final effectiveHeight = height ?? size ?? Dimensions.r20.dynamicH;
    final assetGen = AppAssets.getCategoryGen(category);

    final imageWidget = assetGen.image(
      width: effectiveWidth,
      height: effectiveHeight,
      fit: fit,
      cacheWidth: 160,
      cacheHeight: 160,
      filterQuality: FilterQuality.high,
      errorBuilder: (context, error, stackTrace) => Icon(
        AppAssets.getCategoryFallbackIcon(category),
        size: effectiveHeight * 0.85,
        color: fallbackColor ?? context.primaryColor,
      ),
    );

    if (!showBackground) {
      return SizedBox(
        width: effectiveWidth,
        height: effectiveHeight,
        child: Center(child: imageWidget),
      );
    }

    final softTint = AppAssets.getCategorySoftTint(category);
    final pad = backgroundPadding ?? Dimensions.r6.dynamicH;
    final radius = borderRadius ?? Dimensions.r12.dynamicR;

    return Container(
      padding: EdgeInsets.all(pad),
      decoration: BoxDecoration(
        color: context.isDarkMode ? context.surfaceContainer : softTint,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: context.borderColor.withValues(alpha: 0.5),
          width: 0.5,
        ),
      ),
      child: Center(child: imageWidget),
    );
  }
}
