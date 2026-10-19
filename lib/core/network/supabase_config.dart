import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/app_env.dart';
import '../services/password_recovery_link_monitor.dart';

class SupabaseConfig {
  static String get supabaseUrl => AppEnv.supabaseUrl;
  static String get supabaseAnonKey => AppEnv.supabaseAnonKey;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey, // ignore: deprecated_member_use
      authOptions: FlutterAuthClientOptions(
        detectSessionInUriPredicate:
            PasswordRecoveryLinkMonitor.instance.detectSessionInUri,
      ),
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
