import '../../../../core/utils/result.dart';
import '../repositories/chat_repository.dart';

class GetOrCreateDirectChatUseCase {
  final ChatRepository _repository;

  GetOrCreateDirectChatUseCase(this._repository);

  Future<Result<String, Exception>> call(String requestId) {
    return _repository.getOrCreateDirectChat(requestId);
  }
}
