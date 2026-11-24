import '../../../../core/base_import.dart';
import '../../domain/entities/request_entity.dart';
import '../../domain/policies/spot_participation_policy.dart';

/// Summary header card displaying comprehensive activity metrics,
/// participant capacity, and pending request indicators for Manage Requests.
class ManageSpotSummaryCard extends StatelessWidget {
  final RequestEntity post;
  final int pendingCount;

  const ManageSpotSummaryCard({
    super.key,
    required this.post,
    this.pendingCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final title = post.title.trim().isNotEmpty
        ? post.title.trim()
        : AppUtils.getDisplayLocation(
            context,
            post.locationName,
            cityId: post.cityId,
          );
    final remaining = SpotParticipationPolicy.remainingSpots(post);
    final hasImage =
        post.images.isNotEmpty &&
        post.images.first.storagePath.trim().isNotEmpty;
    final firstImageUrl = hasImage
        ? post.images.first.storagePath.trim()
        : null;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.mdLg),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
        border: Border.all(color: context.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Image / 3D Icon + Header Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Activity image or Category 3D icon
              Container(
                width: Dimensions.r64.dynamicW,
                height: Dimensions.r64.dynamicH,
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
                  child: firstImageUrl != null
                      ? AppCachedNetworkImage(
                          imageUrl: firstImageUrl,
                          width: Dimensions.r64.dynamicW,
                          height: Dimensions.r64.dynamicH,
                          fit: BoxFit.cover,
                          memCacheWidth: 160,
                          memCacheHeight: 160,
                          errorWidget: Center(
                            child: Category3DIcon(
                              category: post.categoryId,
                              size: Dimensions.r32.dynamicH,
                            ),
                          ),
                        )
                      : Center(
                          child: Category3DIcon(
                            category: post.categoryId,
                            size: Dimensions.r36.dynamicH,
                          ),
                        ),
                ),
              ),
              SizedBox(width: Dimensions.r12.dynamicW),
              // Title & Category & Date/Time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.r8.dynamicW,
                            vertical: Dimensions.r2.dynamicH,
                          ),
                          decoration: BoxDecoration(
                            color: context.primaryColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(
                              Dimensions.r6.dynamicR,
                            ),
                          ),
                          child: Text(
                            post.categoryId.toUpperCase(),
                            style: context.labelSmall?.copyWith(
                              color: context.primaryColor,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (post.status == RequestStatus.full || remaining == 0)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.r8.dynamicW,
                              vertical: Dimensions.r2.dynamicH,
                            ),
                            decoration: BoxDecoration(
                              color: context.successColor.withValues(
                                alpha: 0.12,
                              ),
                              borderRadius: BorderRadius.circular(
                                Dimensions.r6.dynamicR,
                              ),
                            ),
                            child: Text(
                              context.loc.activityFull,
                              style: context.labelSmall?.copyWith(
                                color: context.successColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: Dimensions.r6.dynamicH),
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: Dimensions.r4.dynamicH),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: Dimensions.r14.dynamicH,
                          color: colors.onSurfaceVariant,
                        ),
                        SizedBox(width: Dimensions.r4.dynamicW),
                        Expanded(
                          child: Text(
                            AppUtils.formatDateTime(post.eventDateTime),
                            style: context.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.r2.dynamicH),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: Dimensions.r14.dynamicH,
                          color: colors.onSurfaceVariant,
                        ),
                        SizedBox(width: Dimensions.r4.dynamicW),
                        Expanded(
                          child: Text(
                            AppUtils.getDisplayLocation(
                              context,
                              post.locationName,
                              cityId: post.cityId,
                            ),
                            style: context.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.r16.dynamicH),
          Divider(color: context.borderColor, height: 1),
          SizedBox(height: Dimensions.r12.dynamicH),

          // Row 2: Participant Progress Indicator & Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.groups_outlined,
                    size: Dimensions.r18.dynamicH,
                    color: context.primaryColor,
                  ),
                  SizedBox(width: Dimensions.r6.dynamicW),
                  Text(
                    context.loc.playersConfirmed(
                      post.currentParticipants,
                      post.maxParticipants,
                    ),
                    style: context.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: context.textPrimary,
                    ),
                  ),
                ],
              ),
              Text(
                remaining > 0
                    ? '$remaining available'
                    : context.loc.activityFull,
                style: context.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: remaining == 0
                      ? colors.error
                      : colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.r8.dynamicH),
          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.r6.dynamicR),
            child: LinearProgressIndicator(
              value: SpotParticipationPolicy.occupancy(post),
              minHeight: 8,
              backgroundColor: context.borderColor,
              valueColor: AlwaysStoppedAnimation<Color>(
                remaining == 0 ? context.successColor : context.primaryColor,
              ),
            ),
          ),
          SizedBox(height: Dimensions.r12.dynamicH),

          // Row 3: Status Summary Chips (Pending & Confirmed)
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.r10.dynamicW,
                  vertical: Dimensions.r4.dynamicH,
                ),
                decoration: BoxDecoration(
                  color:
                      (pendingCount > 0
                              ? context.primaryColor
                              : colors.onSurfaceVariant)
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Dimensions.r8.dynamicR),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.hourglass_top_rounded,
                      size: Dimensions.r14.dynamicH,
                      color: pendingCount > 0
                          ? context.primaryColor
                          : colors.onSurfaceVariant,
                    ),
                    SizedBox(width: Dimensions.r4.dynamicW),
                    Text(
                      '$pendingCount Pending',
                      style: context.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: pendingCount > 0
                            ? context.primaryColor
                            : colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: Dimensions.r8.dynamicW),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.r10.dynamicW,
                  vertical: Dimensions.r4.dynamicH,
                ),
                decoration: BoxDecoration(
                  color: context.successColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Dimensions.r8.dynamicR),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: Dimensions.r14.dynamicH,
                      color: context.successColor,
                    ),
                    SizedBox(width: Dimensions.r4.dynamicW),
                    Text(
                      '${post.currentParticipants} Confirmed',
                      style: context.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.successColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
