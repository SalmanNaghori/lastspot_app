import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/core/widgets/app_cached_network_image.dart';
import 'package:lastspot_app/features/spot/domain/entities/request_entity.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'sport_gradient_background.dart';

class SpotHeroImage extends StatelessWidget {
  final RequestEntity spot;
  final bool isUrgent;
  final String spotsLeftText;
  final String perPersonLabel;

  const SpotHeroImage({
    super.key,
    required this.spot,
    required this.isUrgent,
    required this.spotsLeftText,
    required this.perPersonLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'activity_image_${spot.id}',
      child: Skeleton.replace(
        width: double.infinity,
        height: Dimensions.r64.dynamicH * 2.8,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimensions.r16.dynamicR),
            topRight: Radius.circular(Dimensions.r16.dynamicR),
          ),
          child: SizedBox(
            height: Dimensions.r64.dynamicH * 2.8,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Hero image or gradient background
                if (spot.images.isNotEmpty)
                  AppCachedNetworkImage(
                    imageUrl: spot.images.first.storagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    memCacheWidth: 600,
                    memCacheHeight: 400,
                    errorWidget: SportGradientBackground(categoryId: spot.categoryId),
                  )
                else
                  SportGradientBackground(categoryId: spot.categoryId),

                // Gradient scrim
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [AppColor.blackColor.withValues(alpha: 0.15), AppColor.blackColor.withValues(alpha: 0.45)],
                    ),
                  ),
                ),

                // Top badges
                Positioned(
                  top: Dimensions.r12.dynamicH,
                  left: Dimensions.r12.dynamicW,
                  right: Dimensions.r12.dynamicW,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Spots Left badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.r10.dynamicW,
                          vertical: Dimensions.r5.dynamicH,
                        ),
                        decoration: BoxDecoration(
                          color: context.primaryColor,
                          borderRadius: BorderRadius.circular(Dimensions.r8.dynamicR),
                        ),
                        child: Text(
                          spotsLeftText,
                          style: TextStyle(
                            color: AppColor.whiteColor,
                            fontSize: Dimensions.r11.dynamicSP,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      // Price badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.r10.dynamicW,
                          vertical: Dimensions.r5.dynamicH,
                        ),
                        decoration: BoxDecoration(
                          color: context.surfaceColor.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(Dimensions.r8.dynamicR),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              spot.pricePerPerson > 0
                                  ? '₹${spot.pricePerPerson.toStringAsFixed(spot.pricePerPerson.truncateToDouble() == spot.pricePerPerson ? 0 : 2)}'
                                  : 'FREE',
                              style: TextStyle(
                                color: context.primaryColor,
                                fontSize: Dimensions.r12.dynamicSP,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              perPersonLabel,
                              style: TextStyle(color: context.textSecondary, fontSize: Dimensions.r9.dynamicSP),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
