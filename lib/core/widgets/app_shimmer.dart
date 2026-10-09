import 'package:shimmer/shimmer.dart';
import '../base_import.dart';

/// Reusable application-wide Shimmer effect widget.
/// Automatically tunes base and highlight colors according to light/dark theme.
class AppShimmer extends StatelessWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration period;
  final ShimmerDirection direction;

  const AppShimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.period = const Duration(milliseconds: 1500),
    this.direction = ShimmerDirection.ltr,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    final defaultBase = isDark
        ? AppColor.surfaceContainerDark
        : AppColor.dividerLight;

    final defaultHighlight = context.primaryColor.withValues(alpha: 0.5);

    if (MediaQuery.disableAnimationsOf(context)) return child;

    return Shimmer.fromColors(
      baseColor: baseColor ?? defaultBase,
      highlightColor: highlightColor ?? defaultHighlight,
      period: period,
      direction: direction,
      child: child,
    );
  }
}

/// Standalone shimmering skeleton container shape (rectangle, rounded, or circle).
class AppShimmerBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double? borderRadius;
  final bool isCircle;
  final EdgeInsetsGeometry? margin;

  const AppShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.isCircle = false,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final boxColor = isDark
        ? AppColor.surfaceContainerDark
        : AppColor.dividerLight;

    return AppShimmer(
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: boxColor,
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircle
              ? null
              : BorderRadius.circular(borderRadius ?? Dimensions.r8.dynamicR),
        ),
      ),
    );
  }
}
