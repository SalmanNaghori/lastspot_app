import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/features/spot/domain/entities/request_entity.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'sport_gradient_background.dart';

class SpotHeroImage extends StatelessWidget {
  final RequestEntity spot;
  final bool isUrgent;
  final String spotsLeftText;
  final String perPersonLabel;
  final String? heroTagPrefix;

  const SpotHeroImage({
    super.key,
    required this.spot,
    required this.isUrgent,
    required this.spotsLeftText,
    required this.perPersonLabel,
    this.heroTagPrefix,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final type = Theme.of(context).textTheme;
    return Hero(
      tag: heroTagPrefix != null
          ? '${heroTagPrefix}_activity_image_${spot.id}'
          : 'activity_image_${spot.id}',
      child: Skeleton.replace(
        width: double.infinity,
        height: Dimensions.r64 * 3,
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xxl),
          ),
          child: SizedBox(
            height: Dimensions.r64 * 3,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (spot.images.isNotEmpty)
                  AppCachedNetworkImage(
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
                else
                  SportGradientBackground(categoryId: spot.categoryId),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColor.blackColor.withValues(alpha: 0.08),
                        AppColor.blackColor.withValues(alpha: 0.35),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: AppSpacing.smLg,
                  left: AppSpacing.smLg,
                  right: AppSpacing.smLg,
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      if (spotsLeftText.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.smLg,
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: colors.primary,
                            borderRadius: AppRadius.pillBorderRadius,
                          ),
                          child: Text(
                            spotsLeftText,
                            style: type.labelMedium?.copyWith(
                              color: colors.onPrimary,
                            ),
                          ),
                        ),
                      if (perPersonLabel.isNotEmpty || spot.pricePerPerson > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.smLg,
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: AppRadius.pillBorderRadius,
                          ),
                          child: Text(
                            spot.pricePerPerson > 0
                                ? '${AppUtils.formatCurrency(spot.pricePerPerson)} $perPersonLabel'
                                      .trim()
                                : context.loc.free,
                            style: type.labelMedium?.copyWith(
                              color: colors.onSurface,
                            ),
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
