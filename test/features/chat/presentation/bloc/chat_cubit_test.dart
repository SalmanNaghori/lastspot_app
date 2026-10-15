import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:lastspot_app/core/network/network_exceptions.dart';
import 'package:lastspot_app/core/utils/result.dart';
import 'package:lastspot_app/features/chat/domain/entities/chat_message_entity.dart';
import 'package:lastspot_app/features/chat/domain/usecases/get_chat_messages_usecase.dart';
import 'package:lastspot_app/features/chat/domain/usecases/get_or_create_direct_chat_usecase.dart';
import 'package:lastspot_app/features/chat/domain/usecases/get_or_create_group_chat_usecase.dart';
import 'package:lastspot_app/features/chat/domain/usecases/mark_chat_read_usecase.dart';
import 'package:lastspot_app/features/chat/domain/usecases/send_chat_message_usecase.dart';
import 'package:lastspot_app/features/chat/domain/usecases/stream_chat_messages_usecase.dart';
import 'package:lastspot_app/features/chat/presentation/bloc/chat_cubit.dart';
import 'package:lastspot_app/features/chat/presentation/bloc/chat_state.dart';

class FakeGetOrCreateDirectChatUseCase extends Fake
    implements GetOrCreateDirectChatUseCase {
  Result<String, Exception> result = const Success('direct-conv-uuid');
  int callCount = 0;
  String? lastRequestId;

  @override
  Future<Result<String, Exception>> call(String requestId) async {
    callCount++;
    lastRequestId = requestId;
    return result;
  }
}

class FakeGetOrCreateGroupChatUseCase extends Fake
    implements GetOrCreateGroupChatUseCase {
  Result<String, Exception> result = const Success('group-conv-uuid');
  int callCount = 0;
  String? lastRequestId;

  @override
  Future<Result<String, Exception>> call(String requestId) async {
    callCount++;
    lastRequestId = requestId;
    return result;
  }
}

class FakeGetChatMessagesUseCase extends Fake
    implements GetChatMessagesUseCase {
  Result<List<ChatMessageEntity>, Exception> result = const Success([]);
  int callCount = 0;
  String? lastConversationId;

  @override
  Future<Result<List<ChatMessageEntity>, Exception>> call(
    String conversationId,
  ) async {
    callCount++;
    lastConversationId = conversationId;
    return result;
  }
}

class FakeSendChatMessageUseCase extends Fake
    implements SendChatMessageUseCase {
  Result<ChatMessageEntity, Exception>? result;
  int callCount = 0;
  String? lastContent;

  @override
  Future<Result<ChatMessageEntity, Exception>> call({
    required String conversationId,
    required String content,
  }) async {
    callCount++;
    lastContent = content;
    return result ??
        Success(
          ChatMessageEntity(
            id: 'sent-msg-1',
            conversationId: conversationId,
            senderId: 'user-me',
            content: content,
            createdAt: DateTime.now(),
          ),
        );
  }
}

class FakeMarkChatReadUseCase extends Fake implements MarkChatReadUseCase {
  int callCount = 0;
  String? lastConversationId;

  @override
  Future<Result<void, Exception>> call(String conversationId) async {
    callCount++;
    lastConversationId = conversationId;
    return const Success(null);
  }
}

class FakeStreamChatMessagesUseCase extends Fake
    implements StreamChatMessagesUseCase {
  final _controller = StreamController<ChatMessageEntity>.broadcast();
  int callCount = 0;

  @override
  Stream<ChatMessageEntity> call(String conversationId) {
    callCount++;
    return _controller.stream;
  }

  void emitMessage(ChatMessageEntity message) {
    _controller.add(message);
  }

  void close() {
    _controller.close();
  }
}

