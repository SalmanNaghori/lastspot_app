import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../base_import.dart';

/// App-wide utility methods as specified in project Rule 13.
class AppUtils {
  AppUtils._();

  /// Hides the soft keyboard
  static void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  /// Shows a styled SnackBar with consistent theme
  static void showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: AppColor.whiteColor),
        ),
        backgroundColor: isError ? AppColor.errorColor : AppColor.primaryColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.r12),
        ),
      ),
    );
  }

  /// Launches external URL safely
  static Future<bool> launchWebUrl(String urlString) async {
    try {
      final uri = Uri.tryParse(urlString);
      if (uri != null && await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
    return false;
  }

  /// Formats DateTime to readable string (e.g., "Sep 4, 2026")
  static String formatDate(DateTime dateTime) {
    return DateFormat.yMMMd().format(dateTime);
  }

  /// Formats DateTime to readable time (e.g., "6:30 PM")
  static String formatTime(DateTime dateTime) {
    return DateFormat.jm().format(dateTime);
  }

  /// Formats DateTime to full date and time (e.g., "Sep 4, 2026 • 6:30 PM")
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM d, yyyy • h:mm a').format(dateTime);
  }

  /// Formats currency with currency symbol
  static String formatCurrency(double amount, {String symbol = '₹'}) {
    return '$symbol${amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 2)}';
  }
}

/// Project rule alias: Utils = AppUtils
typedef Utils = AppUtils;
