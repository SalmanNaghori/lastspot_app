// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_conversation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatConversationModel _$ChatConversationModelFromJson(
  Map<String, dynamic> json,
) => _ChatConversationModel(
  conversationId: _readConversationId(json, 'conversation_id') as String,
  requestId: _stringFromJson(json['request_id']),
  activityTitle: _nullableStringFromJson(
    _readActivityTitle(json, 'activity_title'),
  ),
  chatType: _chatTypeFromJson(json['chat_type']),
  otherUserId: _nullableStringFromJson(json['other_user_id']),
  otherUserName: _nullableStringFromJson(json['other_user_name']),
  otherUserAvatarUrl: _nullableStringFromJson(
    _readAvatarUrl(json, 'other_user_avatar_url'),
  ),
  categoryId: _nullableStringFromJson(json['category_id']),
  categorySlug: _nullableStringFromJson(json['category_slug']),
  groupAvatarUrl: _nullableStringFromJson(json['group_avatar_url']),
  lastMessage: _nullableStringFromJson(json['last_message']),
  lastMessageAt: _dateTimeFromJson(json['last_message_at']),
  unreadCount: json['unread_count'] == null
      ? 0
      : _intFromJson(json['unread_count']),
);

Map<String, dynamic> _$ChatConversationModelToJson(
  _ChatConversationModel instance,
) => <String, dynamic>{
  'conversation_id': instance.conversationId,
  'request_id': instance.requestId,
  'activity_title': instance.activityTitle,
  'chat_type': instance.chatType,
  'other_user_id': instance.otherUserId,
  'other_user_name': instance.otherUserName,
  'other_user_avatar_url': instance.otherUserAvatarUrl,
  'category_id': instance.categoryId,
  'category_slug': instance.categorySlug,
  'group_avatar_url': instance.groupAvatarUrl,
  'last_message': instance.lastMessage,
  'last_message_at': instance.lastMessageAt?.toIso8601String(),
  'unread_count': instance.unreadCount,
};
