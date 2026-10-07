import 'package:lastspot_app/core/base_import.dart';

import '../../../spot/domain/entities/request_entity.dart';
import 'package:lastspot_app/core/widgets/animation/widget_animation.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'compact_activity_card.dart';
import 'activity_shimmer_card.dart';

class ActivitiesListSection extends StatelessWidget {
  final List<RequestEntity> activities;
  final double horizontalPadding;
  final bool isLoading;

  const ActivitiesListSection({
    super.key,
    required this.activities,
    required this.horizontalPadding,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      sliver: AnimationLimiter(
        child: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          if (isLoading) {
            return AnimationWrapper(
              index: index,
              child: Padding(
                padding: EdgeInsets.only(bottom: Dimensions.r16.dynamicH),
                child: const ActivityShimmerCard(),
              ),
            );
          }

          final activity = activities[index];
          final dateStr =
              '${AppConstants.formatActivityDate(activity.eventDateTime)} · ${AppUtils.formatTime(activity.eventDateTime)}';
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

          return AnimationWrapper(
            index: index,
            child: Padding(
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
            ),
          );
        }, childCount: isLoading ? 4 : activities.length),
      )),
    );
  }
}
