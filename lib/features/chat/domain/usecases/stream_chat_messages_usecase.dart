import '../entities/chat_message_entity.dart';
import '../repositories/chat_repository.dart';

class StreamChatMessagesUseCase {
  final ChatRepository _repository;

  StreamChatMessagesUseCase(this._repository);

  Stream<ChatMessageEntity> call(String conversationId) {
    return _repository.streamMessages(conversationId);
  }
}
