import 'dart:io';
import 'package:flutter/foundation.dart';
import 'app_string.dart';
import 'date_formats.dart';

class AppConstants {
  AppConstants._();

  // App Metadata
  static const String appVersion = '1.0.0';
  static const String contactEmail = 'support@lastspot.com';

  // Platform Checkers
  static bool get isIOS => !kIsWeb && Platform.isIOS;
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
  static bool get isWeb => kIsWeb;
  static bool get isDesktop => !kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux);

  // Global Configs
  static const int paginationLimit = 20;
  static const int splashScreenDuration = 2; // seconds
  static const int connectionTimeout = 30; // seconds

  // Utility Methods
  static String getMonthName(int month) {
    if (month < 1 || month > 12) return '';
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  /// Formats a [DateTime] into a friendly display string for activities.
  /// 
  /// Example:
  /// - If [dt] is today, returns 'Today'
  /// - If [dt] is tomorrow, returns 'Tomorrow'
  /// - Otherwise, returns the date formatted as 'MMM d', e.g., 'Oct 7'
  static String formatActivityDate(DateTime dt) {
    final now = DateTime.now();
    final localDt = dt.toLocal();
    if (now.year == localDt.year &&
        now.month == localDt.month &&
        now.day == localDt.day) {
      return AppString.today;
    } else if (now.year == localDt.year &&
        now.month == localDt.month &&
        now.day == localDt.day - 1) {
      return AppString.tomorrow;
    }
    return formatDate(localDt, DateFormats.dateFormatMMMD);
  }
}
