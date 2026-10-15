import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/chat_conversation_entity.dart';

part 'chat_conversation_model.freezed.dart';
part 'chat_conversation_model.g.dart';

@freezed
abstract class ChatConversationModel
    with _$ChatConversationModel
    implements ChatConversationEntity {
  const ChatConversationModel._();

  const factory ChatConversationModel({
    @JsonKey(name: 'conversation_id', readValue: _readConversationId)
    required String conversationId,
    @JsonKey(name: 'request_id', fromJson: _stringFromJson)
    required String requestId,
    @JsonKey(name: 'activity_title', fromJson: _nullableStringFromJson)
    String? activityTitle,
    @JsonKey(name: 'chat_type', fromJson: _chatTypeFromJson)
    required String chatType,
    @JsonKey(name: 'other_user_id', fromJson: _nullableStringFromJson)
    String? otherUserId,
    @JsonKey(name: 'other_user_name', fromJson: _nullableStringFromJson)
    String? otherUserName,
    @JsonKey(name: 'last_message', fromJson: _nullableStringFromJson)
    String? lastMessage,
    @JsonKey(name: 'last_message_at', fromJson: _dateTimeFromJson)
    DateTime? lastMessageAt,
    @JsonKey(name: 'unread_count', fromJson: _intFromJson)
    @Default(0)
    int unreadCount,
  }) = _ChatConversationModel;

  factory ChatConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ChatConversationModelFromJson(json);

  @override
  bool get isDirect => chatType == 'direct';
}

Object? _readConversationId(Map json, String key) =>
    (json['conversation_id'] ?? json['id'])?.toString() ?? '';

String _stringFromJson(Object? value) => value?.toString() ?? '';

String? _nullableStringFromJson(Object? value) => value?.toString();

String _chatTypeFromJson(Object? value) => value?.toString() ?? 'group';

DateTime? _dateTimeFromJson(Object? value) =>
    value == null ? null : DateTime.tryParse(value.toString());

int _intFromJson(Object? value) => int.tryParse(value?.toString() ?? '') ?? 0;
