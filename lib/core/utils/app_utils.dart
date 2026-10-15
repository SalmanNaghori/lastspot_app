import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../base_import.dart';
import 'package:lastspot_app/features/cities/presentation/bloc/city_cubit.dart';
import 'package:lastspot_app/features/cities/presentation/bloc/city_state.dart';
import '../services/in_app_feedback_manager.dart';

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
    bool? persistent,
    Duration duration = const Duration(seconds: 3),
  }) {
    context.read<InAppFeedbackManager>().showFeedback(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: AppColor.whiteColor),
        ),
        backgroundColor: isError ? AppColor.errorColor : context.primaryColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.r12),
        ),
        action: isError
            ? SnackBarAction(label: context.loc.dismiss, onPressed: () {})
            : null,
      ),
      isPersistent: persistent ?? isError,
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

  static Future<bool> launchMap(String query) async {
    final location = query.trim();
    if (location.isEmpty) return false;
    if (location.startsWith('http://') || location.startsWith('https://')) {
      return launchWebUrl(location);
    }
    final encodedQuery = Uri.encodeComponent(location);
    final url = 'https://www.google.com/maps/search/?api=1&query=$encodedQuery';
    return launchWebUrl(url);
  }

  /// Formats DateTime to readable string (e.g., "Sep 4, 2026")
  static String formatDate(DateTime dateTime) {
    return DateFormat.yMMMd().format(dateTime);
  }

  /// Extracts display location (resolving URLs to "Map Location")
  static String getDisplayLocation(
    BuildContext context,
    String location, {
    String? cityId,
  }) {
    String finalLocation = location;
    final lower = location.toLowerCase();
    if (lower.startsWith('http://') || lower.startsWith('https://')) {
      finalLocation = context.loc.mapLocation;
    }

    if (cityId != null) {
      final cityState = context.read<CityCubit>().state;
      if (cityState is CityLoaded) {
        for (var c in cityState.cities) {
          if (c.id == cityId) {
            return '${c.name} • $finalLocation';
          }
        }
      }
    }

    return finalLocation;
  }

  /// Formats DateTime to readable time (e.g., "6:30 PM")
  static String formatTime(DateTime dateTime) {
    return DateFormat.jm().format(dateTime);
  }

  /// Formats DateTime to full date and time (e.g., "Sep 4, 2026 • 6:30 PM")
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM d, yyyy • h:mm a').format(dateTime);
  }

  /// Calculates and formats the time passed since the given DateTime (e.g., "2 hours ago")
  static String timeAgo(DateTime dateTime) {
    final Duration diff = DateTime.now().difference(dateTime);

    if (diff.inDays > 365) {
      return '${(diff.inDays / 365).floor()} ${diff.inDays / 365 >= 2 ? 'years' : 'year'} ago';
    }
    if (diff.inDays > 30) {
      return '${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() >= 2 ? 'months' : 'month'} ago';
    }
    if (diff.inDays > 0) {
      return '${diff.inDays} ${diff.inDays == 1 ? 'day' : 'days'} ago';
    }
    if (diff.inHours > 0) {
      return '${diff.inHours} ${diff.inHours == 1 ? 'hour' : 'hours'} ago';
    }
    if (diff.inMinutes > 0) {
      return '${diff.inMinutes} ${diff.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    }
    return 'Just now';
  }

  /// Formats currency with currency symbol
  static String formatCurrency(double amount, {String symbol = '₹'}) {
    return '$symbol${amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 2)}';
  }

  /// Shows a standard confirmation dialog
  static Future<void> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmText,
    required String cancelText,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    bool isDestructive = false,
  }) async {
    final confirmed = await AppDialog.showConfirmation(
      context: context,
      title: title,
      message: message,
      confirmLabel: confirmText,
      cancelLabel: cancelText,
      isDestructive: isDestructive,
    );
    if (!context.mounted) return;
    if (confirmed == true) {
      onConfirm();
    } else if (confirmed == false) {
      onCancel?.call();
    }
  }

  /// Returns a representative emoji for a given category name or activity title
  static String getCategoryEmoji(String? categoryOrTitle) {
    if (categoryOrTitle == null) return '🏆';
    final lower = categoryOrTitle.toLowerCase();
    if (lower.contains('cricket')) return '🏏';
    if (lower.contains('football') || lower.contains('soccer')) return '⚽';
    if (lower.contains('badminton')) return '🏸';
    if (lower.contains('tennis')) return '🎾';
    if (lower.contains('basketball')) return '🏀';
    if (lower.contains('volleyball')) return '🏐';
    if (lower.contains('running') || lower.contains('run')) return '🏃';
    if (lower.contains('cycling') || lower.contains('bike')) return '🚴';
    if (lower.contains('travel') || lower.contains('trip')) return '✈️';
    if (lower.contains('hiking') || lower.contains('trek')) return '🥾';
    if (lower.contains('event')) return '🎉';
    return '🏆';
  }

  /// Returns a representative icon for a given category name or activity title
  static IconData getCategoryIcon(String? categoryOrTitle) {
    if (categoryOrTitle == null) return Icons.groups_rounded;
    final lower = categoryOrTitle.toLowerCase();
    if (lower.contains('cricket')) return Icons.sports_cricket;
    if (lower.contains('football') || lower.contains('soccer')) {
      return Icons.sports_soccer;
    }
    if (lower.contains('badminton') || lower.contains('tennis')) {
      return Icons.sports_tennis;
    }
    if (lower.contains('basketball')) return Icons.sports_basketball;
    if (lower.contains('volleyball')) return Icons.sports_volleyball;
    if (lower.contains('running')) return Icons.directions_run;
    if (lower.contains('cycling')) return Icons.directions_bike;
    if (lower.contains('travel')) return Icons.flight_takeoff;
    if (lower.contains('hiking')) return Icons.landscape;
    if (lower.contains('event')) return Icons.event;
    return Icons.groups_rounded;
  }
}

/// Project rule alias: Utils = AppUtils
typedef Utils = AppUtils;
