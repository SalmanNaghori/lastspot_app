import '../../../../core/utils/result.dart';
import '../entities/chat_message_entity.dart';
import '../repositories/chat_repository.dart';

class SendChatMessageUseCase {
  final ChatRepository _repository;

  SendChatMessageUseCase(this._repository);

  Future<Result<ChatMessageEntity, Exception>> call({
    required String conversationId,
    required String content,
  }) {
    return _repository.sendMessage(
      conversationId: conversationId,
      content: content,
    );
  }
}
