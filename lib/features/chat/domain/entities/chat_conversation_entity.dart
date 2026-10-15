class ChatConversationEntity {
  final String conversationId;
  final String requestId;
  final String? activityTitle;
  final String chatType;
  final String? otherUserId;
  final String? otherUserName;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final int unreadCount;

  const ChatConversationEntity({
    required this.conversationId,
    required this.requestId,
    this.activityTitle,
    required this.chatType,
    this.otherUserId,
    this.otherUserName,
    this.lastMessage,
    this.lastMessageAt,
    this.unreadCount = 0,
  });

  bool get isDirect => chatType == 'direct';
}
