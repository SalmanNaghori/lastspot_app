import '../../../../core/network/base/base_repository.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/chat_conversation_entity.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl extends BaseRepository implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;

  ChatRepositoryImpl({required ChatRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<Result<String, Exception>> getOrCreateDirectChat(String requestId) {
    return executeApi<String>(
      operationName: 'chat.getOrCreateDirectChat',
      requestData: {'request_id': requestId},
      operation: () => _remoteDataSource.getOrCreateDirectChat(requestId),
    );
  }

  @override
  Future<Result<String, Exception>> getOrCreateGroupChat(String requestId) {
    return executeApi<String>(
      operationName: 'chat.getOrCreateGroupChat',
      requestData: {'request_id': requestId},
      operation: () => _remoteDataSource.getOrCreateGroupChat(requestId),
    );
  }

  @override
  Future<Result<List<ChatConversationEntity>, Exception>> getMyConversations() {
    return executeApi<List<ChatConversationEntity>>(
      operationName: 'chat.getMyConversations',
      operation: () => _remoteDataSource.getMyConversations(),
    );
  }

  @override
  Future<Result<List<ChatMessageEntity>, Exception>> getMessages(
    String conversationId, {
    ChatMessageEntity? before,
    int limit = 50,
  }) {
    return executeApi<List<ChatMessageEntity>>(
      operationName: 'chat.getMessages',
      requestData: {'conversation_id': conversationId},
      operation: () => _remoteDataSource.getMessages(
        conversationId,
        before: before,
        limit: limit,
      ),
    );
  }

  @override
  Future<Result<ChatMessageEntity, Exception>> sendMessage({
    required String conversationId,
    required String content,
  }) {
    return executeApi<ChatMessageEntity>(
      operationName: 'chat.sendMessage',
      requestData: {
        'conversation_id': conversationId,
        'content_length': content.length,
      },
      operation: () => _remoteDataSource.sendMessage(
        conversationId: conversationId,
        content: content,
      ),
    );
  }

  @override
  Future<Result<void, Exception>> markAsRead(String conversationId) {
    return executeApi<void>(
      operationName: 'chat.markAsRead',
      requestData: {'conversation_id': conversationId},
      operation: () => _remoteDataSource.markAsRead(conversationId),
    );
  }

  @override
  Stream<ChatMessageEntity> streamMessages(String conversationId) {
    return _remoteDataSource.streamMessages(conversationId);
  }
}
