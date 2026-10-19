import '../../../../core/base_import.dart';
import 'sports_summary_card.dart';

/// 4-metric activity summary grid for My Sports Space.
///
/// Displays:
/// - Hosted (created by user)
/// - Joined (accepted player, excluding hosted)
/// - Upcoming (future active matches)
/// - Completed (finished activities)
class SportsActivitySummary extends StatelessWidget {
  final int hostedCount;
  final int joinedCount;
  final int upcomingCount;
  final int completedCount;
  final int? selectedIndex;
  final ValueChanged<int>? onCardTap;

  const SportsActivitySummary({
    super.key,
    required this.hostedCount,
    required this.joinedCount,
    required this.upcomingCount,
    required this.completedCount,
    this.selectedIndex,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;

    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              SportsSummaryCard(
                label: loc.statUpcoming,
                count: upcomingCount,
                iconGen: AppAssets.calendar3dGen,
                isSelected: selectedIndex == 0,
                onTap: () => onCardTap?.call(0),
              ),
              SizedBox(height: Dimensions.r12.dynamicH),
              SportsSummaryCard(
                label: loc.statHosted,
                count: hostedCount,
                iconGen: AppAssets.cricketGen,
                isSelected: selectedIndex == 2,
                onTap: () => onCardTap?.call(2),
              ),
            ],
          ),
        ),
        SizedBox(width: Dimensions.r12.dynamicW),
        Expanded(
          child: Column(
            children: [
              SportsSummaryCard(
                label: loc.statJoined,
                count: joinedCount,
                iconGen: AppAssets.participants3dGen,
                isSelected: selectedIndex == 1,
                onTap: () => onCardTap?.call(1),
              ),
              SizedBox(height: Dimensions.r12.dynamicH),
              SportsSummaryCard(
                label: loc.statCompleted,
                count: completedCount,
                iconGen: AppAssets.footballGen,
                isSelected: selectedIndex == 3,
                onTap: () => onCardTap?.call(3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
