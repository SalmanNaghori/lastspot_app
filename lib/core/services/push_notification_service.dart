import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../base_import.dart';
import '../di/service_locator.dart';
import '../network/router.dart';
import '../../features/notifications/presentation/bloc/notifications_cubit.dart';
import '../utils/fcm_token_util.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/auth/data/datasources/device_remote_datasource.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ensure Firebase is initialized for background isolate
  await Firebase.initializeApp();
  debugPrint("Handling a background message: ${message.messageId}");
}

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _localNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          final data = jsonDecode(response.payload!);
          _handleNotificationTap(data);
        }
      },
    );

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      // Refresh notifications cubit
      _refreshNotificationsCubit();

      if (message.notification != null) {
        _showLocalNotification(message);
      }
    });

    // Background messages opened by user
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _refreshNotificationsCubit();
      _handleNotificationTap(message.data);
    });

    // Check if app was opened from terminated state via notification
    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage.data);
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

  void _showLocalNotification(RemoteMessage message) {
    // Do not show if the user is currently on the Notifications screen
    if (appRouter.routerDelegate.currentConfiguration.uri.path ==
        AppRoutes.notifications) {
      return;
    }

    final notification = message.notification!;

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'lastspot_default',
          'LastSpot Notifications',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    _localNotificationsPlugin.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: platformChannelSpecifics,
      payload: jsonEncode(message.data),
    );
  }

  void _handleNotificationTap(Map<String, dynamic> data) {
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
