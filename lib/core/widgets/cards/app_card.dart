import '../../base_import.dart';

/// Standard Material 3 card surface for the KhelBhai design system.
///
/// Features:
/// - Supports custom padding, margin, border radius, background color, and border.
/// - InkWell splash feedback when [onTap] is provided.
/// - Outlined preset [AppCard.outlined] for clean modern list tiles and containers.
class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? elevation;
  final BorderRadius? borderRadius;
  final BorderSide? border;
  final Clip clipBehavior;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.color,
    this.elevation,
    this.borderRadius,
    this.border,
    this.clipBehavior = Clip.antiAlias,
  });

  const AppCard.outlined({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.border,
    this.clipBehavior = Clip.antiAlias,
  }) : elevation = 0;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius =
        borderRadius ?? BorderRadius.circular(Dimensions.r16.dynamicR);
    final effectiveBorder =
        border ??
        (elevation == 0
            ? BorderSide(color: context.borderColor.withValues(alpha: 0.6))
            : BorderSide.none);

    Widget cardContent = padding != null
        ? Padding(padding: padding!, child: child)
        : child;

    if (onTap != null) {
      cardContent = InkWell(
        onTap: onTap,
        borderRadius: effectiveRadius,
        child: cardContent,
      );
    }

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: Material(
        color: color ?? context.surfaceColor,
        elevation: elevation ?? (context.isDarkMode ? 0 : 0.5),
        shadowColor: context.colorScheme.shadow.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: effectiveRadius,
          side: effectiveBorder,
        ),
        clipBehavior: clipBehavior,
        child: cardContent,
      ),
    );
  }
}
