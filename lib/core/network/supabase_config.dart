import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://zrhmpidlutbyoiysjwxt.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpyaG1waWRsdXRieW9peXNqd3h0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODY5NjM5MjYsImV4cCI6MjEwMjUzOTkyNn0.3JHUaJknotJ34eeOVyI8haiiUPC5kpmBO8kkkdB8KhQ';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey, // ignore: deprecated_member_use
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
