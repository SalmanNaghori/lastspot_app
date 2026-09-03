import 'package:flutter/material.dart';

class AppColor {
  AppColor._();

  // ============================================================
  // BRAND COLORS
  // ============================================================

  /// Main LastSpot brand color.
  /// Used for primary actions, selected navigation,
  /// links and important highlights.
  static const Color primaryColor = Color(0xFF10B981);

  /// Darker version of primary.
  static const Color primaryDarkColor = Color(0xFF059669);

  /// Very light green used for containers/background highlights.
  static const Color primaryContainerLight = Color(0xFFD1FAE5);

  /// Dark green used for primary containers in dark mode.
  static const Color primaryContainerDark = Color(0xFF064E3B);

  /// Secondary brand accent.
  /// Used sparingly for important attention areas.
  static const Color secondaryColor = Color(0xFF0F172A);

  /// Secondary accent for dark theme.
  static const Color secondaryDarkColor = Color(0xFFCBD5E1);

  // ============================================================
  // ACCENT COLORS
  // ============================================================

  /// Coral/orange accent.
  /// Good for Create, highlights and important secondary actions.
  static const Color accentColor = Color(0xFFF97316);

  static const Color accentLight = Color(0xFFFFEDD5);

  static const Color accentDark = Color(0xFF9A3412);

  // ============================================================
  // LIGHT THEME
  // ============================================================

  static const Color backgroundLight = Color(0xFFF8FAFC);

  static const Color surfaceLight = Color(0xFFFFFFFF);

  static const Color surfaceContainerLight = Color(0xFFF1F5F9);

  static const Color surfaceContainerLowLight = Color(0xFFF8FAFC);

  static const Color surfaceContainerHighLight = Color(0xFFEFF3F7);

  static const Color cardBorderLight = Color(0xFFE2E8F0);

  /// Border light color alias (used in cached network image & cards)
  static const Color borderLight = Color(0xFFE2E8F0);

  static const Color dividerLight = Color(0xFFE2E8F0);

  // ============================================================
  // DARK THEME
  // ============================================================

  static const Color backgroundDark = Color(0xFF0B1220);

  static const Color surfaceDark = Color(0xFF111827);

  static const Color surfaceContainerDark = Color(0xFF1E293B);

  static const Color surfaceContainerLowDark = Color(0xFF151F2E);

  static const Color surfaceContainerHighDark = Color(0xFF273449);

  static const Color cardBorderDark = Color(0xFF334155);

  /// Border dark color alias
  static const Color borderDark = Color(0xFF334155);

  static const Color dividerDark = Color(0xFF334155);

  // ============================================================
  // TEXT COLORS
  // ============================================================

  static const Color textPrimaryLight = Color(0xFF0F172A);

  static const Color textSecondaryLight = Color(0xFF64748B);

  static const Color textTertiaryLight = Color(0xFF94A3B8);

  static const Color textPrimaryDark = Color(0xFFF8FAFC);

  static const Color textSecondaryDark = Color(0xFFCBD5E1);

  static const Color textTertiaryDark = Color(0xFF94A3B8);

  // ============================================================
  // STATUS & SEMANTIC COLORS
  // ============================================================

  /// Error / destructive action
  static const Color errorColor = Color(0xFFEF4444);

  static const Color errorContainerLight = Color(0xFFFEE2E2);

  static const Color errorContainerDark = Color(0xFF7F1D1D);

  /// Success / joined / available
  static const Color successColor = Color(0xFF22C55E);

  static const Color successContainerLight = Color(0xFFDCFCE7);

  static const Color successContainerDark = Color(0xFF14532D);

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
    surfaceContainerHighest: surfaceContainerLight,
    onSurfaceVariant: textSecondaryLight,
    outline: cardBorderLight,
    outlineVariant: dividerLight,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primaryColor,
    onPrimary: Colors.white,
    primaryContainer: primaryDarkColor,
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
    surfaceContainerHighest: surfaceContainerDark,
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

  Color get surfaceColor =>
      isDarkMode ? AppColor.surfaceDark : AppColor.surfaceLight;

  Color get surfaceContainer => isDarkMode
      ? AppColor.surfaceContainerDark
      : AppColor.surfaceContainerLight;

  Color get surfaceContainerLow => isDarkMode
      ? AppColor.surfaceContainerLowDark
      : AppColor.surfaceContainerLowLight;

  Color get surfaceContainerHigh => isDarkMode
      ? AppColor.surfaceContainerHighDark
      : AppColor.surfaceContainerHighLight;

  // ------------------------------------------------------------
  // Text
  // ------------------------------------------------------------

  Color get textPrimary =>
      isDarkMode ? AppColor.textPrimaryDark : AppColor.textPrimaryLight;

  Color get textSecondary =>
      isDarkMode ? AppColor.textSecondaryDark : AppColor.textSecondaryLight;

  Color get textTertiary =>
      isDarkMode ? AppColor.textTertiaryDark : AppColor.textTertiaryLight;

  // ------------------------------------------------------------
  // Border
  // ------------------------------------------------------------

  Color get borderColor =>
      isDarkMode ? AppColor.cardBorderDark : AppColor.cardBorderLight;

  Color get dividerColor =>
      isDarkMode ? AppColor.dividerDark : AppColor.dividerLight;

  // ------------------------------------------------------------
  // Brand
  // ------------------------------------------------------------

  Color get primaryColor => AppColor.primaryColor;

  Color get primaryContainer => isDarkMode
      ? AppColor.primaryContainerDark
      : AppColor.primaryContainerLight;

  Color get accentColor => AppColor.accentColor;

  // ------------------------------------------------------------
  // Status
  // ------------------------------------------------------------

  Color get successColor => AppColor.successColor;

  Color get warningColor => AppColor.warningColor;

  Color get errorColor => AppColor.errorColor;

  Color get infoColor => AppColor.infoColor;
}
