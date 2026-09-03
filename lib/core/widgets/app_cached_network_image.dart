import 'package:cached_network_image/cached_network_image.dart';
import '../base_import.dart';

/// App-wide cached network image widget with smooth loading shimmer/pulse
/// animations and graceful error fallbacks.
class AppCachedNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final bool isCircle;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Color? backgroundColor;

  const AppCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.isCircle = false,
    this.placeholder,
    this.errorWidget,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (imageUrl == null || imageUrl!.trim().isEmpty) {
      content = _buildErrorWidget(context);
    } else {
      content = CachedNetworkImage(
        imageUrl: imageUrl!.trim(),
        width: width,
        height: height,
        fit: fit,
        fadeInDuration: const Duration(milliseconds: 300),
        fadeOutDuration: const Duration(milliseconds: 200),
        placeholder: (context, url) =>
            placeholder ?? _AnimatedImagePlaceholder(width: width, height: height, isCircle: isCircle),
        errorWidget: (context, url, error) => _buildErrorWidget(context),
      );
    }

    if (isCircle) {
      return ClipOval(child: content);
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: content);
    }

    return content;
  }

  Widget _buildErrorWidget(BuildContext context) {
    if (errorWidget != null) return errorWidget!;

    return _AnimatedImageError(width: width, height: height, isCircle: isCircle, backgroundColor: backgroundColor);
  }
}

/// Smooth shimmering placeholder animation while images load.
class _AnimatedImagePlaceholder extends StatelessWidget {
  final double? width;
  final double? height;
  final bool isCircle;

  const _AnimatedImagePlaceholder({this.width, this.height, required this.isCircle});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final baseColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

    return AppShimmer(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          color: baseColor,
        ),
        child: Center(
          child: Icon(
            Icons.image_outlined,
            size: Dimensions.r24.dynamicH,
            color: context.textSecondary.withValues(alpha: 0.35),
          ),
        ),
      ),
    );
  }
}

/// Graceful fallback error widget with smooth fade-in.
class _AnimatedImageError extends StatelessWidget {
  final double? width;
  final double? height;
  final bool isCircle;
  final Color? backgroundColor;

  const _AnimatedImageError({this.width, this.height, required this.isCircle, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
      builder: (context, opacity, child) {
        return Opacity(
          opacity: opacity,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
              color: backgroundColor ?? (context.isDarkMode ? context.surfaceColor : const Color(0xFFF1F5F9)),
            ),
            child: Center(
              child: Icon(
                Icons.sports_soccer_outlined,
                size: Dimensions.r24.dynamicH,
                color: context.textSecondary.withValues(alpha: 0.45),
              ),
            ),
          ),
        );
      },
    );
  }
}
