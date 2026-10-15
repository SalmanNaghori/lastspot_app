import '../../../../core/utils/result.dart';
import '../entities/chat_message_entity.dart';
import '../repositories/chat_repository.dart';

class GetChatMessagesUseCase {
  final ChatRepository _repository;

  GetChatMessagesUseCase(this._repository);

  Future<Result<List<ChatMessageEntity>, Exception>> call(
    String conversationId, {
    ChatMessageEntity? before,
    int limit = 50,
  }) {
    return _repository.getMessages(
      conversationId,
      before: before,
      limit: limit,
    );
  }
}
