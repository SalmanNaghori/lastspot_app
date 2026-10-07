import 'package:lastspot_app/core/base_import.dart';

class CompactActivityCard extends StatelessWidget {
  final String title;
  final String date;
  final String location;
  final String stats;
  final String status;
  final bool isFull;
  final VoidCallback onTap;

  const CompactActivityCard({
    super.key,
    required this.title,
    required this.date,
    required this.location,
    required this.stats,
    required this.status,
    this.isFull = false,
    required this.onTap,
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
                        Icons.calendar_today_outlined,
                        date,
                      ),
                      SizedBox(height: Dimensions.r8.dynamicH),
                      _buildInfoRow(
                        context,
                        Icons.location_on_outlined,
                        location,
                      ),
                      SizedBox(height: Dimensions.r8.dynamicH),
                      _buildInfoRow(context, Icons.people_outline, stats),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: context.textTertiary,
                  size: Dimensions.r20.dynamicH,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: Dimensions.r16.dynamicH, color: context.primaryColor),
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
