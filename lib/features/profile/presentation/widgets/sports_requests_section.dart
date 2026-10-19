import '../../../../core/base_import.dart';
import '../../../spot/domain/entities/join_request_entity.dart';

/// Compact preview section for user's sent join requests.
///
/// Features:
/// - Overview of pending, accepted, or rejected join requests.
/// - Status pills with clear visual hierarchy.
/// - "View All" CTA opening the Activities > Requests management view.
class SportsRequestsSection extends StatelessWidget {
  final List<JoinRequestEntity> sentRequests;
  final VoidCallback onViewAll;

  const SportsRequestsSection({
    super.key,
    required this.sentRequests,
    required this.onViewAll,
  });

  Color _getStatusColor(BuildContext context, JoinRequestStatus status) {
    switch (status) {
      case JoinRequestStatus.pending:
        return AppColor.warningColor;
      case JoinRequestStatus.accepted:
        return AppColor.successColor;
      case JoinRequestStatus.rejected:
      case JoinRequestStatus.cancelled:
        return context.colorScheme.error;
    }
  }

  String _getStatusText(AppLocalizations loc, JoinRequestStatus status) {
    switch (status) {
      case JoinRequestStatus.pending:
        return loc.statusPending;
      case JoinRequestStatus.accepted:
        return loc.statusAccepted;
      case JoinRequestStatus.rejected:
        return loc.statusRejected;
      case JoinRequestStatus.cancelled:
        return loc.statusCancelled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final displayRequests = sentRequests.take(3).toList();

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.how_to_reg_rounded,
                      size: Dimensions.r18.dynamicH,
                      color: context.primaryColor,
                    ),
                    SizedBox(width: Dimensions.r8.dynamicW),
                    Flexible(
                      child: Text(
                        loc.myRequests,
                        style: TextStyle(
                          fontSize: Dimensions.r15.dynamicSP,
                          fontWeight: FontWeight.w800,
                          color: context.textPrimary,
                          letterSpacing: -0.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (sentRequests.isNotEmpty) ...[
                      SizedBox(width: Dimensions.r6.dynamicW),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.r6.dynamicW,
                          vertical: Dimensions.r2.dynamicH,
                        ),
                        decoration: BoxDecoration(
                          color: context.primaryColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(
                            Dimensions.r8.dynamicR,
                          ),
                        ),
                        child: Text(
                          '${sentRequests.length}',
                          style: TextStyle(
                            fontSize: Dimensions.r10.dynamicSP,
                            fontWeight: FontWeight.w700,
                            color: context.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              TextButton(
                onPressed: onViewAll,
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  loc.viewAll,
                  style: TextStyle(
                    fontSize: Dimensions.r12.dynamicSP,
                    fontWeight: FontWeight.w700,
                    color: context.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.r8.dynamicH),

          // Content
          if (sentRequests.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: Dimensions.r8.dynamicH),
              child: Text(
                loc.noSentRequests,
                style: TextStyle(
                  fontSize: Dimensions.r12.dynamicSP,
                  color: context.textSecondary,
                ),
              ),
            )
          else
            Column(
              children: displayRequests.map((req) {
                final title = req.request?.title ?? loc.myRequests;
                final statusColor = _getStatusColor(context, req.status);
                final statusText = _getStatusText(loc, req.status);
                final timeAgo = AppUtils.timeAgo(req.createdAt);

                return Container(
                  margin: EdgeInsets.only(top: Dimensions.r8.dynamicH),
                  decoration: BoxDecoration(
                    color: context.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(
                      Dimensions.r12.dynamicR,
                    ),
                    border: Border.all(
                      color: context.colorScheme.outlineVariant.withValues(
                        alpha: 0.25,
                      ),
                      width: 0.8,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(
                      Dimensions.r12.dynamicR,
                    ),
                    onTap: () =>
                        context.push(AppRoutes.spotDetailsPath(req.requestId)),
                    child: Padding(
                      padding: EdgeInsets.all(Dimensions.r10.dynamicW),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: Dimensions.r6.dynamicW,
                                        vertical: Dimensions.r2.dynamicH,
                                      ),
                                      decoration: BoxDecoration(
                                        color: context
                                            .colorScheme
                                            .secondaryContainer
                                            .withValues(alpha: 0.5),
                                        borderRadius: BorderRadius.circular(
                                          Dimensions.r4.dynamicR,
                                        ),
                                      ),
                                      child: Text(
                                        loc.participantRolePlayer,
                                        style: TextStyle(
                                          fontSize: Dimensions.r9.dynamicSP,
                                          fontWeight: FontWeight.w700,
                                          color: context.textPrimary,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: Dimensions.r6.dynamicW),
                                    Expanded(
                                      child: Text(
                                        title,
                                        style: TextStyle(
                                          fontSize: Dimensions.r13.dynamicSP,
                                          fontWeight: FontWeight.w700,
                                          color: context.textPrimary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: Dimensions.r4.dynamicH),
                                Text(
                                  timeAgo,
                                  style: TextStyle(
                                    fontSize: Dimensions.r11.dynamicSP,
                                    color: context.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: Dimensions.r8.dynamicW),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.r8.dynamicW,
                              vertical: Dimensions.r4.dynamicH,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(
                                Dimensions.r8.dynamicR,
                              ),
                            ),
                            child: Text(
                              statusText,
                              style: TextStyle(
                                fontSize: Dimensions.r10.dynamicSP,
                                fontWeight: FontWeight.w700,
                                color: statusColor,
                              ),
                            ),
                          ),
                          SizedBox(width: Dimensions.r4.dynamicW),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: Dimensions.r16.dynamicH,
                            color: context.textSecondary.withValues(alpha: 0.4),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
