import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../base_import.dart';
import '../network/router.dart';
import '../../features/notifications/presentation/bloc/notifications_cubit.dart';
import '../utils/fcm_token_util.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/auth/data/datasources/device_remote_datasource.dart';
import 'package:lastspot_app/core/services/local_notification_service.dart';
import 'foreground_chat_notification_coordinator.dart';
import 'in_app_feedback_manager.dart';

import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../features/chat/presentation/utils/chat_text_formatter.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ensure Firebase is initialized for background isolate
  await Firebase.initializeApp();
  debugPrint("Handling a background message: ${message.messageId}");

  // If this is a data-only message (message.notification == null), the OS does not
  // show a notification automatically. Display one so background/terminated delivery is guaranteed.
  // If message.notification != null, the OS already displayed it; do not duplicate.
  if (message.notification == null && message.data.isNotEmpty) {
    try {
      final data = message.data;
      if (InAppFeedbackManager.isChatMessage(data)) {
        final title = (data['title'] ?? data['sender_name'] ?? 'New message')
            .toString();
        final rawBody = (data['body'] ?? data['content'] ?? '').toString();
        final body = ChatTextFormatter.cleanPreview(rawBody);
        final conversationId = InAppFeedbackManager.conversationIdFrom(data);
        if (conversationId != null) {
          final plugin = FlutterLocalNotificationsPlugin();
          const androidDetails = AndroidNotificationDetails(
            'lastspot_default',
            'KhelBhai Notifications',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: true,
            icon: '@drawable/ic_notification',
          );
          await plugin.show(
            id: conversationId.hashCode,
            title: title,
            body: body.isNotEmpty ? body : null,
            notificationDetails: const NotificationDetails(
              android: androidDetails,
            ),
            payload: jsonEncode(data),
          );
        }
      }
    } catch (e) {
      debugPrint("Error showing background local notification: $e");
    }
  }
}

class PushNotificationService {
  PushNotificationService({required this.feedbackManager});

  final InAppFeedbackManager feedbackManager;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  StreamSubscription<RemoteMessage>? _foregroundMessages;
  StreamSubscription<RemoteMessage>? _openedMessages;
  StreamSubscription<String>? _tokenRefresh;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    // Background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _fcm.setForegroundNotificationPresentationOptions(
      alert: false,
      badge: true,
      sound: true,
    );

    // Initialize local notifications service if registered
    if (sl.isRegistered<LocalNotificationService>()) {
      await sl<LocalNotificationService>().initialize();
    }

    // Foreground messages
    _foregroundMessages = FirebaseMessaging.onMessage.listen((message) {
      // Refresh notifications cubit
      _refreshNotificationsCubit();

      final data = Map<String, dynamic>.from(message.data);
      final notification = message.notification;
      if (InAppFeedbackManager.isChatMessage(data)) {
        if (sl.isRegistered<ForegroundChatNotificationCoordinator>()) {
          sl<ForegroundChatNotificationCoordinator>()
              .handleIncomingChatNotification(
                data: data,
                notification: notification,
                messageId: message.messageId,
                isForegroundSource: true,
              );
        }
        return;
      }

      final title =
          notification?.title ??
          (InAppFeedbackManager.isChatMessage(data)
              ? feedbackManager.newMessageLabel
              : null);
      if (title == null || title.trim().isEmpty) return;
      feedbackManager.showNotification(
        title: title,
        subtitle: notification?.body,
        data: data,
        eventKeys: [if (message.messageId != null) 'fcm:${message.messageId}'],
        onTap: () => handleNotificationTap(data),
      );
    });

    // Background messages opened by user
    _openedMessages = FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _refreshNotificationsCubit();
      handleNotificationTap(message.data);
    });

    // Check if app was opened from terminated state via notification
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        handleNotificationTap(initialMessage.data);
      });
    }

    // Refresh token
    _tokenRefresh = FcmTokenUtil.onTokenRefresh.listen((newToken) async {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId != null && sl.isRegistered<DeviceRemoteDataSource>()) {
        await sl<DeviceRemoteDataSource>().updateFcmToken(userId, newToken);
      }
    });
  }

  Future<void> requestPermission() async {
    final settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    debugPrint('User granted permission: ${settings.authorizationStatus}');
  }

  void handleNotificationTap(Map<String, dynamic> data) {
    if (Supabase.instance.client.auth.currentSession == null) return;
    final type = data['type']?.toString();
    final requestId = data['request_id']?.toString().trim();
    final conversationId = InAppFeedbackManager.conversationIdFrom(data);

    if (conversationId != null) {
      if (!InAppFeedbackManager.isSafeRouteIdentifier(conversationId)) return;
      appRouter.push(
        AppRoutes.conversationChatPath(
          conversationId,
          isDirect:
              data['is_direct']?.toString() == 'true' ||
              data['chat_type']?.toString().toLowerCase() == 'direct',
          name: InAppFeedbackManager.senderNameFrom(data),
          activityTitle: InAppFeedbackManager.activityNameFrom(data),
          requestId: _safeRequestId(requestId ?? data['requestId']?.toString()),
        ),
      );
      return;
    }

    if (type == null || requestId == null || requestId.isEmpty) {
      appRouter.push(AppRoutes.notifications);
      return;
    }

    if (type == 'join_request') {
      if (!InAppFeedbackManager.isSafeRouteIdentifier(requestId)) return;
      appRouter.push(AppRoutes.manageRequestsPath(requestId));
    } else if (['join_accepted', 'join_rejected', 'broadcast'].contains(type)) {
      if (!InAppFeedbackManager.isSafeRouteIdentifier(requestId)) return;
      appRouter.push(AppRoutes.spotDetailsPath(requestId));
    }
  }

  String? _safeRequestId(String? value) =>
      value != null && InAppFeedbackManager.isSafeRouteIdentifier(value)
      ? value
      : null;

  Future<void> dispose() async {
    await _foregroundMessages?.cancel();
    await _openedMessages?.cancel();
    await _tokenRefresh?.cancel();
    _initialized = false;
  }

  void _refreshNotificationsCubit() {
    try {
      if (sl.isRegistered<NotificationsCubit>()) {
        sl<NotificationsCubit>().refreshCount();
      }
    } catch (e) {
      debugPrint("Could not refresh notifications cubit: $e");
    }
  }
}
