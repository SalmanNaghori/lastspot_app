import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/features/categories/presentation/bloc/category_bloc.dart';
import 'package:lastspot_app/features/categories/presentation/bloc/category_state.dart';
import 'package:lastspot_app/features/spot/domain/entities/request_entity.dart';
import 'package:lastspot_app/features/spot/presentation/widgets/sport_gradient_background.dart';
import 'package:lastspot_app/features/spot/presentation/widgets/spot_host_avatar.dart';

/// Redesigned compact activity card proportioned specifically for the 3D perspective carousel.
///
/// Features:
/// - Rounded top cover image with sports fallback
/// - Available spots badge (primary green) & price badge (surface pill)
/// - Category icon + label
/// - Bold 2-line title
/// - Date, time & location rows
/// - Host avatar, host name & "View Spot" CTA
class ExploreCarouselCard extends StatelessWidget {
  final RequestEntity spot;
  final String? categoryName;
  final String? categoryIcon;
  final String? heroTagPrefix;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const ExploreCarouselCard({
    super.key,
    required this.spot,
    this.categoryName,
    this.categoryIcon,
    this.heroTagPrefix = 'explore',
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final cardWidth = width ?? Dimensions.w(280);
    final cardHeight = height ?? Dimensions.h(400);

    // Resolve category if not passed
    String catName = categoryName ?? '';
    String catIcon = categoryIcon ?? '';
    if (catName.isEmpty) {
      final categoryState = context.watch<CategoryBloc>().state;
      if (categoryState is CategoryLoaded) {
        final cat = categoryState.categories
            .where((c) => c.id == spot.categoryId)
            .firstOrNull;
        catName = cat?.name ?? 'Sport';
        catIcon = cat?.icon ?? '🎯';
      } else {
        catName = 'Sport';
        catIcon = '🎯';
      }
    }

    final spotsLeft = spot.maxParticipants - spot.currentParticipants;
    final String spotsText;
    if (spotsLeft <= 0) {
      spotsText = loc.activityFull;
    } else if (spotsLeft == 1) {
      spotsText = loc.oneSpotLeft;
    } else {
      spotsText = loc.spotsLeft(spotsLeft);
    }

    final hostName = spot.hostProfile?.fullName?.trim().isNotEmpty == true
        ? spot.hostProfile!.fullName!.trim()
        : loc.activityHost;

    final displayTitle = spot.title.trim().isNotEmpty
        ? spot.title.trim()
        : AppUtils.getDisplayLocation(
            context,
            spot.locationName,
            cityId: spot.cityId,
          );

    final displayLocation = AppUtils.getDisplayLocation(
      context,
      spot.locationName,
      cityId: spot.cityId,
    );

    final String priceText;
    if (spot.pricePerPerson > 0) {
      priceText = '₹${spot.pricePerPerson.toInt()} / ${loc.perPerson}';
    } else {
      priceText = loc.free;
    }

    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Material(
        color: context.surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.r20.dynamicR),
          side: BorderSide(
            color: context.borderColor.withValues(alpha: 0.6),
            width: Dimensions.w1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Cover Image
              _buildCoverImage(
                context,
                spotsText: spotsText,
                priceText: priceText,
              ),

              // Details section
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.r14.dynamicW,
                    vertical: Dimensions.r12.dynamicH,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Category & Title
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                AppAssets.getCategoryAsset(spot.categoryId),
                                width: Dimensions.r18.dynamicW,
                                height: Dimensions.r18.dynamicH,
                                cacheWidth: 64,
                                cacheHeight: 64,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    Text(
                                  catIcon.isNotEmpty ? catIcon : '🎯',
                                  style: TextStyle(
                                    fontSize: Dimensions.r12.dynamicSP,
                                  ),
                                ),
                              ),
                              SizedBox(width: Dimensions.r6.dynamicW),
                              Expanded(
                                child: Text(
                                  catName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: Dimensions.r12.dynamicSP,
                                    fontWeight: FontWeight.w700,
                                    color: context.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: Dimensions.r4.dynamicH),
                          Text(
                            displayTitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: Dimensions.r15.dynamicSP,
                              fontWeight: FontWeight.w800,
                              color: context.textPrimary,
                              height: 1.25,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),

                      // Date & Time + Location
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                AppAssets.calendar3d,
                                width: Dimensions.r16.dynamicW,
                                height: Dimensions.r16.dynamicH,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(
                                  Icons.schedule_rounded,
                                  size: Dimensions.r14.dynamicH,
                                  color: context.textSecondary,
                                ),
                              ),
                              SizedBox(width: Dimensions.r6.dynamicW),
                              Expanded(
                                child: Text(
                                  '${AppConstants.formatActivityDate(spot.eventDateTime)} • ${AppUtils.formatTime(spot.eventDateTime)}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: Dimensions.r12.dynamicSP,
                                    color: context.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: Dimensions.r6.dynamicH),
                          Row(
                            children: [
                              Image.asset(
                                AppAssets.locationPin3d,
                                width: Dimensions.r16.dynamicW,
                                height: Dimensions.r16.dynamicH,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(
                                  Icons.location_on_outlined,
                                  size: Dimensions.r14.dynamicH,
                                  color: context.textSecondary,
                                ),
                              ),
                              SizedBox(width: Dimensions.r6.dynamicW),
                              Expanded(
                                child: Text(
                                  displayLocation,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: Dimensions.r12.dynamicSP,
                                    color: context.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Host Avatar, Host Name & View Spot CTA
                      Container(
                        padding: EdgeInsets.only(top: Dimensions.r8.dynamicH),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: context.borderColor.withValues(alpha: 0.4),
                              width: Dimensions.w1,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: Dimensions.r28.dynamicW,
                              height: Dimensions.r28.dynamicH,
                              child: FittedBox(
                                child: SpotHostAvatar(
                                  name: hostName,
                                  photoUrl: spot.hostProfile?.avatarUrl,
                                ),
                              ),
                            ),
                            SizedBox(width: Dimensions.r8.dynamicW),
                            Expanded(
                              child: Text(
                                hostName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: Dimensions.r12.dynamicSP,
                                  fontWeight: FontWeight.w600,
                                  color: context.textPrimary,
                                ),
                              ),
                            ),
                            SizedBox(width: Dimensions.r8.dynamicW),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  loc.viewSpot,
                                  style: TextStyle(
                                    fontSize: Dimensions.r12.dynamicSP,
                                    fontWeight: FontWeight.w700,
                                    color: context.primaryColor,
                                  ),
                                ),
                                SizedBox(width: Dimensions.r4.dynamicW),
                                Image.asset(
                                  AppAssets.arrowForward3d,
                                  width: Dimensions.r14.dynamicW,
                                  height: Dimensions.r14.dynamicH,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(
                                    Icons.arrow_forward_rounded,
                                    size: Dimensions.r14.dynamicH,
                                    color: context.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoverImage(
    BuildContext context, {
    required String spotsText,
    required String priceText,
  }) {
    final imageHeight = Dimensions.r160.dynamicH;
    final tag = heroTagPrefix != null
        ? '${heroTagPrefix}_activity_image_${spot.id}'
        : 'activity_image_${spot.id}';

    return SizedBox(
      height: imageHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: tag,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(Dimensions.r20.dynamicR),
              ),
              child: spot.images.isNotEmpty
                  ? AppCachedNetworkImage(
                      imageUrl: spot.images.first.storagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      memCacheWidth: 600,
                      memCacheHeight: 400,
                      errorWidget: SportGradientBackground(
                        categoryId: spot.categoryId,
                      ),
                    )
                  : SportGradientBackground(categoryId: spot.categoryId),
            ),
          ),

          // Gradient Scrim for badge contrast
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColor.blackColor.withValues(alpha: 0.35),
                  AppColor.transparentColor,
                  AppColor.blackColor.withValues(alpha: 0.25),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // Top Badges
          Positioned(
            top: Dimensions.r10.dynamicH,
            left: Dimensions.r10.dynamicW,
            right: Dimensions.r10.dynamicW,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: Dimensions.r6.dynamicW,
              runSpacing: Dimensions.r4.dynamicH,
              children: [
                // Available Spots badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.r10.dynamicW,
                    vertical: Dimensions.r4.dynamicH,
                  ),
                  decoration: BoxDecoration(
                    color: context.primaryColor,
                    borderRadius: BorderRadius.circular(
                      Dimensions.r20.dynamicR,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.blackColor.withValues(alpha: 0.15),
                        blurRadius: Dimensions.r4.dynamicR,
                        offset: Offset(0, Dimensions.r2.dynamicH),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        AppAssets.participants3d,
                        width: Dimensions.r14.dynamicW,
                        height: Dimensions.r14.dynamicH,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.group_outlined,
                          size: Dimensions.r12.dynamicH,
                          color: AppColor.whiteColor,
                        ),
                      ),
                      SizedBox(width: Dimensions.r4.dynamicW),
                      Text(
                        spotsText,
                        style: TextStyle(
                          color: AppColor.whiteColor,
                          fontSize: Dimensions.r11.dynamicSP,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                // Price badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.r10.dynamicW,
                    vertical: Dimensions.r4.dynamicH,
                  ),
                  decoration: BoxDecoration(
                    color: context.surfaceColor.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(
                      Dimensions.r20.dynamicR,
                    ),
                    border: Border.all(
                      color: context.borderColor.withValues(alpha: 0.5),
                      width: Dimensions.w1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.blackColor.withValues(alpha: 0.1),
                        blurRadius: Dimensions.r4.dynamicR,
                        offset: Offset(0, Dimensions.r2.dynamicH),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        AppAssets.priceTag3d,
                        width: Dimensions.r14.dynamicW,
                        height: Dimensions.r14.dynamicH,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.currency_rupee_rounded,
                          size: Dimensions.r12.dynamicH,
                          color: context.textPrimary,
                        ),
                      ),
                      SizedBox(width: Dimensions.r4.dynamicW),
                      Text(
                        priceText,
                        style: TextStyle(
                          color: context.textPrimary,
                          fontSize: Dimensions.r11.dynamicSP,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
