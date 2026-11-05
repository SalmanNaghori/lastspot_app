import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lastspot_app/core/network/router.dart';
import 'package:lastspot_app/core/di/service_locator.dart';
import 'package:lastspot_app/core/services/push_notification_service.dart';
import 'package:lastspot_app/core/services/chat_visibility_tracker.dart';
import 'package:lastspot_app/core/theme/app_color.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final Map<String, DateTime> _recentNotificationKeys = {};
  static const _dedupDuration = Duration(seconds: 8);

  void _pruneRecentKeys() {
    final now = DateTime.now();
    _recentNotificationKeys.removeWhere(
      (_, time) => now.difference(time) > _dedupDuration,
    );
  }

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_notification');
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    await _localNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          try {
            final data = jsonDecode(response.payload!);
            if (sl.isRegistered<PushNotificationService>()) {
              sl<PushNotificationService>().handleNotificationTap(
                Map<String, dynamic>.from(data),
              );
            }
          } catch (e) {
            debugPrint('Error handling notification tap: $e');
          }
        }
      },
    );

    // Create default high-importance channel on Android 8+
    final androidImplementation = _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidImplementation?.createNotificationChannel(
      const AndroidNotificationChannel(
        'lastspot_default',
        'KhelBhai Notifications',
        description: 'Activity and match notifications',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      ),
    );

    // Check if app was opened via local notification
    try {
      final launchDetails = await _localNotificationsPlugin
          .getNotificationAppLaunchDetails();
      if (launchDetails?.didNotificationLaunchApp == true &&
          launchDetails?.notificationResponse?.payload != null) {
        final payload = launchDetails!.notificationResponse!.payload!;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          try {
            final data = jsonDecode(payload);
            if (sl.isRegistered<PushNotificationService>()) {
              sl<PushNotificationService>().handleNotificationTap(
                Map<String, dynamic>.from(data),
              );
            }
          } catch (e) {
            debugPrint('Error handling initial notification launch: $e');
          }
        });
      }
    } catch (e) {
      debugPrint('Error checking notification launch details: $e');
    }
  }

  Future<bool?> requestPermission() async {
    final androidImplementation = _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final androidGranted = await androidImplementation
        ?.requestNotificationsPermission();

    final iosImplementation = _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    final iosGranted = await iosImplementation?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    return androidGranted ?? iosGranted;
  }

  void showNotification({
    required int id,
    String? title,
    String? body,
    Map<String, dynamic>? payload,
  }) {
    // Do not show if the user is currently on the Notifications screen
    try {
      if (appRouter.routerDelegate.currentConfiguration.uri.path ==
          AppRoutes.notifications) {
        return;
      }
    } catch (_) {}

    // Do not show if the user is currently looking at this active conversation
    if (payload != null && sl.isRegistered<ChatVisibilityTracker>()) {
      final convId =
          payload['conversation_id']?.toString() ??
          payload['conversationId']?.toString();
      final reqId =
          payload['request_id']?.toString() ??
          payload['requestId']?.toString() ??
          payload['spot_id']?.toString() ??
          payload['spotId']?.toString();
      final senderId =
          payload['sender_id']?.toString() ??
          payload['senderId']?.toString() ??
          payload['sender']?.toString();

      if (sl<ChatVisibilityTracker>().isConversationCurrentlyVisible(
        conversationId: convId,
        requestId: reqId,
        senderId: senderId,
      )) {
        return;
      }
    }

    _pruneRecentKeys();
    final dedupKey =
        payload?['id']?.toString() ??
        payload?['notification_id']?.toString() ??
        payload?['message_id']?.toString() ??
        '$id:$title:$body';
    if (_recentNotificationKeys.containsKey(dedupKey)) {
      return;
    }
    _recentNotificationKeys[dedupKey] = DateTime.now();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'lastspot_default',
          'KhelBhai Notifications',
          channelDescription: 'Activity and match notifications',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
          icon: '@drawable/ic_notification',
          color: AppColor.primaryColor,
        );
    const DarwinNotificationDetails darwinPlatformChannelSpecifics =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: darwinPlatformChannelSpecifics,
    );

    _localNotificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: platformChannelSpecifics,
      payload: payload != null ? jsonEncode(payload) : null,
    );
  }
}
