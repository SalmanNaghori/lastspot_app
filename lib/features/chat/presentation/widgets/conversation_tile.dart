import 'package:intl/intl.dart';
import '../../../../core/base_import.dart';
import '../../domain/entities/chat_conversation_entity.dart';

class ConversationTile extends StatelessWidget {
  final ChatConversationEntity conversation;
  final VoidCallback onTap;

  const ConversationTile({
    super.key,
    required this.conversation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final isDirect = conversation.isDirect;
    final title = isDirect
        ? (conversation.otherUserName?.trim().isNotEmpty == true
              ? conversation.otherUserName!.trim()
              : context.loc.directMessage)
        : (conversation.activityTitle?.trim().isNotEmpty == true
              ? conversation.activityTitle!.trim()
              : context.loc.groupChat);

    final lastMessage = conversation.lastMessage?.trim().isNotEmpty == true
        ? conversation.lastMessage!.trim()
        : context.loc.chatEmpty;

    String timeStr = '';
    if (conversation.lastMessageAt != null) {
      final now = DateTime.now();
      final local = conversation.lastMessageAt!.toLocal();
      final today = DateTime(now.year, now.month, now.day);
      final msgDay = DateTime(local.year, local.month, local.day);
      final diff = today.difference(msgDay).inDays;
      if (diff == 0) {
        timeStr = AppUtils.formatTime(local);
      } else if (diff == 1) {
        timeStr = context.loc.yesterday;
      } else {
        timeStr = DateFormat('d MMM').format(local);
      }
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mdBorderRadius,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.r16.dynamicW,
            vertical: Dimensions.r12.dynamicH,
          ),
          child: Row(
            children: [
              Container(
                width: Dimensions.r48.dynamicW,
                height: Dimensions.r48.dynamicH,
                decoration: BoxDecoration(
                  color: isDirect
                      ? context.primaryColor.withValues(alpha: 0.12)
                      : (context.isDarkMode
                            ? context.surfaceContainer
                            : const Color(0xFFF0FDF4)),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDirect
                        ? context.primaryColor.withValues(alpha: 0.25)
                        : context.borderColor.withValues(alpha: 0.6),
                    width: 1.0,
                  ),
                ),
                alignment: Alignment.center,
                child: isDirect
                    ? Text(
                        (conversation.otherUserName?.isNotEmpty == true
                                ? conversation.otherUserName![0]
                                : 'U')
                            .toUpperCase(),
                        style: TextStyle(
                          color: context.primaryColor,
                          fontSize: Dimensions.r18.dynamicSP,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.all(Dimensions.r6.dynamicW),
                        child: Image.asset(
                          AppAssets.getCategoryAsset(
                            conversation.activityTitle,
                          ),
                          cacheWidth: 96,
                          cacheHeight: 96,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            AppUtils.getCategoryIcon(
                              conversation.activityTitle,
                            ),
                            size: Dimensions.r22.dynamicH,
                            color: context.primaryColor,
                          ),
                        ),
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
                            title,
                            style: context.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (timeStr.isNotEmpty)
                          Text(
                            timeStr,
                            style: context.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: Dimensions.r4.dynamicH),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            lastMessage,
                            style: context.bodyMedium?.copyWith(
                              color: conversation.unreadCount > 0
                                  ? colors.onSurface
                                  : colors.onSurfaceVariant,
                              fontWeight: conversation.unreadCount > 0
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (conversation.unreadCount > 0) ...[
                          SizedBox(width: Dimensions.r8.dynamicW),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primary,
                              borderRadius: AppRadius.pillBorderRadius,
                            ),

                            child: Text(
                              '${conversation.unreadCount}',
                              style: context.labelSmall?.copyWith(
                                color: colors.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
