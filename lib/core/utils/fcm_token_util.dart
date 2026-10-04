import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FcmTokenUtil {
  FcmTokenUtil._();

  static Future<String?> getToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    debugPrint('=== FCM TOKEN ===\n$token\n=================');
    return token;
  }

  static Future<void> deleteToken() async {
    await FirebaseMessaging.instance.deleteToken();
  }

  static Stream<String> get onTokenRefresh =>
      FirebaseMessaging.instance.onTokenRefresh;
}
