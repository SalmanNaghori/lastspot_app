import '../../../../core/base_import.dart';
import '../../domain/entities/join_request_entity.dart';

/// Card tile for reviewing, accepting, or rejecting an incoming join request.
class ManageJoinRequestCard extends StatelessWidget {
  final JoinRequestEntity request;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onMessage;

  const ManageJoinRequestCard({
    super.key,
    required this.request,
    required this.onAccept,
    required this.onReject,
    required this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final name = request.userProfile?.fullName?.trim();
    final displayName = name == null || name.isEmpty
        ? context.loc.player
        : name;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              UserAvatar(
                imageUrl: request.userProfile?.avatarUrl,
                name: displayName,
                size: 48,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: context.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      AppUtils.formatDateTime(request.createdAt),
                      style: context.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.schedule, size: 18, color: colors.onSurfaceVariant),
            ],
          ),
          if (request.message?.trim().isNotEmpty == true) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: colors.surfaceContainerLow,
                borderRadius: AppRadius.mdBorderRadius,
              ),
              child: Text(
                request.message!.trim(),
                style: context.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: onMessage,
              icon: const Icon(Icons.chat_bubble_outline),
              label: Text(context.loc.directMessage),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onReject,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colors.error,
                    side: BorderSide(color: colors.error),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.close),
                      const SizedBox(width: AppSpacing.xs),
                      Text(context.loc.reject),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: FilledButton(
                  onPressed: onAccept,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check),
                      const SizedBox(width: AppSpacing.xs),
                      Text(context.loc.accept),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