void main() {
  late FakeGetOrCreateDirectChatUseCase fakeDirectChat;
  late FakeGetOrCreateGroupChatUseCase fakeGroupChat;
  late FakeGetChatMessagesUseCase fakeGetMessages;
  late FakeSendChatMessageUseCase fakeSendMessage;
  late FakeMarkChatReadUseCase fakeMarkRead;
  late FakeStreamChatMessagesUseCase fakeStreamMessages;
  late ChatCubit cubit;

  setUp(() {
    fakeDirectChat = FakeGetOrCreateDirectChatUseCase();
    fakeGroupChat = FakeGetOrCreateGroupChatUseCase();
    fakeGetMessages = FakeGetChatMessagesUseCase();
    fakeSendMessage = FakeSendChatMessageUseCase();
    fakeMarkRead = FakeMarkChatReadUseCase();
    fakeStreamMessages = FakeStreamChatMessagesUseCase();

    cubit = ChatCubit(
      getOrCreateDirectChatUseCase: fakeDirectChat,
      getOrCreateGroupChatUseCase: fakeGroupChat,
      getChatMessagesUseCase: fakeGetMessages,
      sendChatMessageUseCase: fakeSendMessage,
      markChatReadUseCase: fakeMarkRead,
      streamChatMessagesUseCase: fakeStreamMessages,
    );
  });

  tearDown(() {
    fakeStreamMessages.close();
    cubit.close();
  });

  group('ChatCubit', () {
    test('initial state is ChatInitial', () {
      expect(cubit.state, isA<ChatInitial>());
    });

    test(
      'opens direct chat for the first time via get_or_create_direct_chat',
      () async {
        final initialMsg = ChatMessageEntity(
          id: 'msg-1',
          conversationId: 'direct-conv-uuid',
          senderId: 'user-other',
          content: 'Hello there!',
          createdAt: DateTime.parse('2026-10-13T10:00:00Z'),
        );
        fakeGetMessages.result = Success([initialMsg]);

        await cubit.initialize(
          requestId: 'request-123',
          isDirect: true,
          recipientName: 'Alice',
        );

        expect(fakeDirectChat.callCount, 1);
        expect(fakeDirectChat.lastRequestId, 'request-123');
        expect(fakeGroupChat.callCount, 0);
        expect(fakeGetMessages.callCount, 1);
        expect(fakeGetMessages.lastConversationId, 'direct-conv-uuid');
        expect(fakeMarkRead.callCount, 1);
        expect(fakeStreamMessages.callCount, 1);

        expect(cubit.state, isA<ChatLoaded>());
        final state = cubit.state as ChatLoaded;
        expect(state.conversationId, 'direct-conv-uuid');
        expect(state.title, 'Alice');
        expect(state.isDirect, isTrue);
        expect(state.messages.length, 1);
        expect(state.messages.first.content, 'Hello there!');
      },
    );

    test(
      'reopens conversation by ID without calling get_or_create RPC',
      () async {
        await cubit.initialize(
          conversationId: 'existing-conv-777',
          isDirect: true,
          recipientName: 'Bob',
        );

        expect(fakeDirectChat.callCount, 0);
        expect(fakeGroupChat.callCount, 0);
        expect(fakeGetMessages.callCount, 1);
        expect(fakeGetMessages.lastConversationId, 'existing-conv-777');
        expect(fakeMarkRead.callCount, 1);

        expect(cubit.state, isA<ChatLoaded>());
        final state = cubit.state as ChatLoaded;
        expect(state.conversationId, 'existing-conv-777');
        expect(state.title, 'Bob');
      },
    );

    test('opens group chat via get_or_create_group_chat', () async {
      await cubit.initialize(
        requestId: 'activity-sport-99',
        isDirect: false,
        activityTitle: 'Badminton Doubles',
      );

      expect(fakeGroupChat.callCount, 1);
      expect(fakeGroupChat.lastRequestId, 'activity-sport-99');
      expect(fakeDirectChat.callCount, 0);
      expect(fakeGetMessages.callCount, 1);

      expect(cubit.state, isA<ChatLoaded>());
      final state = cubit.state as ChatLoaded;
      expect(state.conversationId, 'group-conv-uuid');
      expect(state.title, 'Badminton Doubles');
      expect(state.isDirect, isFalse);
    });

    test('emits ChatError when RPC fails with network exception', () async {
      fakeDirectChat.result = Failure(NoInternetException());

      await cubit.initialize(requestId: 'request-123', isDirect: true);

      expect(cubit.state, isA<ChatError>());
      final state = cubit.state as ChatError;
      expect(state.isNetworkError, isTrue);
    });

    test('sends message and appends to message list', () async {
      await cubit.initialize(
        conversationId: 'conv-active',
        isDirect: true,
        recipientName: 'Carol',
      );

      final success = await cubit.sendMessage('Looking forward to it!');

      expect(success, isTrue);
      expect(fakeSendMessage.callCount, 1);
      expect(fakeSendMessage.lastContent, 'Looking forward to it!');

      final state = cubit.state as ChatLoaded;
      expect(state.messages.length, 1);
      expect(state.messages.last.id, 'sent-msg-1');
      expect(state.messages.last.content, 'Looking forward to it!');
      expect(state.isSending, isFalse);
    });

    test(
      'sendMessage preserves loaded state and returns false on error',
      () async {
        await cubit.initialize(
          conversationId: 'conv-active',
          isDirect: true,
          recipientName: 'Carol',
        );

        fakeSendMessage.result = Failure(NoInternetException());
        final success = await cubit.sendMessage('Failing message');

        expect(success, isFalse);
        expect(cubit.state, isA<ChatLoaded>());
        expect((cubit.state as ChatLoaded).isSending, isFalse);
      },
    );

    test('refreshMessages retrieves and merges messages', () async {
      await cubit.initialize(conversationId: 'conv-active', isDirect: true);

      final newMsg = ChatMessageEntity(
        id: 'msg-reconnect-1',
        conversationId: 'conv-active',
        senderId: 'user-bob',
        content: 'I sent this while you were offline',
        createdAt: DateTime.now(),
      );
      fakeGetMessages.result = Success([newMsg]);

      await cubit.refreshMessages();

      final state = cubit.state as ChatLoaded;
      expect(state.messages.length, 1);
      expect(state.messages.first.id, 'msg-reconnect-1');
    });

    test('ignores empty or whitespace message', () async {
      await cubit.initialize(conversationId: 'conv-active', isDirect: true);

      await cubit.sendMessage('   ');

      expect(fakeSendMessage.callCount, 0);
    });

    test('handles realtime message delivery and avoids duplicates', () async {
      await cubit.initialize(
        conversationId: 'conv-realtime',
        isDirect: true,
        recipientName: 'Dave',
      );

      final msgA = ChatMessageEntity(
        id: 'realtime-1',
        conversationId: 'conv-realtime',
        senderId: 'user-dave',
        content: 'Hey, I arrived at the venue!',
        createdAt: DateTime.now(),
      );

      // Emit new message via realtime stream
      fakeStreamMessages.emitMessage(msgA);
      await Future<void>.delayed(Duration.zero);

      var state = cubit.state as ChatLoaded;
      expect(state.messages.length, 1);
      expect(state.messages.first.id, 'realtime-1');

      // Duplicate delivery of the same message ID
      fakeStreamMessages.emitMessage(msgA);
      await Future<void>.delayed(Duration.zero);

      state = cubit.state as ChatLoaded;
      expect(state.messages.length, 1); // Not duplicated
    });

    test('loads empty chat state cleanly', () async {
      fakeGetMessages.result = const Success([]);

      await cubit.initialize(
        conversationId: 'conv-empty',
        isDirect: false,
        activityTitle: 'Empty Activity',
      );

      expect(cubit.state, isA<ChatLoaded>());
      final state = cubit.state as ChatLoaded;
      expect(state.messages, isEmpty);
    });
  });
}
