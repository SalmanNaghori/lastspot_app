import '../entities/chat_message_entity.dart';
import '../repositories/chat_repository.dart';

class StreamUserMessagesUseCase {
  final ChatRepository _repository;

  StreamUserMessagesUseCase(this._repository);

  Stream<ChatMessageEntity> call() {
    return _repository.streamUserMessages();
  }
}
