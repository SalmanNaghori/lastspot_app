import 'package:flutter/material.dart';

class AppColor {
  AppColor._();

  // ============================================================
  // BRAND COLORS
  // ============================================================

  /// Main LastSpot brand color.
  /// Used for primary actions, selected navigation,
  /// links and important highlights.
  static const Color primaryColor = Color(0xFF5B46E8);

  /// Darker indigo for strong contrast.
  static const Color primaryDarkColor = Color(0xFF3C28A4);

  /// Soft lavender used for containers/background highlights.
  static const Color primaryContainerLight = Color(0xFFEAE5FF);

  /// Deep indigo used for primary containers in dark mode.
  static const Color primaryContainerDark = Color(0xFF2A205B);

  /// Secondary brand accent.
  /// Used sparingly for important attention areas.
  static const Color secondaryColor = Color(0xFF0F172A);

  /// Secondary accent for dark theme.
  static const Color secondaryDarkColor = Color(0xFFCBD5E1);

  // ============================================================
  // ACCENT COLORS
  // ============================================================

  /// Warm coral accent.
  /// Good for Create, highlights and important secondary actions.
  static const Color accentColor = Color(0xFFBF4939);

  static const Color accentHighlight = Color(0xFFFF9B87);

  static const Color accentLight = Color(0xFFFFE5DF);

  static const Color accentDark = Color(0xFF752A21);

  // ============================================================
  // LIGHT THEME
  // ============================================================

  static const Color backgroundLight = Color(0xFFF7F6FC);

  static const Color surfaceLight = Color(0xFFFFFFFF);

  static const Color surfaceContainerLight = Color(0xFFF0EDF8);

  static const Color surfaceContainerLowLight = Color(0xFFFAF9FE);

  static const Color surfaceContainerHighLight = Color(0xFFE9E4F4);

  static const Color cardBorderLight = Color(0xFFDDD8EB);

  /// Border light color alias (used in cached network image & cards)
  static const Color borderLight = Color(0xFFDDD8EB);

  static const Color dividerLight = Color(0xFFE5E0F0);

  // ============================================================
  // DARK THEME
  // ============================================================

  static const Color backgroundDark = Color(0xFF10101C);

  static const Color surfaceDark = Color(0xFF191827);

  static const Color surfaceContainerDark = Color(0xFF252336);

  static const Color surfaceContainerLowDark = Color(0xFF201E30);

  static const Color surfaceContainerHighDark = Color(0xFF302C43);

  static const Color cardBorderDark = Color(0xFF454057);

  /// Border dark color alias
  static const Color borderDark = Color(0xFF454057);

  static const Color dividerDark = Color(0xFF454057);

  // ============================================================
  // TEXT COLORS
  // ============================================================

  static const Color textPrimaryLight = Color(0xFF211C38);

  static const Color textSecondaryLight = Color(0xFF6D657F);

  static const Color textTertiaryLight = Color(0xFF94A3B8);

  static const Color textPrimaryDark = Color(0xFFFAF9FE);

  static const Color textSecondaryDark = Color(0xFFCBD5E1);

  static const Color textTertiaryDark = Color(0xFF94A3B8);

  // ============================================================
  // STATUS & SEMANTIC COLORS
  // ============================================================

  /// Error / destructive action
  static const Color errorColor = Color(0xFFDC2626);

  static const Color errorContainerLight = Color(0xFFFEE2E2);

  static const Color errorContainerDark = Color(0xFF7F1D1D);

  /// Success / joined / available
  static const Color successColor = Color(0xFF3469D6);

  static const Color successContainerLight = Color(0xFFE0EAFF);

  static const Color successContainerDark = Color(0xFF213C70);

  /// Warning / almost full / pending
  static const Color warningColor = Color(0xFFF59E0B);

  static const Color warningContainerLight = Color(0xFFFEF3C7);

  static const Color warningContainerDark = Color(0xFF78350F);

  /// Information
  static const Color infoColor = Color(0xFF3B82F6);

  static const Color infoContainerLight = Color(0xFFDBEAFE);

  static const Color infoContainerDark = Color(0xFF1E3A8A);

  /// Disabled
  static const Color disabledColor = Color(0xFF9CA3AF);

  // ============================================================
  // COMMON COLORS
  // ============================================================

  static const Color whiteColor = Colors.white;

  static const Color blackColor = Colors.black;

  static const Color transparentColor = Colors.transparent;

  // ============================================================
  // SPECIAL COLORS
  // ============================================================

  static const Color helpCardBorderColor = Color(0xFFCBD5E1);

  static const Color overlayColor = Color(0x66000000);

  // ============================================================
  // ALIASES FOR COMPATIBILITY WITH AppColors & THEME
  // ============================================================

  static const Color primary = primaryColor;
  static const Color primaryDark = primaryDarkColor;
  static const Color accent = accentColor;
  static const Color lightBackground = backgroundLight;
  static const Color surface = surfaceLight;
  static const Color textPrimary = textPrimaryLight;
  static const Color textSecondary = textSecondaryLight;
  static const Color textTertiary = textTertiaryLight;
  static const Color border = cardBorderLight;
  static const Color success = successColor;
  static const Color warning = warningColor;
  static const Color error = errorColor;
  static const Color info = infoColor;
  static const Color disabled = disabledColor;
  static const Color darkBorder = cardBorderDark;
  static const Color darkBackground = backgroundDark;
  static const Color darkSurface = surfaceDark;
  static const Color darkSurfaceContainer = surfaceContainerDark;
  static const Color darkTextPrimary = textPrimaryDark;
  static const Color darkTextSecondary = textSecondaryDark;

