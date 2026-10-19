import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/extension/string_extension.dart';
import '../../domain/entities/chat_conversation_entity.dart';

part 'chat_conversation_model.freezed.dart';
part 'chat_conversation_model.g.dart';

@freezed
abstract class ChatConversationModel with _$ChatConversationModel {
  const ChatConversationModel._();

  const factory ChatConversationModel({
    @JsonKey(name: 'conversation_id', readValue: _readConversationId)
    required String conversationId,
    @JsonKey(name: 'request_id', fromJson: _stringFromJson)
    required String requestId,
    @JsonKey(
      name: 'activity_title',
      readValue: _readActivityTitle,
      fromJson: _nullableStringFromJson,
    )
    String? activityTitle,
    @JsonKey(name: 'chat_type', fromJson: _chatTypeFromJson)
    required String chatType,
    @JsonKey(name: 'other_user_id', fromJson: _nullableStringFromJson)
    String? otherUserId,
    @JsonKey(name: 'other_user_name', fromJson: _nullableStringFromJson)
    String? otherUserName,
    @JsonKey(
      name: 'other_user_avatar_url',
      readValue: _readAvatarUrl,
      fromJson: _nullableStringFromJson,
    )
    String? otherUserAvatarUrl,
    @JsonKey(name: 'category_id', fromJson: _nullableStringFromJson)
    String? categoryId,
    @JsonKey(name: 'category_slug', fromJson: _nullableStringFromJson)
    String? categorySlug,
    @JsonKey(name: 'group_avatar_url', fromJson: _nullableStringFromJson)
    String? groupAvatarUrl,
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

  bool get isDirect => chatType == 'direct';

  /// Primary display title: other user's name for direct,
  /// or activity title / category slug for group.
  String? get displayTitle {
    if (isDirect) {
      final name = otherUserName?.trim();
      return name.isNotNullOrEmpty() ? name : null;
    }
    final title = activityTitle?.trim();
    if (title.isNotNullOrEmpty()) return title;
    final slug = categorySlug?.trim();
    return slug.isNotNullOrEmpty() ? slug!.capitalizeFirst() : null;
  }

  /// Related activity title / context for direct chats.
  String? get directActivityTitle {
    if (!isDirect) return null;
    final title = activityTitle?.trim();
    if (title.isNotNullOrEmpty()) return title;
    final slug = categorySlug?.trim();
    if (slug.isNotNullOrEmpty()) return slug!.capitalizeFirst();
    return null;
  }

  /// Resolved avatar URL depending on direct vs group.
  String? get displayAvatarUrl =>
      isDirect ? otherUserAvatarUrl : groupAvatarUrl;

  /// Category slug or identifier for category 3D icon.
  String? get categoryOrActivity {
    if (categorySlug?.trim().isNotNullOrEmpty() == true) {
      return categorySlug!.trim();
    }
    if (categoryId?.trim().isNotNullOrEmpty() == true) {
      return categoryId!.trim();
    }
    if (activityTitle?.trim().isNotNullOrEmpty() == true) {
      return activityTitle!.trim();
    }
    return null;
  }

  ChatConversationEntity toEntity() => ChatConversationEntity(
    conversationId: conversationId,
    requestId: requestId,
    activityTitle: activityTitle,
    chatType: chatType,
    otherUserId: otherUserId,
    otherUserName: otherUserName,
    otherUserAvatarUrl: otherUserAvatarUrl,
    categoryId: categoryId,
    categorySlug: categorySlug,
    groupAvatarUrl: groupAvatarUrl,
    lastMessage: lastMessage,
    lastMessageAt: lastMessageAt,
    unreadCount: unreadCount,
  );
}

Object? _readConversationId(Map json, String key) =>
    (json['conversation_id'] ?? json['id'])?.toString() ?? '';

Object? _readActivityTitle(Map json, String key) {
  for (final field in ['activity_title', 'request_title', 'title']) {
    final value = json[field]?.toString().trim();
    if (value?.isNotEmpty == true) return value;
  }
  return null;
}

Object? _readAvatarUrl(Map json, String key) =>
    (json['other_user_avatar_url'] ??
            json['other_avatar_url'] ??
            json['avatar_url'])
        ?.toString();

String _stringFromJson(Object? value) => value?.toString() ?? '';

String? _nullableStringFromJson(Object? value) => value?.toString();

String _chatTypeFromJson(Object? value) => value?.toString() ?? 'group';

DateTime? _dateTimeFromJson(Object? value) =>
    value == null ? null : DateTime.tryParse(value.toString());

int _intFromJson(Object? value) => int.tryParse(value?.toString() ?? '') ?? 0;
