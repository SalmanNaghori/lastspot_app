import '../../../../core/utils/result.dart';
import '../entities/chat_conversation_entity.dart';
import '../entities/chat_message_entity.dart';

abstract class ChatRepository {
  Future<Result<String, Exception>> getOrCreateDirectChat(String requestId);
  Future<Result<String, Exception>> getOrCreateGroupChat(String requestId);
  Future<Result<List<ChatConversationEntity>, Exception>> getMyConversations();
  Future<Result<List<ChatMessageEntity>, Exception>> getMessages(
    String conversationId, {
    ChatMessageEntity? before,
    int limit = 50,
  });
  Future<Result<ChatMessageEntity, Exception>> sendMessage({
    required String conversationId,
    required String content,
  });
  Future<Result<void, Exception>> markAsRead(String conversationId);
  Stream<ChatMessageEntity> streamMessages(String conversationId);
  Stream<ChatMessageEntity> streamUserMessages();
}
