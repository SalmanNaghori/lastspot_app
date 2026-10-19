import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/chat/domain/usecases/mark_chat_read_usecase.dart';
import '../../features/chat/presentation/utils/chat_text_formatter.dart';
import 'chat_visibility_tracker.dart';
import 'local_notification_service.dart';

/// Central coordinator enforcing rules A, B, C, D, E, and F for foreground
/// incoming chat message notifications.
class ForegroundChatNotificationCoordinator {
  final ChatVisibilityTracker visibilityTracker;
  final LocalNotificationService localNotificationService;
  final MarkChatReadUseCase markChatReadUseCase;
  final SupabaseClient supabaseClient;

  // Deduplication cache to prevent handling the same message twice across FCM and Realtime
  final Map<String, DateTime> _handledMessageIds = {};
  static const Duration _dedupWindow = Duration(minutes: 2);

  ForegroundChatNotificationCoordinator({
    required this.visibilityTracker,
    required this.localNotificationService,
    required this.markChatReadUseCase,
    required this.supabaseClient,
  });

  /// Evaluates whether an incoming chat notification should be presented in foreground.
  bool shouldShowForegroundNotification({
    required String? conversationId,
    required String? messageId,
    required String? senderId,
    bool isForegroundSource = false,
  }) {
    // 1. Deduplicate by message ID
    if (messageId != null && messageId.trim().isNotEmpty) {
      _cleanupOldMessageIds();
      if (_handledMessageIds.containsKey(messageId.trim())) {
        return false;
      }
      _handledMessageIds[messageId.trim()] = DateTime.now();
    }

    // 2. RULE F: Own messages must never trigger push notifications
    final currentUserId = supabaseClient.auth.currentUser?.id;
    if (currentUserId != null &&
        senderId != null &&
        senderId.trim() == currentUserId) {
      return false;
    }

    // 3. RULE E: If app is not in foreground, allow system FCM background behavior
    if (!isForegroundSource && !visibilityTracker.isAppForeground) {
      return false;
    }

    // 4. RULE A: Current open conversation
    if (conversationId != null &&
        visibilityTracker.isConversationCurrentlyVisible(conversationId)) {
      unawaited(markChatReadUseCase(conversationId));
      return false; // Suppress foreground notification completely
    }

    // 5. RULE C: Chats list tab is actively visible
    if (visibilityTracker.isUserOnChatsList()) {
      return false; // Suppress notification; real-time list provides sufficient feedback
    }

    // 6. RULE B & D: User is on Home, Explore, Activities, Profile, or in a different conversation
    return true;
  }

  /// Handles incoming FCM RemoteMessage or payload and triggers managed presentation if allowed.
  void handleIncomingChatNotification({
    required Map<String, dynamic> data,
    RemoteNotification? notification,
    String? messageId,
    String? title,
    String? body,
    bool isForegroundSource = false,
  }) {
    final conversationId =
        (data['conversation_id'] ?? data['conversationId'] ?? data['id'])
            ?.toString()
            .trim();
    final senderId = (data['sender_id'] ?? data['senderId'] ?? data['sender'])
        ?.toString()
        .trim();
    final resolvedMessageId =
        (data['message_id'] ?? data['messageId'] ?? messageId)
            ?.toString()
            .trim();

    final shouldShow = shouldShowForegroundNotification(
      conversationId: conversationId,
      messageId: resolvedMessageId,
      senderId: senderId,
      isForegroundSource: isForegroundSource,
    );

    if (!shouldShow || conversationId == null) {
      return;
    }

    final senderName =
        (data['sender_name'] ??
                data['senderName'] ??
                title ??
                notification?.title ??
                'New message')
            .toString();
    final rawContent =
        (data['content'] ?? data['body'] ?? body ?? notification?.body ?? '')
            .toString();
    final cleanContent = ChatTextFormatter.cleanPreview(rawContent);

    // Show single managed local notification (no intrusive bottom toast/snackBar)
    localNotificationService.showNotification(
      id: conversationId.hashCode,
      title: senderName,
      body: cleanContent.isNotEmpty ? cleanContent : null,
      payload: {
        ...data,
        'conversation_id': conversationId,
        'type': 'chat_message',
      },
    );
  }

  void _cleanupOldMessageIds() {
    final now = DateTime.now();
    _handledMessageIds.removeWhere(
      (_, time) => now.difference(time) > _dedupWindow,
    );
  }
}
