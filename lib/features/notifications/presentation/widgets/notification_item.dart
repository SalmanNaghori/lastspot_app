import 'package:lastspot_app/core/base_import.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationItem extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const NotificationItem({super.key, required this.notification, required this.onTap, required this.onDismiss});

  IconData _getIconForType(String type) {
    switch (type) {
      case 'join_request':
        return Icons.person_add;
      case 'join_accepted':
        return Icons.check_circle;
      case 'join_rejected':
        return Icons.cancel;
      case 'broadcast':
        return Icons.campaign;
      case 'system':
      default:
        return Icons.info;
    }
  }

  Color _getIconColorForType(String type, BuildContext context) {
    switch (type) {
      case 'join_request':
        return context.primaryColor;
      case 'join_accepted':
        return context.successColor;
      case 'join_rejected':
        return context.errorColor;
      case 'broadcast':
        return context.warningColor;
      case 'system':
      default:
        return context.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isUnread = !notification.isRead;

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        color: context.errorColor,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: Dimensions.r16.dynamicW),
        child: Icon(Icons.delete, color: AppColor.whiteColor),
      ),
      child: Material(
        color: isUnread ? context.primaryColor.withValues(alpha: 0.05) : context.surfaceColor,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.r16.dynamicW, vertical: Dimensions.r12.dynamicH),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(Dimensions.r10.dynamicW),
                  decoration: BoxDecoration(
                    color: _getIconColorForType(notification.type, context).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getIconForType(notification.type),
                    color: _getIconColorForType(notification.type, context),
                    size: Dimensions.r20.dynamicH,
                  ),
                ),
                SizedBox(width: Dimensions.r12.dynamicW),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title.capitalizeFirst(),
                              style: TextStyle(
                                fontSize: Dimensions.r16.dynamicSP,
                                fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                                color: context.textPrimary,
                              ),
                            ),
                          ),
                          if (isUnread) ...[
                            SizedBox(width: Dimensions.r8.dynamicW),
                            Container(
                              width: Dimensions.r8.dynamicW,
                              height: Dimensions.r8.dynamicH,
                              decoration: const BoxDecoration(color: AppColor.errorColor, shape: BoxShape.circle),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: Dimensions.r4.dynamicH),
                      Text(
                        notification.body,
                        style: TextStyle(fontSize: Dimensions.r14.dynamicSP, color: context.textSecondary),
                      ),
                      SizedBox(height: Dimensions.r4.dynamicH),
                      Text(
                        AppUtils.timeAgo(notification.createdAt),
                        style: TextStyle(fontSize: Dimensions.r12.dynamicSP, color: context.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
