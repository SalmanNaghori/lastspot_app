import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lastspot_app/core/network/router.dart';
import 'package:lastspot_app/core/di/service_locator.dart';
import 'package:lastspot_app/core/services/push_notification_service.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
        
    await _localNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          final data = jsonDecode(response.payload!);
          if (sl.isRegistered<PushNotificationService>()) {
            sl<PushNotificationService>().handleNotificationTap(data);
          }
        }
      },
    );
  }

  void showNotification({
    required int id,
    String? title,
    String? body,
    Map<String, dynamic>? payload,
  }) {
    // Do not show if the user is currently on the Notifications screen
    if (appRouter.routerDelegate.currentConfiguration.uri.path ==
        AppRoutes.notifications) {
      return;
    }

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
      id: id,
      title: title,
      body: body,
      notificationDetails: platformChannelSpecifics,
      payload: payload != null ? jsonEncode(payload) : null,
    );
  }
}
