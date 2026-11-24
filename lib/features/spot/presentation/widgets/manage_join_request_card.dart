import '../../../../core/base_import.dart';
import '../../domain/entities/join_request_entity.dart';

/// Card tile for reviewing, accepting, or rejecting an incoming join request.
/// Supports official Flutter [Dismissible] swipe gestures for pending requests:
/// - Swipe Left-to-Right: Accept request
/// - Swipe Right-to-Left: Reject request
class ManageJoinRequestCard extends StatelessWidget {
  final JoinRequestEntity request;
  final int remainingSpots;
  final bool isProcessing;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onMessage;
  final VoidCallback onViewProfile;

  const ManageJoinRequestCard({
    super.key,
    required this.request,
    required this.remainingSpots,
    this.isProcessing = false,
    required this.onAccept,
    required this.onReject,
    required this.onMessage,
    required this.onViewProfile,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = _buildCardBody(context);

    // Only pending requests can be dismissed/swiped
    if (request.status != JoinRequestStatus.pending) {
      return cardContent;
    }

    return Dismissible(
      key: ValueKey('manage_request_${request.id}'),
      direction: isProcessing ? DismissDirection.none : DismissDirection.horizontal,
      background: _buildSwipeBackground(
        context,
        color: context.successColor,
        alignment: Alignment.centerLeft,
        icon: Icons.check_circle_rounded,
        label: context.loc.accept,
      ),
      secondaryBackground: _buildSwipeBackground(
        context,
        color: context.errorColor,
        alignment: Alignment.centerRight,
        icon: Icons.cancel_rounded,
        label: context.loc.reject,
      ),
      confirmDismiss: (direction) async {
        if (isProcessing) return false;

        if (direction == DismissDirection.startToEnd) {
          // Swipe Right: Accept
          if (remainingSpots <= 0) {
            AppUtils.showSnackBar(context, context.loc.activityFullMessage, isError: true);
            return false;
          }
          onAccept();
          return true;
        } else if (direction == DismissDirection.endToStart) {
          // Swipe Left: Reject
          onReject();
          return true;
        }
        return false;
      },
      child: cardContent,
    );
  }

  Widget _buildSwipeBackground(
    BuildContext context, {
    required Color color,
    required Alignment alignment,
    required IconData icon,
    required String label,
  }) {
    final isLeft = alignment == Alignment.centerLeft;
    return Container(
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR)),
      padding: EdgeInsets.symmetric(horizontal: Dimensions.r24.dynamicW),
      alignment: alignment,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLeft) ...[
            Icon(icon, color: Colors.white, size: Dimensions.r24.dynamicH),
            SizedBox(width: Dimensions.r8.dynamicW),
            Text(
              label,
              style: context.titleSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ] else ...[
            Text(
              label,
              style: context.titleSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
            ),
            SizedBox(width: Dimensions.r8.dynamicW),
            Icon(icon, color: Colors.white, size: Dimensions.r24.dynamicH),
          ],
        ],
      ),
    );
  }

  Widget _buildCardBody(BuildContext context) {
    final colors = context.colorScheme;
    final name = request.userProfile?.fullName?.trim();
    final displayName = name == null || name.isEmpty ? context.loc.player : name;
    final city = request.userProfile?.city?.trim() ?? request.userProfile?.cityId?.trim();

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Avatar, Name, City, Request Date, and Status Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: onViewProfile,
                child: UserAvatar(imageUrl: request.userProfile?.avatarUrl, name: displayName, size: 48),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: GestureDetector(
                  onTap: onViewProfile,
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: context.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (city != null && city.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: Dimensions.r14.dynamicH,
                              color: colors.onSurfaceVariant,
                            ),
                            SizedBox(width: Dimensions.r2.dynamicW),
                            Expanded(
                              child: Text(
                                city,
                                style: context.bodySmall?.copyWith(color: colors.onSurfaceVariant),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        AppUtils.formatDateTime(request.createdAt),
                        style: context.bodySmall?.copyWith(color: colors.onSurfaceVariant, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
              _buildStatusBadge(context),
            ],
          ),

          // Row 2: Applicant Message (if provided)
          if (request.message?.trim().isNotEmpty == true) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(color: colors.surfaceContainerLow, borderRadius: AppRadius.mdBorderRadius),
              child: Text(request.message!.trim(), style: context.bodyMedium?.copyWith(color: colors.onSurfaceVariant)),
            ),
          ],
          const SizedBox(height: AppSpacing.md),

          // Row 3: Action Buttons (View Profile & Message)
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onViewProfile,
                  icon: const Icon(Icons.person_outline, size: 18),
                  label: Text(context.loc.viewProfile),
                  style: OutlinedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: Dimensions.r8.dynamicH)),
                ),
              ),
              SizedBox(width: Dimensions.r8.dynamicW),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onMessage,
                  icon: const Icon(Icons.chat_bubble_outline, size: 18),
                  label: Text(context.loc.directMessage),
                  style: OutlinedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: Dimensions.r8.dynamicH)),
                ),
              ),
            ],
          ),

          // Row 4: Status-Specific Footer Controls
          if (request.status == JoinRequestStatus.pending) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: isProcessing ? null : onReject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.error,
                      side: BorderSide(color: colors.error),
                      padding: EdgeInsets.symmetric(vertical: Dimensions.r10.dynamicH),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.close, size: 18),
                        const SizedBox(width: AppSpacing.xs),
                        Text(context.loc.reject),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: FilledButton(
                    onPressed: isProcessing ? null : onAccept,
                    style: FilledButton.styleFrom(
                      backgroundColor: context.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: Dimensions.r10.dynamicH),
                    ),
                    child: isProcessing
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.check, size: 18),
                              const SizedBox(width: AppSpacing.xs),
                              Text(context.loc.accept),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ] else if (request.status == JoinRequestStatus.accepted) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: Dimensions.r8.dynamicH, horizontal: Dimensions.r12.dynamicW),
              decoration: BoxDecoration(
                color: context.successColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.r8.dynamicR),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline_rounded, size: Dimensions.r16.dynamicH, color: context.successColor),
                  SizedBox(width: Dimensions.r6.dynamicW),
                  Text(
                    context.loc.confirmedParticipant,
                    style: context.labelMedium?.copyWith(color: context.successColor, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ] else if (request.status == JoinRequestStatus.rejected) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: Dimensions.r8.dynamicH, horizontal: Dimensions.r12.dynamicW),
              decoration: BoxDecoration(
                color: colors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Dimensions.r8.dynamicR),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cancel_outlined, size: Dimensions.r16.dynamicH, color: colors.error),
                  SizedBox(width: Dimensions.r6.dynamicW),
                  Text(
                    context.loc.requestRejectedStatus,
                    style: context.labelMedium?.copyWith(color: colors.error, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final colors = context.colorScheme;
    Color bgColor;
    Color textColor;
    String label;

    switch (request.status) {
      case JoinRequestStatus.pending:
        bgColor = context.primaryColor.withValues(alpha: 0.12);
        textColor = context.primaryColor;
        label = context.loc.tabPending;
        break;
      case JoinRequestStatus.accepted:
        bgColor = context.successColor.withValues(alpha: 0.12);
        textColor = context.successColor;
        label = context.loc.statusAccepted;
        break;
      case JoinRequestStatus.rejected:
        bgColor = colors.error.withValues(alpha: 0.12);
        textColor = colors.error;
        label = context.loc.statusRejected;
        break;
      case JoinRequestStatus.cancelled:
        bgColor = colors.onSurfaceVariant.withValues(alpha: 0.12);
        textColor = colors.onSurfaceVariant;
        label = context.loc.requestCancelled;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.r8.dynamicW, vertical: Dimensions.r2.dynamicH),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(Dimensions.r6.dynamicR)),
      child: Text(
        label,
        style: context.labelSmall?.copyWith(color: textColor, fontWeight: FontWeight.w700, fontSize: 11),
      ),
    );
  }
}
