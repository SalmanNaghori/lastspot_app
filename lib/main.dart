import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/network/supabase_config.dart';
import 'core/di/service_locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/services/push_notification_service.dart';
import 'lastspot_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Android 15 edge-to-edge support and transparent system bars
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );

  // Initialize Supabase
  await SupabaseConfig.initialize();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Register all singletons
  await setupServiceLocator();

  // Initialize Push Notification Service
  await sl<PushNotificationService>().initialize();

  runApp(const LastSpotApp());
}
