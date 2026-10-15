import 'package:flutter/material.dart';

enum AppThemeColor {
  sportsGreen('Sports Green', Color(0xFF15803D)),
  emerald('Emerald Pitch', Color(0xFF166534)),
  forest('Forest Turf', Color(0xFF1B4D3E)),
  violet('Violet', Color(0xFF5B46E8)),
  deepViolet('Deep violet', Color(0xFF3C28A4)),
  terracotta('Terracotta', Color(0xFF752A21));

  const AppThemeColor(this.label, this.primary);

  final String label;
  final Color primary;

  Color get darkPrimary => Color.lerp(primary, Colors.white, 0.42)!;
}

class AppColor {
  AppColor._();

  // ============================================================
  // BRAND COLORS (FAREEQ-INSPIRED SPORTS IDENTITY)
  // ============================================================

  /// Main LastSpot sports brand color (pitch/turf green).
  /// Used for primary CTAs, selected navigation, active chips.
  static const Color primaryColor = Color(0xFF15803D);

  /// Darker pitch green for strong contrast.
  static const Color primaryDarkColor = Color(0xFF0F5128);

  /// Soft mint/grass green container surface.
  static const Color primaryContainerLight = Color(0xFFE8F5E9);

  /// Deep forest container for dark mode.
  static const Color primaryContainerDark = Color(0xFF1C3A29);

  /// Secondary brand dark neutral.
  static const Color secondaryColor = Color(0xFF1A1D1B);

  /// Secondary accent for dark theme.
  static const Color secondaryDarkColor = Color(0xFFCBD5E1);

  // ============================================================
  // ACCENT COLORS
  // ============================================================

  /// Warm energetic sports accent (urgent matches, limited spots).
  static const Color accentColor = Color(0xFFEA580C);

  static const Color accentHighlight = Color(0xFFFB923C);

  static const Color accentLight = Color(0xFFFFEDD5);

  static const Color accentDark = Color(0xFF9A3412);

  // ============================================================
  // LIGHT THEME (WARM CREAM & SOFT NEUTRALS)
  // ============================================================

  /// Warm cream background
  static const Color backgroundLight = Color(0xFFFAF8F5);

  /// Clean crisp white for elevated cards
  static const Color surfaceLight = Color(0xFFFFFFFF);

  /// Soft warm neutral container
  static const Color surfaceContainerLight = Color(0xFFF3EFE9);

  /// Subtle light warm surface
  static const Color surfaceContainerLowLight = Color(0xFFFDFBF7);

  /// Elevated warm neutral card surface
  static const Color surfaceContainerHighLight = Color(0xFFEBE5DB);

  /// Soft warm card border
  static const Color cardBorderLight = Color(0xFFE5DFD5);

  /// Border light color alias
  static const Color borderLight = Color(0xFFE5DFD5);

  static const Color dividerLight = Color(0xFFEFE9DE);

  // ============================================================
  // DARK THEME
  // ============================================================

  static const Color backgroundDark = Color(0xFF111412);

  static const Color surfaceDark = Color(0xFF191D1A);

  static const Color surfaceContainerDark = Color(0xFF212723);

  static const Color surfaceContainerLowDark = Color(0xFF1C211E);

  static const Color surfaceContainerHighDark = Color(0xFF2B332E);

  static const Color cardBorderDark = Color(0xFF36403A);

  /// Border dark color alias
  static const Color borderDark = Color(0xFF36403A);

  static const Color dividerDark = Color(0xFF36403A);

  // ============================================================
  // TEXT COLORS (BOLD DARK HEADINGS & REFINED SECONDARY)
  // ============================================================

  static const Color textPrimaryLight = Color(0xFF111827);

  static const Color textSecondaryLight = Color(0xFF4B5563);

  static const Color textTertiaryLight = Color(0xFF9CA3AF);

  static const Color textPrimaryDark = Color(0xFFF9FAFB);

  static const Color textSecondaryDark = Color(0xFFD1D5DB);

  static const Color textTertiaryDark = Color(0xFF9CA3AF);

  // ============================================================
  // STATUS & SEMANTIC COLORS
  // ============================================================

  /// Error / destructive action
  static const Color errorColor = Color(0xFFDC2626);

  static const Color errorContainerLight = Color(0xFFFEE2E2);

  static const Color errorContainerDark = Color(0xFF7F1D1D);

  /// Success / joined / available (Pitch Green)
  static const Color successColor = Color(0xFF15803D);

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

  static ColorScheme colorSchemeFor(
    Brightness brightness,
    AppThemeColor themeColor,
  ) {
    final isDark = brightness == Brightness.dark;
    final primary = isDark ? themeColor.darkPrimary : themeColor.primary;
    final primaryContainer = isDark
        ? Color.lerp(themeColor.primary, backgroundDark, 0.68)!
        : Color.lerp(themeColor.primary, Colors.white, 0.88)!;
    final baseScheme = isDark ? darkColorScheme : lightColorScheme;

    return baseScheme.copyWith(
      primary: primary,
      onPrimary: isDark ? backgroundDark : Colors.white,
      primaryContainer: primaryContainer,
      onPrimaryContainer: isDark ? themeColor.darkPrimary : themeColor.primary,
      secondary: primary,
      onSecondary: isDark ? backgroundDark : Colors.white,
      secondaryContainer: primaryContainer,
      onSecondaryContainer: isDark
          ? themeColor.darkPrimary
          : themeColor.primary,
    );
  }
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
