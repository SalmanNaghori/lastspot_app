/// Static brand and compile-time constants for the LastSpot application.
///
/// NOTE: Per project architecture and [lastspot_master_spec.md], all user-facing
/// UI text must be defined in `lib/core/l10n/intl_en.arb` and accessed via `context.loc`.
/// This class holds non-localizable brand tokens (e.g. app name affixes) and
/// compile-time fallback constants used outside the widget tree.
class AppString {
  AppString._();

  // App-wide branding & configuration
  static const String appName = 'LastSpot';
  static const String appNamePrefix = 'Last';
  static const String appNameSuffix = 'Spot';

  // Notifications (fallbacks for non-contextual background services)
  static const String notificationPermissionTitle = 'Stay Updated';
  static const String notificationPermissionBody =
      'We need notification permissions to alert you when someone wants to join your spot or when you are accepted to a spot.';
  static const String allow = 'Allow';
  static const String notNow = 'Not Now';

  // Common UI Fallbacks
  static const String today = 'Today';
  static const String tomorrow = 'Tomorrow';
  static const String full = 'FULL';
  static const String host = 'Host';
  static const String ofText = 'of';
  static const String spots = 'Spots';
}
