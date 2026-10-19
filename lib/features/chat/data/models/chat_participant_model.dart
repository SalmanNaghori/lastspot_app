import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_participant_model.freezed.dart';
part 'chat_participant_model.g.dart';

@freezed
abstract class ChatParticipantModel with _$ChatParticipantModel {
  const factory ChatParticipantModel({
    required String id,
    @JsonKey(name: 'conversation_id') required String conversationId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'joined_at') DateTime? joinedAt,
    @JsonKey(name: 'user_name') String? userName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
  }) = _ChatParticipantModel;

  factory ChatParticipantModel.fromJson(Map<String, dynamic> json) =>
      _$ChatParticipantModelFromJson(_normalizeParticipantJson(json));
}

Map<String, dynamic> _normalizeParticipantJson(Map<String, dynamic> json) {
  final copy = Map<String, dynamic>.from(json);
  copy['id'] = json['id']?.toString() ?? '';
  copy['conversation_id'] =
      (json['conversation_id'] ?? json['conversationId'])?.toString() ?? '';
  copy['user_id'] = (json['user_id'] ?? json['userId'])?.toString() ?? '';
  copy['user_name'] =
      (json['user_name'] ?? json['userName'] ?? json['full_name'])?.toString();
  copy['avatar_url'] = (json['avatar_url'] ?? json['avatarUrl'])?.toString();
  return copy;
}
