import '../../../../core/utils/result.dart';
import '../entities/chat_conversation_entity.dart';
import '../repositories/chat_repository.dart';

class GetMyConversationsUseCase {
  final ChatRepository _repository;

  GetMyConversationsUseCase(this._repository);

  Future<Result<List<ChatConversationEntity>, Exception>> call() {
    return _repository.getMyConversations();
  }
}
