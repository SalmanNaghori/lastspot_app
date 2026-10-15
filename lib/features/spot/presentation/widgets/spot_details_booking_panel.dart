import 'package:lastspot_app/core/base_import.dart';
import '../../domain/policies/spot_participation_policy.dart';
import '../bloc/spot_details_bloc.dart';
import 'spot_details_cta_button.dart';

class SpotDetailsBookingPanel extends StatelessWidget {
  final SpotDetailsLoaded state;
  final bool compact;

  const SpotDetailsBookingPanel({
    super.key,
    required this.state,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final colors = context.colorScheme;
    final post = state.post;
    final availability = SpotParticipationPolicy.availability(
      post: post,
      request: state.userJoinRequest,
      now: DateTime.now(),
    );
    final canAccessGroupChat = SpotParticipationPolicy.canAccessGroupChat(
      isHost: state.isHost,
      request: state.userJoinRequest,
    );
    final hint = state.isHost
        ? loc.detailsHostHint
        : switch (availability) {
            SpotJoinAvailability.pending => loc.detailsPendingHint,
            SpotJoinAvailability.accepted => loc.detailsJoinedHint,
            SpotJoinAvailability.available => loc.detailsJoinHint,
            _ => null,
          };
    return Container(
      padding: const EdgeInsets.all(AppSpacing.mdLg),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.xxlBorderRadius,
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: Dimensions.r8.dynamicW,
            runSpacing: Dimensions.r4.dynamicH,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Image.asset(
                AppAssets.priceTag3d,
                width: Dimensions.r22.dynamicW,
                height: Dimensions.r22.dynamicH,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),
              Text(
                post.pricePerPerson > 0
                    ? AppUtils.formatCurrency(post.pricePerPerson)
                    : loc.free,
                style: context.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (post.pricePerPerson > 0)
                Text(
                  loc.perPerson,
                  style: context.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
            ],
          ),
          SizedBox(height: Dimensions.r8.dynamicH),
          Row(
            children: [
              Image.asset(
                AppAssets.participants3d,
                width: Dimensions.r16.dynamicW,
                height: Dimensions.r16.dynamicH,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),
              SizedBox(width: Dimensions.r6.dynamicW),
              Expanded(
                child: Text(
                  loc.detailsAvailability(
                    SpotParticipationPolicy.remainingSpots(post),
                    post.maxParticipants,
                  ),
                  style: context.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          if (!compact) ...[
            const SizedBox(height: AppSpacing.smLg),
            LinearProgressIndicator(
              value: SpotParticipationPolicy.occupancy(post),
              backgroundColor: colors.primaryContainer,
              borderRadius: AppRadius.pillBorderRadius,
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          SpotDetailsCtaButton(loadedState: state),
          if (!state.isHost &&
              (availability == SpotJoinAvailability.pending ||
                  availability == SpotJoinAvailability.accepted)) ...[
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton.icon(
              onPressed: () {
                final uri = Uri(
                  path: AppRoutes.chatPath(post.id),
                  queryParameters: {
                    'recipient': post.userId,
                    'name': post.hostProfile?.fullName ?? loc.messageHost,
                  },
                );
                context.push(uri.toString());
              },
              icon: const Icon(Icons.chat_bubble_outline),
              label: Text(loc.messageHost),
            ),
          ],
          // Group Chat: visible and accessible to host and accepted participants
          if (canAccessGroupChat) ...[
            const SizedBox(height: AppSpacing.sm),
            FilledButton.icon(
              onPressed: () => context.push(
                AppRoutes.activityGroupChatPath(post.id, title: post.title),
              ),
              icon: const Icon(Icons.forum_outlined),
              label: Text(loc.groupChat),
            ),
          ],
          if (!compact && hint != null) ...[
            const SizedBox(height: AppSpacing.smLg),
            Text(
              hint,
              style: context.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
