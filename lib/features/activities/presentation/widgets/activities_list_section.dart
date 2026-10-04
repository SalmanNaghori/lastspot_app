import 'package:lastspot_app/core/base_import.dart';

import '../../../spot/domain/entities/request_entity.dart';
import 'compact_activity_card.dart';

class ActivitiesListSection extends StatelessWidget {
  final List<RequestEntity> activities;
  final double horizontalPadding;

  const ActivitiesListSection({
    super.key,
    required this.activities,
    required this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final activity = activities[index];
          final dateStr =
              '${AppUtils.formatDateShort(activity.eventDateTime)} · ${AppUtils.formatTime(activity.eventDateTime)}';
          final locationStr = AppUtils.getDisplayLocation(
            context,
            activity.locationName,
          );
          final statsStr =
              '${activity.currentParticipants}/${activity.maxParticipants} participants · ${activity.pricePerPerson > 0 ? AppUtils.formatCurrency(activity.pricePerPerson) : context.loc.free}';

          String statusStr = context.loc.statusHosted;
          if (activity.status == RequestStatus.full) {
            statusStr = context.loc.statusFull;
          } else if (activity.status == RequestStatus.completed) {
            statusStr = context.loc.statusCompleted;
          } else if (activity.status == RequestStatus.cancelled) {
            statusStr = context.loc.statusCancelled;
          } else if (activity.status == RequestStatus.expired) {
            statusStr = context.loc.statusExpired;
          }

          return Padding(
            padding: EdgeInsets.only(bottom: Dimensions.r16.dynamicH),
            child: CompactActivityCard(
              title: activity.title,
              date: dateStr,
              location: locationStr,
              stats: statsStr,
              status: statusStr,
              isFull: activity.status == RequestStatus.full,
              onTap: () {
                context.push(AppRoutes.spotDetailsPath(activity.id));
              },
            ),
          );
        }, childCount: activities.length),
      ),
    );
  }
}
