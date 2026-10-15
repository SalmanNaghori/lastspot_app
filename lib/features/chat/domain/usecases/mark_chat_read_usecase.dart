import '../../../../core/utils/result.dart';
import '../repositories/chat_repository.dart';

class MarkChatReadUseCase {
  final ChatRepository _repository;

  MarkChatReadUseCase(this._repository);

  Future<Result<void, Exception>> call(String conversationId) {
    return _repository.markAsRead(conversationId);
  }
}
