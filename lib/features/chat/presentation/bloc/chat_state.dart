import '../../domain/entities/chat_message_entity.dart';

sealed class ChatState {
  const ChatState();
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatLoading extends ChatState {
  final String? message;
  const ChatLoading({this.message});
}

class ChatLoaded extends ChatState {
  final String conversationId;
  final String? requestId;
  final List<ChatMessageEntity> messages;
  final String title;
  final String? subtitle;
  final bool isDirect;
  final bool isSending;
  final bool hasOlderMessages;
  final bool isLoadingOlder;

  const ChatLoaded({
    required this.conversationId,
    this.requestId,
    required this.messages,
    required this.title,
    this.subtitle,
    required this.isDirect,
    this.isSending = false,
    this.hasOlderMessages = false,
    this.isLoadingOlder = false,
  });

  ChatLoaded copyWith({
    String? conversationId,
    String? requestId,
    List<ChatMessageEntity>? messages,
    String? title,
    String? subtitle,
    bool? isDirect,
    bool? isSending,
    bool? hasOlderMessages,
    bool? isLoadingOlder,
  }) {
    return ChatLoaded(
      conversationId: conversationId ?? this.conversationId,
      requestId: requestId ?? this.requestId,
      messages: messages ?? this.messages,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      isDirect: isDirect ?? this.isDirect,
      isSending: isSending ?? this.isSending,
      hasOlderMessages: hasOlderMessages ?? this.hasOlderMessages,
      isLoadingOlder: isLoadingOlder ?? this.isLoadingOlder,
    );
  }
}

class ChatError extends ChatState {
  final String message;
  final bool isNetworkError;

  const ChatError({required this.message, this.isNetworkError = false});
}
