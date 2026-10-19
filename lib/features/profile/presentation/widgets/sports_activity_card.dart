import '../../../../core/base_import.dart';
import '../../../spot/domain/entities/request_entity.dart';

/// Interactive sports activity card for My Sports Space timeline.
///
/// Features:
/// - 3D Category illustration matching sport
/// - Role chip (Host vs Player)
/// - Status chip (Open, Full, Completed, Cancelled)
/// - Formatted date/time and resolved location
/// - Clean tap handler navigating to Activity Details
class SportsActivityCard extends StatelessWidget {
  final RequestEntity activity;
  final bool isHost;
  final VoidCallback onTap;

  const SportsActivityCard({
    super.key,
    required this.activity,
    required this.isHost,
    required this.onTap,
  });

  Color _getStatusColor(BuildContext context, RequestStatus status) {
    switch (status) {
      case RequestStatus.open:
        return context.primaryColor;
      case RequestStatus.full:
        return AppColor.warningColor;
      case RequestStatus.completed:
        return AppColor.successColor;
      case RequestStatus.cancelled:
      case RequestStatus.expired:
        return context.colorScheme.error;
      case RequestStatus.draft:
        return context.textSecondary;
    }
  }

  String _getStatusText(AppLocalizations loc, RequestStatus status) {
    switch (status) {
      case RequestStatus.open:
        return loc.statusOpen;
      case RequestStatus.full:
        return loc.statusFull;
      case RequestStatus.completed:
        return loc.statusCompleted;
      case RequestStatus.cancelled:
      case RequestStatus.expired:
        return loc.statusCancelled;
      case RequestStatus.draft:
        return loc.detailsDraft;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final statusColor = _getStatusColor(context, activity.status);
    final statusText = _getStatusText(loc, activity.status);
    final displayDate = AppUtils.formatDateTime(activity.eventDateTime);
    final displayLocation = AppUtils.getDisplayLocation(
      context,
      activity.locationName,
      cityId: activity.cityId,
    );

    return Semantics(
      button: true,
      label: '${activity.title}, $statusText',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
        child: Container(
          padding: EdgeInsets.all(Dimensions.r12.dynamicW),
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
            border: Border.all(
              color: context.colorScheme.outlineVariant.withValues(alpha: 0.35),
              width: 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColor.blackColor.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 3D Category Artwork
              Container(
                width: Dimensions.r48.dynamicW,
                height: Dimensions.r48.dynamicH,
                padding: EdgeInsets.all(Dimensions.r4.dynamicR),
                decoration: BoxDecoration(
                  color: context.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
                  border: Border.all(
                    color: context.colorScheme.outlineVariant.withValues(
                      alpha: 0.25,
                    ),
                    width: 0.8,
                  ),
                ),
                child: Category3DIcon(
                  category: activity.categoryId,
                  size: Dimensions.r36.dynamicH,
                ),
              ),
              SizedBox(width: Dimensions.r12.dynamicW),

              // Activity Metadata
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Role and Status chips
                    Wrap(
                      spacing: Dimensions.r6.dynamicW,
                      runSpacing: Dimensions.r4.dynamicH,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        // Role Pill
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.r6.dynamicW,
                            vertical: Dimensions.r2.dynamicH,
                          ),
                          decoration: BoxDecoration(
                            color: isHost
                                ? context.primaryColor.withValues(alpha: 0.12)
                                : context.colorScheme.secondaryContainer
                                      .withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(
                              Dimensions.r6.dynamicR,
                            ),
                          ),
                          child: Text(
                            isHost
                                ? loc.participantRoleHost
                                : loc.participantRolePlayer,
                            style: TextStyle(
                              fontSize: Dimensions.r10.dynamicSP,
                              fontWeight: FontWeight.w700,
                              color: isHost
                                  ? context.primaryColor
                                  : context.textPrimary,
                            ),
                          ),
                        ),

                        // Status Pill
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.r6.dynamicW,
                            vertical: Dimensions.r2.dynamicH,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(
                              Dimensions.r6.dynamicR,
                            ),
                          ),
                          child: Text(
                            statusText,
                            style: TextStyle(
                              fontSize: Dimensions.r10.dynamicSP,
                              fontWeight: FontWeight.w700,
                              color: statusColor,
                            ),
                          ),
                        ),

                        // Capacity Pill (when applicable)
                        if (activity.maxParticipants > 0 &&
                            activity.status != RequestStatus.completed &&
                            activity.status != RequestStatus.cancelled) ...[
                          Builder(
                            builder: (context) {
                              final availableSpots =
                                  activity.maxParticipants -
                                  activity.currentParticipants;
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.r6.dynamicW,
                                  vertical: Dimensions.r2.dynamicH,
                                ),
                                decoration: BoxDecoration(
                                  color: context
                                      .colorScheme
                                      .surfaceContainerHighest
                                      .withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.r6.dynamicR,
                                  ),
                                ),
                                child: Text(
                                  availableSpots <= 0
                                      ? loc.statusFull
                                      : loc.spotsLeft(
                                          availableSpots.toString(),
                                        ),
                                  style: TextStyle(
                                    fontSize: Dimensions.r10.dynamicSP,
                                    fontWeight: FontWeight.w600,
                                    color: context.textSecondary,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: Dimensions.r6.dynamicH),

                    // Title
                    Text(
                      activity.title,
                      style: TextStyle(
                        fontSize: Dimensions.r14.dynamicSP,
                        fontWeight: FontWeight.w700,
                        color: context.textPrimary,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: Dimensions.r4.dynamicH),

                    // Date & Time
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: Dimensions.r12.dynamicH,
                          color: context.textSecondary,
                        ),
                        SizedBox(width: Dimensions.r4.dynamicW),
                        Expanded(
                          child: Text(
                            displayDate,
                            style: TextStyle(
                              fontSize: Dimensions.r11.dynamicSP,
                              color: context.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.r2.dynamicH),

                    // Location
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: Dimensions.r12.dynamicH,
                          color: context.textSecondary,
                        ),
                        SizedBox(width: Dimensions.r4.dynamicW),
                        Expanded(
                          child: Text(
                            displayLocation,
                            style: TextStyle(
                              fontSize: Dimensions.r11.dynamicSP,
                              color: context.textSecondary,
                              fontWeight: FontWeight.w500,
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

              // Arrow
              Icon(
                Icons.chevron_right_rounded,
                size: Dimensions.r20.dynamicH,
                color: context.textSecondary.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
