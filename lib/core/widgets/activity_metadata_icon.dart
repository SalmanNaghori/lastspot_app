import '../base_import.dart';

/// Enum defining available 3D activity metadata asset types.
enum ActivityMetadataType {
  calendar,
  location,
  participants,
  price,
  arrowForward,
  joinRequest,
}

/// Reusable compact 3D metadata icon component for schedule, venue, capacity, price, and actions.
///
/// Features:
/// - Connects to Fareeq-inspired 3D clay asset suite.
/// - Strict responsive [Dimensions] scaling.
/// - Memory-cached image decoding.
/// - Semantic fallback to theme-aware Material icons.
class ActivityMetadataIcon extends StatelessWidget {
  final ActivityMetadataType type;
  final double? size;
  final double? width;
  final double? height;
  final Color? fallbackColor;
  final BoxFit fit;

  const ActivityMetadataIcon({
    super.key,
    required this.type,
    this.size,
    this.width,
    this.height,
    this.fallbackColor,
    this.fit = BoxFit.contain,
  });

  const ActivityMetadataIcon.calendar({
    super.key,
    this.size,
    this.width,
    this.height,
    this.fallbackColor,
    this.fit = BoxFit.contain,
  }) : type = ActivityMetadataType.calendar;

  const ActivityMetadataIcon.location({
    super.key,
    this.size,
    this.width,
    this.height,
    this.fallbackColor,
    this.fit = BoxFit.contain,
  }) : type = ActivityMetadataType.location;

  const ActivityMetadataIcon.participants({
    super.key,
    this.size,
    this.width,
    this.height,
    this.fallbackColor,
    this.fit = BoxFit.contain,
  }) : type = ActivityMetadataType.participants;

  const ActivityMetadataIcon.price({
    super.key,
    this.size,
    this.width,
    this.height,
    this.fallbackColor,
    this.fit = BoxFit.contain,
  }) : type = ActivityMetadataType.price;

  const ActivityMetadataIcon.priceTag({
    super.key,
    this.size,
    this.width,
    this.height,
    this.fallbackColor,
    this.fit = BoxFit.contain,
  }) : type = ActivityMetadataType.price;

  const ActivityMetadataIcon.arrowForward({
    super.key,
    this.size,
    this.width,
    this.height,
    this.fallbackColor,
    this.fit = BoxFit.contain,
  }) : type = ActivityMetadataType.arrowForward;

  const ActivityMetadataIcon.joinRequest({
    super.key,
    this.size,
    this.width,
    this.height,
    this.fallbackColor,
    this.fit = BoxFit.contain,
  }) : type = ActivityMetadataType.joinRequest;

  @override
  Widget build(BuildContext context) {
    final effectiveWidth = width ?? size ?? Dimensions.r16.dynamicW;
    final effectiveHeight = height ?? size ?? Dimensions.r16.dynamicH;

    final (AssetGenImage assetGen, IconData fallbackIcon) = switch (type) {
      ActivityMetadataType.calendar => (
        Assets.icons.calendar3d,
        Icons.schedule_rounded,
      ),
      ActivityMetadataType.location => (
        Assets.icons.locationPin3d,
        Icons.location_on_outlined,
      ),
      ActivityMetadataType.participants => (
        Assets.icons.participants3d,
        Icons.groups_outlined,
      ),
      ActivityMetadataType.price => (
        Assets.icons.priceTag3d,
        Icons.payments_outlined,
      ),
      ActivityMetadataType.arrowForward => (
        Assets.icons.arrowForward3d,
        Icons.arrow_forward_rounded,
      ),
      ActivityMetadataType.joinRequest => (
        Assets.icons.joinRequest3d,
        Icons.mark_email_unread_outlined,
      ),
    };

    final image = assetGen.image(
      width: effectiveWidth,
      height: effectiveHeight,
      fit: fit,
      cacheWidth: 128,
      cacheHeight: 128,
      filterQuality: FilterQuality.high,
      frameBuilder: type == ActivityMetadataType.location
          ? (context, child, frame, wasSynchronouslyLoaded) => ColorFiltered(
              colorFilter: AppAssets.locationPinColorFilter(
                context.primaryColor,
              ),
              child: child,
            )
          : null,
      errorBuilder: (context, error, stackTrace) => Icon(
        fallbackIcon,
        size: effectiveHeight * 0.9,
        color:
            fallbackColor ??
            (type == ActivityMetadataType.location
                ? context.primaryColor
                : context.textSecondary),
      ),
    );

    return SizedBox(
      width: effectiveWidth,
      height: effectiveHeight,
      child: image,
    );
  }
}
