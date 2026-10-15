import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/network_exceptions.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/usecases/get_chat_messages_usecase.dart';
import '../../domain/usecases/get_or_create_direct_chat_usecase.dart';
import '../../domain/usecases/get_or_create_group_chat_usecase.dart';
import '../../domain/usecases/mark_chat_read_usecase.dart';
import '../../domain/usecases/send_chat_message_usecase.dart';
import '../../domain/usecases/stream_chat_messages_usecase.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  static const int _messagePageSize = 50;

  final GetOrCreateDirectChatUseCase _getOrCreateDirectChatUseCase;
  final GetOrCreateGroupChatUseCase _getOrCreateGroupChatUseCase;
  final GetChatMessagesUseCase _getChatMessagesUseCase;
  final SendChatMessageUseCase _sendChatMessageUseCase;
  final MarkChatReadUseCase _markChatReadUseCase;
  final StreamChatMessagesUseCase _streamChatMessagesUseCase;

  StreamSubscription<ChatMessageEntity>? _messagesSubscription;

  String? _conversationId;
  String? _requestId;
  bool _isDirect = false;
  String? _recipientName;
  String? _activityTitle;

  ChatCubit({
    required GetOrCreateDirectChatUseCase getOrCreateDirectChatUseCase,
    required GetOrCreateGroupChatUseCase getOrCreateGroupChatUseCase,
    required GetChatMessagesUseCase getChatMessagesUseCase,
    required SendChatMessageUseCase sendChatMessageUseCase,
    required MarkChatReadUseCase markChatReadUseCase,
    required StreamChatMessagesUseCase streamChatMessagesUseCase,
  }) : _getOrCreateDirectChatUseCase = getOrCreateDirectChatUseCase,
       _getOrCreateGroupChatUseCase = getOrCreateGroupChatUseCase,
       _getChatMessagesUseCase = getChatMessagesUseCase,
       _sendChatMessageUseCase = sendChatMessageUseCase,
       _markChatReadUseCase = markChatReadUseCase,
       _streamChatMessagesUseCase = streamChatMessagesUseCase,
       super(const ChatInitial());

  Future<void> initialize({
    String? conversationId,
    String? requestId,
    bool isDirect = false,
    String? recipientName,
    String? activityTitle,
  }) async {
    if (isClosed) return;
    await _messagesSubscription?.cancel();
    if (isClosed) return;
    _conversationId = conversationId;
    _requestId = requestId;
    _isDirect = isDirect;
    _recipientName = recipientName;
    _activityTitle = activityTitle;

    emit(const ChatLoading());

    // 1. Resolve conversationId if not provided
    if (_conversationId == null || _conversationId!.isEmpty) {
      if (_requestId == null || _requestId!.isEmpty) {
        emit(
          const ChatError(
            message: 'Missing conversation or activity identifier',
          ),
        );
        return;
      }

      final Result<String, Exception> idResult;
      if (_isDirect) {
        idResult = await _getOrCreateDirectChatUseCase(_requestId!);
      } else {
        idResult = await _getOrCreateGroupChatUseCase(_requestId!);
      }
      if (isClosed) return;

      switch (idResult) {
        case Success(value: final id):
          _conversationId = id;
        case Failure(exception: final ex):
          emit(
            ChatError(
              message: ex.toString(),
              isNetworkError: ex is NoInternetException,
            ),
          );
          return;
      }
    }

    final resolvedConversationId = _conversationId!;

    // 2. Mark chat as read
    unawaited(_markChatReadUseCase(resolvedConversationId));

    // 3. Load initial messages
    final messagesResult = await _getChatMessagesUseCase(
      resolvedConversationId,
      limit: _messagePageSize,
    );
    if (isClosed) return;
    switch (messagesResult) {
      case Success(value: final messages):
        final title = _isDirect
            ? (_recipientName?.trim().isNotEmpty == true
                  ? _recipientName!.trim()
                  : 'Direct Message')
            : (_activityTitle?.trim().isNotEmpty == true
                  ? _activityTitle!.trim()
                  : 'Group Chat');

        final subtitle = _isDirect
            ? (_activityTitle?.trim().isNotEmpty == true
                  ? _activityTitle!.trim()
                  : null)
            : 'Match Group Chat';

        emit(
          ChatLoaded(
            conversationId: resolvedConversationId,
            requestId: _requestId,
            messages: _visiblePage(messages),
            title: title,
            subtitle: subtitle,
            isDirect: _isDirect,
            hasOlderMessages: messages.length > _messagePageSize,
          ),
        );

        // 4. Subscribe to realtime updates
        _subscribeToRealtime(resolvedConversationId);

      case Failure(exception: final ex):
        emit(
          ChatError(
            message: ex.toString(),
            isNetworkError: ex is NoInternetException,
          ),
        );
    }
  }

  void _subscribeToRealtime(String conversationId) {
    _messagesSubscription?.cancel();
    _messagesSubscription = _streamChatMessagesUseCase(conversationId).listen(
      (newMessage) {
        if (!isClosed && state is ChatLoaded) {
          final current = state as ChatLoaded;
          // Deduplicate message
          if (!current.messages.any((m) => m.id == newMessage.id)) {
            final updated = List<ChatMessageEntity>.from(current.messages)
              ..add(newMessage);
            emit(current.copyWith(messages: updated));
            unawaited(_markChatReadUseCase(conversationId));
          }
        }
      },
      onError: (_) {
        // Realtime errors don't replace the loaded message view
      },
    );
  }

  Future<bool> sendMessage(String text) async {
    if (text.trim().isEmpty || state is! ChatLoaded) return false;

    final current = state as ChatLoaded;
    if (current.isSending) return false;
    emit(current.copyWith(isSending: true));

    final result = await _sendChatMessageUseCase(
      conversationId: current.conversationId,
      content: text,
    );
    if (isClosed) return false;

    switch (result) {
      case Success(value: final message):
        if (state is ChatLoaded) {
          final loadedState = state as ChatLoaded;
          if (!loadedState.messages.any((m) => m.id == message.id)) {
            final updated = List<ChatMessageEntity>.from(loadedState.messages)
              ..add(message);
            emit(loadedState.copyWith(messages: updated, isSending: false));
          } else {
            emit(loadedState.copyWith(isSending: false));
          }
        }
        return true;
      case Failure():
        if (state is ChatLoaded) {
          emit((state as ChatLoaded).copyWith(isSending: false));
        }
        return false;
    }
  }

  Future<void> refreshMessages() async {
    final convId = _conversationId;
    if (convId == null) return;

    final messagesResult = await _getChatMessagesUseCase(
      convId,
      limit: _messagePageSize,
    );
    if (isClosed) return;
    if (messagesResult is Success<List<ChatMessageEntity>, Exception>) {
      final page = messagesResult.value;
      final freshMessages = _visiblePage(page);
      if (state is ChatLoaded) {
        final current = state as ChatLoaded;
        final map = <String, ChatMessageEntity>{};
        for (final m in current.messages) {
          map[m.id] = m;
        }
        for (final m in freshMessages) {
          map[m.id] = m;
        }
        final merged = map.values.toList()..sort(_compareMessages);
        emit(
          current.copyWith(
            messages: merged,
            hasOlderMessages:
                current.hasOlderMessages || page.length > _messagePageSize,
          ),
        );
      }
    }
  }

  Future<void> loadOlderMessages() async {
    if (state is! ChatLoaded) return;
    final current = state as ChatLoaded;
    if (!current.hasOlderMessages || current.isLoadingOlder) return;

    emit(current.copyWith(isLoadingOlder: true));
    final result = await _getChatMessagesUseCase(
      current.conversationId,
      before: current.messages.first,
      limit: _messagePageSize,
    );
    if (isClosed) return;

    if (result case Success(value: final page)) {
      final olderMessages = _visiblePage(page);
      final messages = <String, ChatMessageEntity>{
        for (final message in current.messages) message.id: message,
        for (final message in olderMessages) message.id: message,
      }.values.toList()..sort(_compareMessages);
      emit(
        current.copyWith(
          messages: messages,
          hasOlderMessages: page.length > _messagePageSize,
          isLoadingOlder: false,
        ),
      );
    } else if (state is ChatLoaded) {
      emit((state as ChatLoaded).copyWith(isLoadingOlder: false));
    }
  }

  List<ChatMessageEntity> _visiblePage(List<ChatMessageEntity> page) {
    if (page.length <= _messagePageSize) return page;
    return page.sublist(page.length - _messagePageSize);
  }

  int _compareMessages(ChatMessageEntity a, ChatMessageEntity b) {
    final byTimestamp = a.createdAt.compareTo(b.createdAt);
    return byTimestamp != 0 ? byTimestamp : a.id.compareTo(b.id);
  }

  void retry() {
    initialize(
      conversationId: _conversationId,
      requestId: _requestId,
      isDirect: _isDirect,
      recipientName: _recipientName,
      activityTitle: _activityTitle,
    );
  }

  @override
  Future<void> close() async {
    await _messagesSubscription?.cancel();
    return super.close();
  }
}
