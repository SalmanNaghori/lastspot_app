import 'package:lastspot_app/core/base_import.dart';

class CompactActivityCard extends StatelessWidget {
  final String title;
  final String date;
  final String location;
  final String stats;
  final String status;
  final bool isFull;
  final VoidCallback onTap;
  final VoidCallback? onChatTap;
  final VoidCallback? onManageTap;
  final int pendingCount;

  const CompactActivityCard({
    super.key,
    required this.title,
    required this.date,
    required this.location,
    required this.stats,
    required this.status,
    this.isFull = false,
    required this.onTap,
    this.onChatTap,
    this.onManageTap,
    this.pendingCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(Dimensions.r16.dynamicW),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
          border: Border.all(color: context.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title.capitalizeFirst(),
                    style: context.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: Dimensions.r8.dynamicW),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.r10.dynamicW,
                    vertical: Dimensions.r4.dynamicH,
                  ),
                  decoration: BoxDecoration(
                    color: isFull
                        ? context.successColor.withValues(alpha: 0.1)
                        : context.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      Dimensions.r16.dynamicR,
                    ),
                  ),
                  child: Text(
                    status,
                    style: context.labelSmall?.copyWith(
                      color: isFull
                          ? context.successColor
                          : context.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.r12.dynamicH),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                        context,
                        ActivityMetadataIcon.calendar(
                          size: Dimensions.r16.dynamicH,
                          fallbackColor: context.primaryColor,
                        ),
                        date,
                      ),
                      SizedBox(height: Dimensions.r8.dynamicH),
                      _buildInfoRow(
                        context,
                        ActivityMetadataIcon.location(
                          size: Dimensions.r16.dynamicH,
                          fallbackColor: context.primaryColor,
                        ),
                        location,
                      ),
                      SizedBox(height: Dimensions.r8.dynamicH),
                      _buildInfoRow(
                        context,
                        ActivityMetadataIcon.participants(
                          size: Dimensions.r16.dynamicH,
                          fallbackColor: context.primaryColor,
                        ),
                        stats,
                      ),
                    ],
                  ),
                ),
                if (onChatTap != null) ...[
                  IconButton(
                    icon: const Icon(Icons.forum_outlined),
                    tooltip: context.loc.groupChat,
                    color: context.primaryColor,
                    iconSize: Dimensions.r20.dynamicH,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: onChatTap,
                  ),
                  SizedBox(width: Dimensions.r12.dynamicW),
                ],
                Icon(
                  Icons.chevron_right,
                  color: context.textTertiary,
                  size: Dimensions.r20.dynamicH,
                ),
              ],
            ),
            if (onManageTap != null) ...[
              SizedBox(height: Dimensions.r12.dynamicH),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: onManageTap,
                    borderRadius: BorderRadius.circular(Dimensions.r8.dynamicR),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.r10.dynamicW,
                        vertical: Dimensions.r6.dynamicH,
                      ),
                      decoration: BoxDecoration(
                        color: context.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          Dimensions.r8.dynamicR,
                        ),
                        border: Border.all(
                          color: context.primaryColor.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.assignment_ind_outlined,
                            size: Dimensions.r16.dynamicH,
                            color: context.primaryColor,
                          ),
                          SizedBox(width: Dimensions.r6.dynamicW),
                          Text(
                            context.loc.manageMatchRequests,
                            style: context.labelSmall?.copyWith(
                              color: context.primaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (pendingCount > 0) ...[
                            SizedBox(width: Dimensions.r6.dynamicW),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.r6.dynamicW,
                                vertical: Dimensions.r2.dynamicH,
                              ),
                              decoration: BoxDecoration(
                                color: context.primaryColor,
                                borderRadius: BorderRadius.circular(
                                  Dimensions.r10.dynamicR,
                                ),
                              ),
                              child: Text(
                                '$pendingCount',
                                style: context.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, Widget leading, String text) {
    return Row(
      children: [
        leading,
        SizedBox(width: Dimensions.r8.dynamicW),
        Expanded(
          child: Text(
            text,
            style: context.bodyMedium?.copyWith(color: context.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
