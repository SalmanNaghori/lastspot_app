import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../base_import.dart';
import '../di/service_locator.dart';
import '../network/router.dart';
import '../../features/notifications/presentation/bloc/notifications_cubit.dart';
import '../utils/fcm_token_util.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/auth/data/datasources/device_remote_datasource.dart';
import 'package:lastspot_app/core/services/local_notification_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ensure Firebase is initialized for background isolate
  await Firebase.initializeApp();
  debugPrint("Handling a background message: ${message.messageId}");
}

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _fcm.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

    // Initialize local notifications service if registered
    if (sl.isRegistered<LocalNotificationService>()) {
      await sl<LocalNotificationService>().initialize();
    }

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      // Refresh notifications cubit
      _refreshNotificationsCubit();

      if (message.notification != null) {
        if (sl.isRegistered<LocalNotificationService>()) {
          sl<LocalNotificationService>().showNotification(
            id: message.notification.hashCode,
            title: message.notification?.title,
            body: message.notification?.body,
            payload: message.data,
          );
        }
      }
    });

    // Background messages opened by user
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _refreshNotificationsCubit();
      handleNotificationTap(message.data);
    });

    // Check if app was opened from terminated state via notification
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      handleNotificationTap(initialMessage.data);
    }

    // Refresh token
    FcmTokenUtil.onTokenRefresh.listen((newToken) async {
      debugPrint("FCM Token Refreshed: $newToken");
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
    final type = data['type'] as String?;
    final requestId = data['request_id'] as String?;

    if (type == null || requestId == null) return;

    if (type == 'join_request') {
      appRouter.push(AppRoutes.manageRequestsPath(requestId));
    } else if (['join_accepted', 'join_rejected', 'broadcast'].contains(type)) {
      appRouter.push(AppRoutes.spotDetailsPath(requestId));
    }
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
