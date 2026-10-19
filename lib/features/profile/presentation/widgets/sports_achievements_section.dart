import '../../../../core/base_import.dart';
import 'sports_achievement_card.dart';

/// Real-data verified sports achievements milestone section for My Sports Space.
///
/// Only renders milestones computed from verified database activity:
/// - First Host: hostedCount >= 1
/// - Team Player: joinedCount >= 1
/// - Active Athlete: completedCount >= 5
/// - Sports Legend: completedCount >= 10
class SportsAchievementsSection extends StatelessWidget {
  final int hostedCount;
  final int joinedCount;
  final int completedCount;

  const SportsAchievementsSection({
    super.key,
    required this.hostedCount,
    required this.joinedCount,
    required this.completedCount,
  });

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;

    final hasFirstHost = hostedCount >= 1;
    final hasTeamPlayer = joinedCount >= 1;
    final hasActiveAthlete = completedCount >= 5;
    final hasSportsLegend = completedCount >= 10;

    return Container(
      padding: EdgeInsets.all(Dimensions.r16.dynamicW),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(Dimensions.r20.dynamicR),
        border: Border.all(
          color: context.colorScheme.outlineVariant.withValues(alpha: 0.35),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Icon(
                Icons.military_tech_rounded,
                size: Dimensions.r20.dynamicH,
                color: context.primaryColor,
              ),
              SizedBox(width: Dimensions.r8.dynamicW),
              Expanded(
                child: Text(
                  loc.achievementsTitle,
                  style: TextStyle(
                    fontSize: Dimensions.r15.dynamicSP,
                    fontWeight: FontWeight.w800,
                    color: context.textPrimary,
                    letterSpacing: -0.2,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.r12.dynamicH),

          // Milestone Cards
          SportsAchievementCard(
            title: loc.achievementFirstHost,
            description: loc.achievementFirstHostDesc,
            icon: Icons.sports_cricket_rounded,
            isUnlocked: hasFirstHost,
            progressText: hasFirstHost ? null : '$hostedCount/1',
          ),
          SizedBox(height: Dimensions.r8.dynamicH),
          SportsAchievementCard(
            title: loc.achievementTeamPlayer,
            description: loc.achievementTeamPlayerDesc,
            icon: Icons.groups_rounded,
            isUnlocked: hasTeamPlayer,
            progressText: hasTeamPlayer ? null : '$joinedCount/1',
          ),
          SizedBox(height: Dimensions.r8.dynamicH),
          SportsAchievementCard(
            title: loc.achievementActiveAthlete,
            description: loc.achievementActiveAthleteDesc,
            icon: Icons.emoji_events_rounded,
            isUnlocked: hasActiveAthlete,
            progressText: hasActiveAthlete ? null : '$completedCount/5',
          ),
          SizedBox(height: Dimensions.r8.dynamicH),
          SportsAchievementCard(
            title: loc.achievementSportsLegend,
            description: loc.achievementSportsLegendDesc,
            icon: Icons.stars_rounded,
            isUnlocked: hasSportsLegend,
            progressText: hasSportsLegend ? null : '$completedCount/10',
          ),
        ],
      ),
    );
  }
}
