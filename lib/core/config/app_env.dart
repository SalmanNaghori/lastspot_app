import 'package:flutter/material.dart';

/// Supported environment deployment targets.
enum EnvironmentType { local, dev, staging, prod }

/// Centralized compile-time environment configuration.
///
/// Values can be supplied at build/run time via:
/// `--dart-define=KEY=VALUE`
/// or
/// `--dart-define-from-file=env/<env>.json`
class AppEnv {
  AppEnv._();

  /// The active environment name (e.g., 'dev', 'local', 'staging', 'prod').
  static const String environment = String.fromEnvironment('APP_ENV', defaultValue: 'dev');

  /// Active environment as strongly-typed enum.
  static EnvironmentType get currentType {
    switch (environment.toLowerCase()) {
      case 'local':
        return EnvironmentType.local;
      case 'staging':
        return EnvironmentType.staging;
      case 'prod':
        return EnvironmentType.prod;
      case 'dev':
      default:
        return EnvironmentType.dev;
    }
  }

  /// Application title/display name for the active environment.
  static const String appName = String.fromEnvironment('APP_NAME', defaultValue: 'KhelBhai');

  /// Supabase backend project URL.
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://zrhmpidlutbyoiysjwxt.supabase.co',
  );

  /// Supabase client anonymous public key.
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpyaG1waWRsdXRieW9peXNqd3h0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODY5NjM5MjYsImV4cCI6MjEwMjUzOTkyNn0.3JHUaJknotJ34eeOVyI8haiiUPC5kpmBO8kkkdB8KhQ',
  );

  /// Flag to display an environment watermark banner in the app.
  static const bool showBanner = bool.fromEnvironment('SHOW_BANNER', defaultValue: false);

  /// Optional custom API base URL if an intermediate gateway is used.
  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: '');

  // Environment checks
  static bool get isDev => environment.toLowerCase() == 'dev';

  static bool get isLocal => environment.toLowerCase() == 'local';

  static bool get isStaging => environment.toLowerCase() == 'staging';

  static bool get isProd => environment.toLowerCase() == 'prod';

  /// Uppercase label for banner displays (e.g., 'DEV', 'LOCAL', 'STAGING').
  static String get bannerLabel => environment.toUpperCase();

  /// Badge color according to the environment.
  static Color get bannerColor {
    switch (environment.toLowerCase()) {
      case 'prod':
        return const Color(0xFF10B981); // Emerald Green
      case 'staging':
        return const Color(0xFFF59E0B); // Amber / Orange
      case 'local':
        return const Color(0xFF8B5CF6); // Purple
      case 'dev':
      default:
        return const Color(0xFFEF4444); // Crimson Red
    }
  }
}

/// Compatibility accessor for AppEnv
class AppEnvironment {
  AppEnvironment._();

  EnvironmentType get type => AppEnv.currentType;
  static final AppEnvironment current = AppEnvironment._();
}
