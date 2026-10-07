import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/features/spot/domain/entities/join_request_entity.dart';
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

  // Data
  static List<String> getAvailableSports(BuildContext context) {
    return [
      context.loc.sportSoccer,
      context.loc.sportBasketball,
      context.loc.sportTennis,
      context.loc.sportVolleyball,
      context.loc.sportBadminton,
      context.loc.sportTableTennis,
      context.loc.sportCricket,
      context.loc.sportSwimming,
      context.loc.sportRunning,
      context.loc.sportCycling,
    ];
  }

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

  /// Returns the appropriate color for a given [JoinRequestStatus].
  /// 
  /// Example:
  /// - Pending -> Warning color (Orange/Yellow)
  /// - Accepted -> Success color (Green)
  /// - Rejected/Cancelled -> Error color (Red)
  static Color getStatusColor(BuildContext context, JoinRequestStatus status) {
    switch (status) {
      case JoinRequestStatus.pending:
        return context.warningColor;
      case JoinRequestStatus.accepted:
        return context.successColor;
      case JoinRequestStatus.rejected:
      case JoinRequestStatus.cancelled:
        return context.errorColor;
    }
  }
}
