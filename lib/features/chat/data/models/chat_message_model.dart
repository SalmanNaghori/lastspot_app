import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/chat_message_entity.dart';

part 'chat_message_model.freezed.dart';
part 'chat_message_model.g.dart';

@Freezed(fromJson: false, toJson: true)
abstract class ChatMessageModel
    with _$ChatMessageModel
    implements ChatMessageEntity {
  const factory ChatMessageModel({
    required String id,
    @JsonKey(name: 'conversation_id') required String conversationId,
    @JsonKey(name: 'sender_id') required String senderId,
    @JsonKey(includeToJson: false) String? senderName,
    required String content,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'deleted_at', includeIfNull: false) DateTime? deletedAt,
  }) = _ChatMessageModel;

  factory ChatMessageModel.fromJson(
    Map<String, dynamic> json, {
    String? senderName,
  }) {
    return ChatMessageModel(
      id: json['id']?.toString() ?? '',
      conversationId: json['conversation_id']?.toString() ?? '',
      senderId: json['sender_id']?.toString() ?? '',
      senderName: senderName ?? json['sender_name']?.toString(),
      content: json['content']?.toString() ?? '',
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.tryParse(json['deleted_at'].toString()),
    );
  }
}