  // ============================================================
  // MATERIAL 3 COLOR SCHEMES
  // ============================================================

  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primaryColor,
    onPrimary: Colors.white,
    primaryContainer: primaryContainerLight,
    onPrimaryContainer: primaryDarkColor,
    secondary: accentColor,
    onSecondary: Colors.white,
    secondaryContainer: accentLight,
    onSecondaryContainer: accentDark,
    error: errorColor,
    onError: Colors.white,
    errorContainer: errorContainerLight,
    onErrorContainer: errorContainerDark,
    surface: surfaceLight,
    onSurface: textPrimaryLight,
    surfaceContainerLowest: surfaceLight,
    surfaceContainerLow: surfaceContainerLowLight,
    surfaceContainer: surfaceContainerLight,
    surfaceContainerHigh: surfaceContainerHighLight,
    surfaceContainerHighest: surfaceContainerHighLight,
    onSurfaceVariant: textSecondaryLight,
    outline: cardBorderLight,
    outlineVariant: dividerLight,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primaryContainerLight,
    onPrimary: primaryContainerDark,
    primaryContainer: primaryContainerDark,
    onPrimaryContainer: primaryContainerLight,
    secondary: accentColor,
    onSecondary: Colors.white,
    secondaryContainer: accentDark,
    onSecondaryContainer: accentLight,
    error: errorColor,
    onError: Colors.white,
    errorContainer: errorContainerDark,
    onErrorContainer: errorContainerLight,
    surface: surfaceDark,
    onSurface: textPrimaryDark,
    surfaceContainerLowest: backgroundDark,
    surfaceContainerLow: surfaceContainerLowDark,
    surfaceContainer: surfaceContainerDark,
    surfaceContainerHigh: surfaceContainerHighDark,
    surfaceContainerHighest: surfaceContainerHighDark,
    onSurfaceVariant: textSecondaryDark,
    outline: cardBorderDark,
    outlineVariant: dividerDark,
  );
}

/// Type alias so references to `AppColors` continue to work seamlessly
typedef AppColors = AppColor;

// ============================================================
// THEME EXTENSION FOR SEMANTIC COLORS
// ============================================================

class SemanticColors extends ThemeExtension<SemanticColors> {
  final Color success;
  final Color warning;
  final Color info;
  final Color disabled;
  final Color border;

  const SemanticColors({
    required this.success,
    required this.warning,
    required this.info,
    required this.disabled,
    required this.border,
  });

  @override
  ThemeExtension<SemanticColors> copyWith({
    Color? success,
    Color? warning,
    Color? info,
    Color? disabled,
    Color? border,
  }) {
    return SemanticColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      disabled: disabled ?? this.disabled,
      border: border ?? this.border,
    );
  }

  @override
  ThemeExtension<SemanticColors> lerp(
    covariant ThemeExtension<SemanticColors>? other,
    double t,
  ) {
    if (other is! SemanticColors) return this;
    return SemanticColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      border: Color.lerp(border, other.border, t)!,
    );
  }
}

// ============================================================
// CONTEXT EXTENSIONS FOR THEME COLORS
// ============================================================

extension ThemeColors on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => theme.colorScheme;

  /// Semantic colors theme extension
  SemanticColors get semantics =>
      theme.extension<SemanticColors>() ??
      const SemanticColors(
        success: AppColor.successColor,
        warning: AppColor.warningColor,
        info: AppColor.infoColor,
        disabled: AppColor.disabledColor,
        border: AppColor.cardBorderLight,
      );

  /// Quick accessor for colorScheme (alias)
  ColorScheme get colors => theme.colorScheme;

  bool get isDarkMode => theme.brightness == Brightness.dark;

  // ------------------------------------------------------------
  // Background
  // ------------------------------------------------------------

  Color get backgroundColor =>
      isDarkMode ? AppColor.backgroundDark : AppColor.backgroundLight;

  // ------------------------------------------------------------
  // Surface
  // ------------------------------------------------------------

  Color get surfaceColor => colorScheme.surface;

  Color get surfaceContainer => colorScheme.surfaceContainerHighest;

  Color get surfaceContainerLow => colorScheme.surfaceContainerLow;

  Color get surfaceContainerHigh => colorScheme.surfaceContainerHigh;

  // ------------------------------------------------------------
  // Text
  // ------------------------------------------------------------

  Color get textPrimary => colorScheme.onSurface;

  Color get textSecondary => colorScheme.onSurfaceVariant;

  Color get textTertiary => colorScheme.onSurfaceVariant.withValues(alpha: 0.7);

  // ------------------------------------------------------------
  // Border
  // ------------------------------------------------------------

  Color get borderColor => colorScheme.outline;

  Color get dividerColor => colorScheme.outlineVariant;

  // ------------------------------------------------------------
  // Brand
  // ------------------------------------------------------------

  Color get primaryColor => colorScheme.primary;

  Color get primaryContainer => colorScheme.primaryContainer;

  Color get accentColor => colorScheme.secondary;

  // ------------------------------------------------------------
  // Status
  // ------------------------------------------------------------

  Color get successColor => semantics.success;

  Color get warningColor => semantics.warning;

  Color get errorColor => colorScheme.error;

  Color get infoColor => semantics.info;
}
