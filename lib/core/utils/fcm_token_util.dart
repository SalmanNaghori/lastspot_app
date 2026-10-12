import 'package:firebase_messaging/firebase_messaging.dart';

class FcmTokenUtil {
  FcmTokenUtil._();

  static Future<String?> getToken() async {
    return FirebaseMessaging.instance.getToken();
  }

  static Future<void> deleteToken() async {
    await FirebaseMessaging.instance.deleteToken();
  }

  static Stream<String> get onTokenRefresh =>
      FirebaseMessaging.instance.onTokenRefresh;
}
