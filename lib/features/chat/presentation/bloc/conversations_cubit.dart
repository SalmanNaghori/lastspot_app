import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/network_exceptions.dart';
import '../../../../core/services/chat_visibility_tracker.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/chat_conversation_entity.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/usecases/get_my_conversations_usecase.dart';
import '../../domain/usecases/stream_user_messages_usecase.dart';
import 'conversations_state.dart';

class ConversationsCubit extends Cubit<ConversationsState> {
  final GetMyConversationsUseCase _getMyConversationsUseCase;
  final StreamUserMessagesUseCase? _streamUserMessagesUseCase;
  final ChatVisibilityTracker? _visibilityTracker;
  final String? _currentUserId;

  StreamSubscription<ChatMessageEntity>? _messagesSubscription;

  ConversationsCubit({
    required GetMyConversationsUseCase getMyConversationsUseCase,
    StreamUserMessagesUseCase? streamUserMessagesUseCase,
    ChatVisibilityTracker? visibilityTracker,
    String? currentUserId,
  }) : _getMyConversationsUseCase = getMyConversationsUseCase,
       _streamUserMessagesUseCase = streamUserMessagesUseCase,
       _visibilityTracker = visibilityTracker,
       _currentUserId = currentUserId,
       super(const ConversationsInitial());

  Future<void> loadConversations({bool isRefresh = false}) async {
    if (isClosed) return;
    _startMessageSubscription();

    if (state is ConversationsLoaded && isRefresh) {
      emit((state as ConversationsLoaded).copyWith(isRefreshing: true));
    } else {
      emit(const ConversationsLoading());
    }

    final result = await _getMyConversationsUseCase();
    if (isClosed) return;
    switch (result) {
      case Success(value: final conversations):
        emit(
          ConversationsLoaded(
            conversations: _orderedConversations(conversations),
          ),
        );
      case Failure(exception: final ex):
        emit(
          ConversationsError(
            message: ex.toString(),
            isNetworkError: ex is NoInternetException,
          ),
        );
    }
  }

  List<ChatConversationEntity> _orderedConversations(
    List<ChatConversationEntity> conversations,
  ) {
    final ordered = List<ChatConversationEntity>.of(conversations)
      ..sort((a, b) {
        final aTime = a.lastMessageAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bTime = b.lastMessageAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bTime.compareTo(aTime);
      });
    final seen = <String>{};
    return List.unmodifiable(
      ordered.where((conversation) => seen.add(conversation.conversationId)),
    );
  }

  void _startMessageSubscription() {
    if (_streamUserMessagesUseCase == null || _messagesSubscription != null) {
      return;
    }
    _messagesSubscription = _streamUserMessagesUseCase.call().listen(
      _onIncomingMessage,
      onError: (_) {
        // Stream will be re-attempted on subsequent refresh if needed.
      },
    );
  }

  @visibleForTesting
  void onIncomingMessageForTesting(ChatMessageEntity message) =>
      _onIncomingMessage(message);

  void _onIncomingMessage(ChatMessageEntity message) {
    if (state is! ConversationsLoaded) {
      loadConversations(isRefresh: true);
      return;
    }

    final currentState = state as ConversationsLoaded;
    final currentList = currentState.conversations;

    final matchingIndex = currentList.indexWhere(
      (c) => c.conversationId == message.conversationId,
    );

    if (matchingIndex == -1) {
      // New conversation created or discovered; load fresh list
      loadConversations(isRefresh: true);
      return;
    }

    final existing = currentList[matchingIndex];
    final isVisible =
        _visibilityTracker?.isConversationCurrentlyVisible(
          message.conversationId,
        ) ??
        false;
    final isMine = _currentUserId != null && message.senderId == _currentUserId;

    final updated = existing.copyWith(
      lastMessage: message.content,
      lastMessageAt: message.createdAt,
      unreadCount: (isVisible || isMine)
          ? existing.unreadCount
          : (existing.unreadCount + 1),
    );

    final newList = List<ChatConversationEntity>.from(currentList);
    newList.removeAt(matchingIndex);
    newList.insert(0, updated);

    emit(currentState.copyWith(conversations: _orderedConversations(newList)));
  }

  void markConversationReadLocally(String conversationId) {
    if (state is! ConversationsLoaded) return;
    final currentState = state as ConversationsLoaded;
    final list = currentState.conversations;
    final index = list.indexWhere((c) => c.conversationId == conversationId);
    if (index == -1) return;

    if (list[index].unreadCount == 0) return;

    final updated = list[index].copyWith(unreadCount: 0);
    final newList = List<ChatConversationEntity>.from(list);
    newList[index] = updated;

    emit(currentState.copyWith(conversations: List.unmodifiable(newList)));
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    _messagesSubscription = null;
    return super.close();
  }
}
