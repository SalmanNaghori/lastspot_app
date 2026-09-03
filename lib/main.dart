import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/network/supabase_config.dart';
import 'core/di/service_locator.dart';
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

  // Register all singletons
  await setupServiceLocator();

  runApp(const LastSpotApp());
}
