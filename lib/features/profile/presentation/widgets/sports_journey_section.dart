import '../../../../core/base_import.dart';
import '../../../spot/domain/entities/request_entity.dart';
import 'sports_activity_card.dart';

/// Sports Journey Timeline section with interactive filter chips.
///
/// Features:
/// - Filter tabs: Upcoming Games, Joined Matches, Hosted Matches, Past Activities
/// - Compact sports cards with 3D category artwork
/// - Tapping an activity pushes Activity Details
/// - Empty state with contextual CTA
/// - "View All in Activities" shortcut
class SportsJourneySection extends StatelessWidget {
  final List<RequestEntity> upcomingActivities;
  final List<RequestEntity> joinedActivities;
  final List<RequestEntity> hostedActivities;
  final List<RequestEntity> pastActivities;
  final String currentUserId;
  final ValueNotifier<int> activeTabNotifier;
  final VoidCallback onFindGame;
  final VoidCallback onHostGame;
  final VoidCallback onViewAllActivities;

  const SportsJourneySection({
    super.key,
    required this.upcomingActivities,
    required this.joinedActivities,
    required this.hostedActivities,
    required this.pastActivities,
    required this.currentUserId,
    required this.activeTabNotifier,
    required this.onFindGame,
    required this.onHostGame,
    required this.onViewAllActivities,
  });

  List<RequestEntity> _getFilteredActivities(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return upcomingActivities;
      case 1:
        return joinedActivities;
      case 2:
        return hostedActivities;
      case 3:
        return pastActivities;
      default:
        return upcomingActivities;
    }
  }

  void _onActivityTap(BuildContext context, RequestEntity activity) {
    context.push(AppRoutes.spotDetailsPath(activity.id));
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final tabLabels = [
      loc.upcomingGames,
      loc.joinedMatches,
      loc.hostedMatches,
      loc.completedMatches,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header with View All action
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                loc.sportsJourney,
                style: TextStyle(
                  fontSize: Dimensions.r16.dynamicSP,
                  fontWeight: FontWeight.w800,
                  color: context.textPrimary,
                  letterSpacing: -0.3,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton(
              onPressed: onViewAllActivities,
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
              ),
              child: Text(
                loc.viewAll,
                style: TextStyle(
                  fontSize: Dimensions.r13.dynamicSP,
                  fontWeight: FontWeight.w700,
                  color: context.primaryColor,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: Dimensions.r8.dynamicH),

        // Filter Tabs
        ValueListenableBuilder<int>(
          valueListenable: activeTabNotifier,
          builder: (context, activeIndex, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(tabLabels.length, (index) {
                      final isSelected = activeIndex == index;
                      final count = _getFilteredActivities(index).length;

                      return Padding(
                        padding: EdgeInsets.only(right: Dimensions.r8.dynamicW),
                        child: ChoiceChip(
                          label: Text(
                            '${tabLabels[index]} ($count)',
                            style: TextStyle(
                              fontSize: Dimensions.r12.dynamicSP,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? AppColor.whiteColor
                                  : context.textSecondary,
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: context.primaryColor,
                          backgroundColor: context.surfaceColor,
                          showCheckmark: false,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              Dimensions.r16.dynamicR,
                            ),
                            side: BorderSide(
                              color: isSelected
                                  ? context.primaryColor
                                  : context.colorScheme.outlineVariant
                                        .withValues(alpha: 0.35),
                              width: 1.0,
                            ),
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              activeTabNotifier.value = index;
                            }
                          },
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(height: Dimensions.r12.dynamicH),

                // Activity List or Empty State
                Builder(
                  builder: (context) {
                    final items = _getFilteredActivities(activeIndex);
                    if (items.isEmpty) {
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: Dimensions.r24.dynamicH,
                          horizontal: Dimensions.r16.dynamicW,
                        ),
                        decoration: BoxDecoration(
                          color: context.surfaceColor,
                          borderRadius: BorderRadius.circular(
                            Dimensions.r16.dynamicR,
                          ),
                          border: Border.all(
                            color: context.colorScheme.outlineVariant
                                .withValues(alpha: 0.25),
                            width: 1.0,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.sports_rounded,
                              size: Dimensions.r36.dynamicH,
                              color: context.textSecondary.withValues(
                                alpha: 0.4,
                              ),
                            ),
                            SizedBox(height: Dimensions.r8.dynamicH),
                            Text(
                              loc.noJourneyActivities,
                              style: TextStyle(
                                fontSize: Dimensions.r13.dynamicSP,
                                color: context.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: Dimensions.r12.dynamicH),
                            OutlinedButton(
                              onPressed: activeIndex == 2
                                  ? onHostGame
                                  : onFindGame,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: context.primaryColor,
                                side: BorderSide(
                                  color: context.primaryColor,
                                  width: 1.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.r12.dynamicR,
                                  ),
                                ),
                              ),
                              child: Text(
                                activeIndex == 2
                                    ? loc.quickActionOrganize
                                    : loc.quickActionFindGame,
                                style: TextStyle(
                                  fontSize: Dimensions.r12.dynamicSP,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // Display top 4 activities in this category
                    final displayItems = items.take(4).toList();
                    return Column(
                      children: displayItems.map((act) {
                        final isHost = act.userId == currentUserId;
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: Dimensions.r8.dynamicH,
                          ),
                          child: SportsActivityCard(
                            activity: act,
                            isHost: isHost,
                            onTap: () => _onActivityTap(context, act),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
