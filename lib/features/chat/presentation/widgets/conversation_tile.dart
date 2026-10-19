import 'package:intl/intl.dart';
import '../../../../core/base_import.dart';
import '../../domain/entities/chat_conversation_entity.dart';
import '../utils/chat_text_formatter.dart';
import 'chat_avatar.dart';

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
    final title = conversation.getTitle(
      defaultDirect: context.loc.directMessage,
      defaultGroup: context.loc.groupChat,
    );
    final activityContext = conversation.getDirectActivitySubtitle(
      fallbackActivityLabel: context.loc.activity,
    );
    final lastMessage = conversation.getPreviewMessage(
      defaultEmpty: context.loc.chatEmpty,
    );

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
              ChatAvatar(
                isDirect: isDirect,
                avatarUrl: conversation.displayAvatarUrl,
                displayName: conversation.avatarDisplayName,
                category: conversation.categoryOrActivity,
                size: Dimensions.r48.dynamicH,
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
                    if (activityContext != null) ...[
                      SizedBox(height: Dimensions.r2.dynamicH),
                      Row(
                        children: [
                          Icon(
                            Icons.sports_soccer_outlined,
                            size: Dimensions.r14.dynamicH,
                            color: context.primaryColor,
                          ),
                          SizedBox(width: Dimensions.r4.dynamicW),
                          Expanded(
                            child: Text(
                              activityContext,
                              style: context.labelSmall?.copyWith(
                                color: context.primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: Dimensions.r12.dynamicSP,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    SizedBox(height: Dimensions.r4.dynamicH),
                    Row(
                      children: [
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              children: ChatTextFormatter.buildPreviewSpans(
                                text: lastMessage,
                                baseStyle:
                                    (context.bodyMedium ?? const TextStyle())
                                        .copyWith(
                                          color: conversation.unreadCount > 0
                                              ? colors.onSurface
                                              : colors.onSurfaceVariant,
                                          fontWeight:
                                              conversation.unreadCount > 0
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                              ),
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
