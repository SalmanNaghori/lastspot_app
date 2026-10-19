import '../../../../core/base_import.dart';
import 'sports_quick_action_item.dart';

/// Quick action shortcuts for My Sports Space.
///
/// Features:
/// - Find a Game (Explore)
/// - Organize Match (Create)
/// - My Matches (Activities)
/// - Team Chats (Chats)
class SportsQuickActions extends StatelessWidget {
  final VoidCallback onFindGame;
  final VoidCallback onOrganizeMatch;
  final VoidCallback onMyMatches;
  final VoidCallback onTeamChats;

  const SportsQuickActions({
    super.key,
    required this.onFindGame,
    required this.onOrganizeMatch,
    required this.onMyMatches,
    required this.onTeamChats,
  });

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.quickActions,
          style: TextStyle(
            fontSize: Dimensions.r16.dynamicSP,
            fontWeight: FontWeight.w800,
            color: context.textPrimary,
            letterSpacing: -0.3,
          ),
        ),
        SizedBox(height: Dimensions.r10.dynamicH),
        Row(
          children: [
            Expanded(
              child: SportsQuickActionItem(
                label: loc.quickActionFindGame,
                icon: Icons.search_rounded,
                onTap: onFindGame,
              ),
            ),
            SizedBox(width: Dimensions.r10.dynamicW),
            Expanded(
              child: SportsQuickActionItem(
                label: loc.quickActionOrganize,
                icon: Icons.add_circle_outline_rounded,
                onTap: onOrganizeMatch,
              ),
            ),
          ],
        ),
        SizedBox(height: Dimensions.r10.dynamicH),
        Row(
          children: [
            Expanded(
              child: SportsQuickActionItem(
                label: loc.quickActionMyMatches,
                icon: Icons.sports_soccer_rounded,
                onTap: onMyMatches,
              ),
            ),
            SizedBox(width: Dimensions.r10.dynamicW),
            Expanded(
              child: SportsQuickActionItem(
                label: loc.quickActionChats,
                icon: Icons.chat_bubble_outline_rounded,
                onTap: onTeamChats,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
