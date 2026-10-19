// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_participant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatParticipantModel _$ChatParticipantModelFromJson(
  Map<String, dynamic> json,
) => _ChatParticipantModel(
  id: json['id'] as String,
  conversationId: json['conversation_id'] as String,
  userId: json['user_id'] as String,
  joinedAt: json['joined_at'] == null
      ? null
      : DateTime.parse(json['joined_at'] as String),
  userName: json['user_name'] as String?,
  avatarUrl: json['avatar_url'] as String?,
);

Map<String, dynamic> _$ChatParticipantModelToJson(
  _ChatParticipantModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'conversation_id': instance.conversationId,
  'user_id': instance.userId,
  'joined_at': instance.joinedAt?.toIso8601String(),
  'user_name': instance.userName,
  'avatar_url': instance.avatarUrl,
};
