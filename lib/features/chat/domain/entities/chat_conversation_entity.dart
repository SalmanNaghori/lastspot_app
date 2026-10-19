import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/extension/string_extension.dart';

part 'chat_conversation_entity.freezed.dart';

@freezed
abstract class ChatConversationEntity with _$ChatConversationEntity {
  const ChatConversationEntity._();

  const factory ChatConversationEntity({
    required String conversationId,
    required String requestId,
    String? activityTitle,
    required String chatType,
    String? otherUserId,
    String? otherUserName,
    String? otherUserAvatarUrl,
    String? categoryId,
    String? categorySlug,
    String? groupAvatarUrl,
    String? lastMessage,
    DateTime? lastMessageAt,
    @Default(0) int unreadCount,
  }) = _ChatConversationEntity;

  bool get isDirect => chatType == 'direct';

  /// Primary display title: other user's name for direct chats,
  /// or activity title / category slug for group chats.
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

  /// Resolved title with localized fallbacks.
  String getTitle({
    required String defaultDirect,
    required String defaultGroup,
  }) {
    final title = displayTitle;
    if (title.isNotNullOrEmpty()) return title!;
    return isDirect ? defaultDirect : defaultGroup;
  }

  /// Related activity title / context for direct chats.
  /// Returns activity title if available, otherwise capitalized category slug.
  String? get directActivityTitle {
    if (!isDirect) return null;
    final title = activityTitle?.trim();
    if (title.isNotNullOrEmpty()) return title;
    final slug = categorySlug?.trim();
    if (slug.isNotNullOrEmpty()) return slug!.capitalizeFirst();
    return null;
  }

  /// Activity subtitle with optional fallback for direct chat context.
  String? getDirectActivitySubtitle({String? fallbackActivityLabel}) {
    final title = directActivityTitle;
    if (title.isNotNullOrEmpty()) return title;
    if (isDirect &&
        requestId.trim().isNotNullOrEmpty() &&
        fallbackActivityLabel.isNotNullOrEmpty()) {
      return fallbackActivityLabel;
    }
    return null;
  }

  /// Preview of the last message with a localized fallback.
  String getPreviewMessage({required String defaultEmpty}) {
    final msg = lastMessage?.trim();
    return msg.isNotNullOrEmpty() ? msg! : defaultEmpty;
  }

  /// Resolved avatar URL depending on direct vs group.
  String? get displayAvatarUrl =>
      isDirect ? otherUserAvatarUrl : groupAvatarUrl;

  /// Fallback display name for avatar initials.
  String get avatarDisplayName {
    if (isDirect) {
      final name = otherUserName?.trim();
      return name.isNotNullOrEmpty() ? name! : 'U';
    }
    final title = activityTitle?.trim();
    return title.isNotNullOrEmpty() ? title! : '#';
  }

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

  /// Search query matching across name, activity title, category slug, and last message.
  bool matchesSearch(String query) {
    if (query.trim().isEmpty) return true;
    final q = query.trim().toLowerCase();
    final name = otherUserName?.toLowerCase() ?? '';
    final activity = activityTitle?.toLowerCase() ?? '';
    final category = categorySlug?.toLowerCase() ?? '';
    final msg = lastMessage?.toLowerCase() ?? '';
    return name.contains(q) ||
        activity.contains(q) ||
        category.contains(q) ||
        msg.contains(q);
  }
}
