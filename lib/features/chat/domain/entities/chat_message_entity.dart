class ChatMessageEntity {
  final String id;
  final String conversationId;
  final String senderId;
  final String? senderName;
  final String content;
  final DateTime createdAt;
  final DateTime? deletedAt;

  const ChatMessageEntity({
    required this.id,
    required this.conversationId,
    required this.senderId,
    this.senderName,
    required this.content,
    required this.createdAt,
    this.deletedAt,
  });
}
