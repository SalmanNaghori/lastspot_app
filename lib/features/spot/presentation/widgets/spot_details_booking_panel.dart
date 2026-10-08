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
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
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
          const SizedBox(height: AppSpacing.sm),
          Text(
            loc.detailsAvailability(
              SpotParticipationPolicy.remainingSpots(post),
              post.maxParticipants,
            ),
            style: context.bodySmall?.copyWith(color: colors.onSurfaceVariant),
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
