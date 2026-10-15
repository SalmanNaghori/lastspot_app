import '../../../../core/utils/result.dart';
import '../repositories/chat_repository.dart';

class GetOrCreateGroupChatUseCase {
  final ChatRepository _repository;

  GetOrCreateGroupChatUseCase(this._repository);

  Future<Result<String, Exception>> call(String requestId) {
    return _repository.getOrCreateGroupChat(requestId);
  }
}
