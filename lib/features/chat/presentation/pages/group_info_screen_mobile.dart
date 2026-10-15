import '../../../../core/base_import.dart';
import '../../../spot/domain/entities/join_request_entity.dart';
import '../../../spot/domain/entities/request_entity.dart';
import '../widgets/group_info_participant_tile.dart';

/// Mobile view for Group Info screen.
class GroupInfoScreenMobile extends StatelessWidget {
  final RequestEntity post;
  final List<JoinRequestEntity> confirmedPlayers;
  final String? currentUserId;
  final VoidCallback onBack;

  const GroupInfoScreenMobile({
    super.key,
    required this.post,
    required this.confirmedPlayers,
    this.currentUserId,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final loc = context.loc;
    final categoryEmoji = AppUtils.getCategoryEmoji(post.title);
    final categoryIcon = AppUtils.getCategoryIcon(post.title);
    final totalCount = confirmedPlayers.length + 1; // +1 for host

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 1,
        title: Text(loc.groupInfoTitle),
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.r16.dynamicW,
          vertical: Dimensions.r12.dynamicH,
        ),
        children: [
          // 1. Group Header Card
          Container(
            padding: EdgeInsets.all(Dimensions.r20.dynamicW),
            decoration: BoxDecoration(
              color: colors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
              border: Border.all(
                color: colors.outlineVariant.withValues(alpha: 0.5),
                width: 0.5,
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: Dimensions.r72.dynamicW,
                  height: Dimensions.r72.dynamicH,
                  decoration: BoxDecoration(
                    color: context.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: AppAssets.getCategoryGen(post.title).image(
                      width: Dimensions.r48.dynamicW,
                      height: Dimensions.r48.dynamicH,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        categoryIcon,
                        size: Dimensions.r32.dynamicH,
                        color: context.primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.r12.dynamicH),
                Text(
                  post.title.trim().isNotEmpty
                      ? '${post.title.trim()} $categoryEmoji'
                      : loc.groupChat,
                  style: context.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Dimensions.r4.dynamicH),
                Text(
                  loc.matchGroupChat,
                  style: context.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Dimensions.r16.dynamicH),

          // 2. Activity Details Section
          Text(
            loc.groupInfoActivityDetails,
            style: context.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.primary,
            ),
          ),
          SizedBox(height: Dimensions.r8.dynamicH),
          Container(
            padding: EdgeInsets.all(Dimensions.r16.dynamicW),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
              border: Border.all(
                color: colors.outlineVariant.withValues(alpha: 0.4),
                width: 0.5,
              ),
            ),
            child: Column(
              children: [
                _buildInfoRow(
                  context,
                  Icons.calendar_today_outlined,
                  AppUtils.formatDateTime(post.eventDateTime.toLocal()),
                ),
                Divider(
                  height: Dimensions.r16.dynamicH,
                  color: colors.outlineVariant.withValues(alpha: 0.3),
                ),
                _buildInfoRow(
                  context,
                  Icons.location_on_outlined,
                  post.locationName,
                ),
                Divider(
                  height: Dimensions.r16.dynamicH,
                  color: colors.outlineVariant.withValues(alpha: 0.3),
                ),
                _buildInfoRow(
                  context,
                  Icons.people_outline,
                  '${post.currentParticipants}/${post.maxParticipants} ${loc.joined}',
                ),
                Divider(
                  height: Dimensions.r16.dynamicH,
                  color: colors.outlineVariant.withValues(alpha: 0.3),
                ),
                _buildInfoRow(
                  context,
                  Icons.payments_outlined,
                  post.pricePerPerson > 0
                      ? '${AppUtils.formatCurrency(post.pricePerPerson)} ${loc.perPerson}'
                      : loc.free,
                ),
              ],
            ),
          ),
          SizedBox(height: Dimensions.r20.dynamicH),

          // 3. Participants Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                loc.groupInfoParticipants,
                style: context.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.primary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.r8.dynamicW,
                  vertical: Dimensions.r2.dynamicH,
                ),
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
                ),
                child: Text(
                  '$totalCount',
                  style: context.labelSmall?.copyWith(
                    color: colors.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.r8.dynamicH),
          Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
              border: Border.all(
                color: colors.outlineVariant.withValues(alpha: 0.4),
                width: 0.5,
              ),
            ),
            child: Column(
              children: [
                // Host tile
                GroupInfoParticipantTile(
                  profile: post.hostProfile,
                  isHost: true,
                  isCurrentUser: post.userId == currentUserId,
                ),
                // Confirmed players
                ...confirmedPlayers.map(
                  (player) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Divider(
                        height: 1,
                        indent: Dimensions.r48.dynamicW,
                        color: colors.outlineVariant.withValues(alpha: 0.3),
                      ),
                      GroupInfoParticipantTile(
                        profile: player.userProfile,
                        isHost: false,
                        isCurrentUser: player.userId == currentUserId,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Dimensions.r32.dynamicH),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    final colors = context.colorScheme;
    return Row(
      children: [
        Icon(icon, size: Dimensions.r18.dynamicH, color: colors.primary),
        SizedBox(width: Dimensions.r12.dynamicW),
        Expanded(
          child: Text(
            text,
            style: context.bodyMedium?.copyWith(color: colors.onSurface),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
