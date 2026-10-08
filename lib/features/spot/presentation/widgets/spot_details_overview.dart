import 'package:lastspot_app/core/base_import.dart';
import '../../domain/entities/request_entity.dart';
import 'spot_host_avatar.dart';

class SpotDetailsOverview extends StatelessWidget {
  final RequestEntity post;

  const SpotDetailsOverview({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final colors = context.colorScheme;
    final status = switch (post.status) {
      RequestStatus.open => loc.detailsOpen,
      RequestStatus.full => loc.statusFull,
      RequestStatus.completed => loc.statusCompleted,
      RequestStatus.cancelled => loc.statusCancelled,
      RequestStatus.expired => loc.statusExpired,
      RequestStatus.draft => loc.detailsDraft,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.smLg,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: colors.secondaryContainer,
            borderRadius: AppRadius.pillBorderRadius,
          ),
          child: Text(
            status,
            style: context.labelMedium?.copyWith(
              color: colors.onSecondaryContainer,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          post.title.trim().isEmpty ? post.locationName : post.title.trim(),
          style: context.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            SpotHostAvatar(
              name: post.hostProfile?.fullName ?? loc.activityHost,
              photoUrl: post.hostProfile?.avatarUrl,
            ),
            const SizedBox(width: AppSpacing.smLg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.detailsHostedBy,
                    style: context.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    post.hostProfile?.fullName ?? loc.activityHost,
                    style: context.titleSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
