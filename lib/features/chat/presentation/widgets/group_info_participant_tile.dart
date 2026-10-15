import '../../../../core/base_import.dart';
import '../../../auth/domain/entities/user_profile.dart';

/// Reusable participant tile for Group Info screen.
class GroupInfoParticipantTile extends StatelessWidget {
  final UserProfile? profile;
  final bool isHost;
  final bool isCurrentUser;

  const GroupInfoParticipantTile({
    super.key,
    required this.profile,
    required this.isHost,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final name = profile?.fullName?.trim().isNotEmpty == true
        ? profile!.fullName!.trim()
        : context.loc.player;
    final avatarUrl = profile?.avatarUrl;
    final initial = name.isNotEmpty ? name.characters.first.toUpperCase() : '?';

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.r16.dynamicW,
        vertical: Dimensions.r8.dynamicH,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: Dimensions.r20.dynamicR,
            backgroundColor: isHost
                ? colors.primaryContainer
                : colors.secondaryContainer,
            backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                ? NetworkImage(avatarUrl)
                : null,
            child: avatarUrl == null || avatarUrl.isEmpty
                ? Text(
                    initial,
                    style: context.titleSmall?.copyWith(
                      color: isHost
                          ? colors.onPrimaryContainer
                          : colors.onSecondaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          SizedBox(width: Dimensions.r12.dynamicW),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        style: context.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isCurrentUser) ...[
                      SizedBox(width: Dimensions.r6.dynamicW),
                      Text(
                        '(${context.loc.you})',
                        style: context.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: Dimensions.r2.dynamicH),
                Text(
                  isHost ? context.loc.groupInfoHost : context.loc.joined,
                  style: context.bodySmall?.copyWith(
                    color: isHost ? colors.primary : colors.onSurfaceVariant,
                    fontWeight: isHost ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          if (isHost)
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.r8.dynamicW,
                vertical: Dimensions.r2.dynamicH,
              ),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
                border: Border.all(
                  color: colors.primary.withValues(alpha: 0.3),
                  width: 0.5,
                ),
              ),
              child: Text(
                context.loc.groupInfoOrganizer,
                style: context.labelSmall?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
