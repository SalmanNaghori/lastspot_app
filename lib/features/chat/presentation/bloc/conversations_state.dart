import '../../domain/entities/chat_conversation_entity.dart';

sealed class ConversationsState {
  const ConversationsState();
}

class ConversationsInitial extends ConversationsState {
  const ConversationsInitial();
}

class ConversationsLoading extends ConversationsState {
  const ConversationsLoading();
}

class ConversationsLoaded extends ConversationsState {
  final List<ChatConversationEntity> conversations;
  final bool isRefreshing;

  const ConversationsLoaded({
    required this.conversations,
    this.isRefreshing = false,
  });

  ConversationsLoaded copyWith({
    List<ChatConversationEntity>? conversations,
    bool? isRefreshing,
  }) {
    return ConversationsLoaded(
      conversations: conversations ?? this.conversations,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

class ConversationsError extends ConversationsState {
  final String message;
  final bool isNetworkError;

  const ConversationsError({
    required this.message,
    this.isNetworkError = false,
  });
}
