import '../base_import.dart';

/// App-wide standard local asset image widget with memory-optimized decoding,
/// shape clipping, and resilient fallbacks.
class AppAssetImage extends StatelessWidget {
  final String? assetPath;
  final AssetGenImage? imageGen;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final bool isCircle;
  final int? cacheWidth;
  final int? cacheHeight;
  final Widget? errorWidget;
  final Color? color;
  final BlendMode? colorBlendMode;

  const AppAssetImage({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.borderRadius,
    this.isCircle = false,
    this.cacheWidth,
    this.cacheHeight,
    this.errorWidget,
    this.color,
    this.colorBlendMode,
  }) : imageGen = null;

  const AppAssetImage.gen({
    super.key,
    required this.imageGen,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.borderRadius,
    this.isCircle = false,
    this.cacheWidth,
    this.cacheHeight,
    this.errorWidget,
    this.color,
    this.colorBlendMode,
  }) : assetPath = null;

  @override
  Widget build(BuildContext context) {
    final String? resolvedPath = imageGen?.path ?? assetPath;

    if (resolvedPath == null || resolvedPath.isEmpty) {
      return _buildFallback(context);
    }

    final effectiveCacheWidth =
        cacheWidth ??
        (width != null ? (width! * 2).round().clamp(1, 1920) : null);
    final effectiveCacheHeight =
        cacheHeight ??
        (height != null ? (height! * 2).round().clamp(1, 1920) : null);

    Widget image = Image.asset(
      resolvedPath,
      width: width,
      height: height,
      fit: fit,
      cacheWidth: effectiveCacheWidth,
      cacheHeight: effectiveCacheHeight,
      color: color,
      colorBlendMode: colorBlendMode,
      errorBuilder: (context, error, stackTrace) => _buildFallback(context),
    );

    if (isCircle) {
      return ClipOval(child: image);
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }

    return image;
  }

  Widget _buildFallback(BuildContext context) {
    if (errorWidget != null) return errorWidget!;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.primaryContainer.withValues(alpha: 0.5),
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : borderRadius,
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.image_not_supported_outlined,
        size: ((width ?? height ?? 40) * 0.45).clamp(16.0, 48.0),
        color: context.primaryColor.withValues(alpha: 0.6),
      ),
    );
  }
}
