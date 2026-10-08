import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/core/theme/app_motion.dart';
import 'package:lastspot_app/features/spot/domain/entities/request_entity.dart';

import 'spot_hero_image.dart';
import 'spot_host_avatar.dart';

class ActivityCard extends StatefulWidget {
  final RequestEntity spot;
  final String categoryName;
  final String categoryIcon;
  final String? heroTagPrefix;
  final VoidCallback onTap;
  final double? width;

  const ActivityCard({
    super.key,
    required this.spot,
    required this.categoryName,
    required this.categoryIcon,
    this.heroTagPrefix,
    required this.onTap,
    this.width,
  });

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  bool _isPressed = false;
  final Stopwatch _tapClock = Stopwatch();

  void _handleTap() {
    // Prevent duplicate route pushes during the detail transition.
    if (_tapClock.isRunning && _tapClock.elapsed < AppMotion.tapGuard) return;
    _tapClock
      ..reset()
      ..start();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final colors = context.colorScheme;
    final type = Theme.of(context).textTheme;
    final spot = widget.spot;
    final spotsLeft = spot.maxParticipants - spot.currentParticipants;
    final availability = spotsLeft <= 0
        ? loc.activityFull
        : spotsLeft == 1
        ? loc.oneSpotLeft
        : loc.spotsLeft(spotsLeft);
    final host = spot.hostProfile?.fullName ?? loc.activityHost;

    return AnimatedScale(
      scale: _isPressed ? AppMotion.pressedScale : 1,
      duration: AppMotion.duration(context, AppMotion.quick),
      curve: AppMotion.curve,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: SizedBox(
          width: widget.width,
          child: Material(
            color: colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.xxlBorderRadius,
              side: BorderSide(color: colors.outlineVariant),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: _handleTap,
              onHighlightChanged: (value) => setState(() => _isPressed = value),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SpotHeroImage(
                    spot: spot,
                    isUrgent: false,
                    spotsLeftText: availability,
                    perPersonLabel: loc.perPerson,
                    heroTagPrefix: widget.heroTagPrefix,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.mdLg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.categoryIcon} ${widget.categoryName}',
                          style: type.labelMedium?.copyWith(
                            color: colors.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          spot.title.trim().isNotEmpty
                              ? spot.title.trim().capitalizeFirst()
                              : AppUtils.getDisplayLocation(
                                  context,
                                  spot.locationName,
                                  cityId: spot.cityId,
                                ),
                          style: type.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule_rounded,
                              size: AppSpacing.md,
                              color: colors.onSurfaceVariant,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                '${AppConstants.formatActivityDate(spot.eventDateTime)} • ${AppUtils.formatTime(spot.eventDateTime)}',
                                style: type.bodySmall?.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: AppSpacing.md,
                              color: colors.onSurfaceVariant,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                AppUtils.getDisplayLocation(
                                  context,
                                  spot.locationName,
                                  cityId: spot.cityId,
                                ),
                                style: type.bodySmall?.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          loc.activityCapacity(
                            spot.currentParticipants,
                            spot.maxParticipants,
                          ),
                          style: type.labelSmall?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        LinearProgressIndicator(
                          value: spot.maxParticipants > 0
                              ? (spot.currentParticipants /
                                        spot.maxParticipants)
                                    .clamp(0.0, 1.0)
                              : 0,
                          borderRadius: AppRadius.pillBorderRadius,
                          backgroundColor: colors.primaryContainer,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            SpotHostAvatar(
                              name: host,
                              photoUrl: spot.hostProfile?.avatarUrl,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                host,
                                style: type.labelLarge,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Flexible(
                              child: Text(
                                loc.viewSpot,
                                style: type.labelLarge?.copyWith(
                                  color: colors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: AppSpacing.md,
                              color: colors.primary,
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
        ),
      ),
    );
  }
}
