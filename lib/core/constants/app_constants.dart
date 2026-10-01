import 'dart:io';
import 'package:flutter/foundation.dart';

class AppConstants {
  AppConstants._();

  // App Metadata
  static const String appVersion = '1.0.0';
  static const String contactEmail = 'support@lastspot.com';

  // Platform Checkers
  static bool get isIOS => !kIsWeb && Platform.isIOS;
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
  static bool get isWeb => kIsWeb;
  static bool get isDesktop =>
      !kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux);

  // Global Configs
  static const int paginationLimit = 20;
  static const int splashScreenDuration = 2; // seconds
  static const int connectionTimeout = 30; // seconds

  // Utility Methods
  static String getMonthName(int month) {
    if (month < 1 || month > 12) return '';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
