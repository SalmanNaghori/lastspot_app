import 'package:flutter_test/flutter_test.dart';
import 'package:lastspot_app/core/network/network_exceptions.dart';
import 'package:lastspot_app/core/utils/result.dart';
import 'package:lastspot_app/features/chat/domain/entities/chat_conversation_entity.dart';
import 'package:lastspot_app/features/chat/domain/usecases/get_my_conversations_usecase.dart';
import 'package:lastspot_app/features/chat/presentation/bloc/conversations_cubit.dart';
import 'package:lastspot_app/features/chat/presentation/bloc/conversations_state.dart';

class FakeGetMyConversationsUseCase extends Fake
    implements GetMyConversationsUseCase {
  Result<List<ChatConversationEntity>, Exception> result = const Success([]);
  int callCount = 0;

  @override
  Future<Result<List<ChatConversationEntity>, Exception>> call() async {
    callCount++;
    return result;
  }
}

void main() {
  late FakeGetMyConversationsUseCase fakeUseCase;
  late ConversationsCubit cubit;

  setUp(() {
    fakeUseCase = FakeGetMyConversationsUseCase();
    cubit = ConversationsCubit(getMyConversationsUseCase: fakeUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('ConversationsCubit', () {
    test('initial state is ConversationsInitial', () {
      expect(cubit.state, isA<ConversationsInitial>());
    });

    test('loads conversations and emits ConversationsLoaded', () async {
      final conversations = [
        ChatConversationEntity(
          conversationId: 'conv-1',
          requestId: 'req-1',
          chatType: 'direct',
          otherUserName: 'Alex',
          lastMessage: 'See you there',
          unreadCount: 1,
        ),
      ];
      fakeUseCase.result = Success(conversations);

      await cubit.loadConversations();

      expect(fakeUseCase.callCount, 1);
      expect(cubit.state, isA<ConversationsLoaded>());
      final state = cubit.state as ConversationsLoaded;
      expect(state.conversations.length, 1);
      expect(state.conversations.first.otherUserName, 'Alex');
      expect(state.isRefreshing, isFalse);
    });

    test('handles empty conversations list cleanly', () async {
      fakeUseCase.result = const Success([]);

      await cubit.loadConversations();

      expect(cubit.state, isA<ConversationsLoaded>());
      final state = cubit.state as ConversationsLoaded;
      expect(state.conversations, isEmpty);
    });

    test('handles refresh without flashing loading indicator', () async {
      fakeUseCase.result = const Success([]);
      await cubit.loadConversations();

      final states = <ConversationsState>[];
      final sub = cubit.stream.listen(states.add);

      await cubit.loadConversations(isRefresh: true);
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();

      expect(states.length, 2);
      expect(states[0], isA<ConversationsLoaded>());
      expect((states[0] as ConversationsLoaded).isRefreshing, isTrue);
      expect(states[1], isA<ConversationsLoaded>());
      expect((states[1] as ConversationsLoaded).isRefreshing, isFalse);
    });

    test('emits ConversationsError on failure with network check', () async {
      fakeUseCase.result = Failure(NoInternetException());

      await cubit.loadConversations();

      expect(cubit.state, isA<ConversationsError>());
      final state = cubit.state as ConversationsError;
      expect(state.isNetworkError, isTrue);
    });
  });
}
