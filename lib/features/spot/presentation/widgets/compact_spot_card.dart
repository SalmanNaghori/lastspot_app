import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/core/theme/app_motion.dart';
import 'package:lastspot_app/features/spot/domain/entities/request_entity.dart';

import 'sport_gradient_background.dart';

/// A schedule-first card for activities happening in the coming week.
class CompactSpotCard extends StatefulWidget {
  final RequestEntity spot;
  final String categoryName;
  final String categoryIcon;
  final String heroTagPrefix;
  final VoidCallback onTap;

  const CompactSpotCard({
    super.key,
    required this.spot,
    required this.categoryName,
    required this.categoryIcon,
    required this.heroTagPrefix,
    required this.onTap,
  });

  @override
  State<CompactSpotCard> createState() => _CompactSpotCardState();
}

class _CompactSpotCardState extends State<CompactSpotCard> {
  final Stopwatch _tapClock = Stopwatch();

  void _handleTap() {
    if (_tapClock.isRunning && _tapClock.elapsed < AppMotion.tapGuard) return;
    _tapClock
      ..reset()
      ..start();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final type = Theme.of(context).textTheme;
    final loc = context.loc;
    final spot = widget.spot;
    final available = spot.maxParticipants - spot.currentParticipants;
    final availability = available <= 0
        ? loc.activityFull
        : available == 1
        ? loc.oneSpotLeft
        : loc.spotsLeft(available);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.smLg),
      child: Material(
        color: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.xlBorderRadius,
          side: BorderSide(color: colors.outlineVariant),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: _handleTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.smLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: '${widget.heroTagPrefix}_activity_image_${spot.id}',
                      child: ClipRRect(
                        borderRadius: AppRadius.lgBorderRadius,
                        child: SizedBox.square(
                          dimension: AppSpacing.xxxl * 2,
                          child: spot.images.isEmpty
                              ? SportGradientBackground(
                                  categoryId: spot.categoryId,
                                )
                              : AppCachedNetworkImage(
                                  imageUrl: spot.images.first.storagePath,
                                  fit: BoxFit.cover,
                                  memCacheWidth: 320,
                                  errorWidget: SportGradientBackground(
                                    categoryId: spot.categoryId,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.smLg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.categoryIcon} ${widget.categoryName}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: type.labelSmall?.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            spot.title.trim().isNotEmpty
                                ? spot.title.trim()
                                : AppUtils.getDisplayLocation(
                                    context,
                                    spot.locationName,
                                    cityId: spot.cityId,
                                  ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: type.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            '${AppConstants.formatActivityDate(spot.eventDateTime)} · ${AppUtils.formatTime(spot.eventDateTime)}',
                            maxLines: 2,
                            style: type.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            AppUtils.getDisplayLocation(
                              context,
                              spot.locationName,
                              cityId: spot.cityId,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: type.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.smLg),
                Wrap(
                  spacing: AppSpacing.smLg,
                  runSpacing: AppSpacing.xs,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    Text(
                      availability,
                      style: type.labelSmall?.copyWith(color: colors.primary),
                    ),
                    Text(
                      spot.pricePerPerson > 0
                          ? '${AppUtils.formatCurrency(spot.pricePerPerson)} ${loc.perPerson}'
                          : loc.free,
                      style: type.labelSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
