import 'package:flutter/material.dart';

class AppColor {
  AppColor._();

  // Primary Color: Electric Emerald / Stadium Green
  static const Color primaryColor = Color(0xFF0FA958);
  
  // Secondary / Dark Accent: Deep Slate
  static const Color secondaryColor = Color(0xFF0F172A);
  
  // Light Theme Colors
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color cardBorderLight = Color(0xFFE2E8F0);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color surfaceLight = Colors.white;

  // Dark Theme Colors
  static const Color backgroundDark = Color(0xFF0F172A); // Deep slate background
  static const Color cardBorderDark = Color(0xFF1E293B);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color surfaceDark = Color(0xFF1E293B);
  
  // Common Colors
  static const Color whiteColor = Colors.white;
  static const Color blackColor = Colors.black;
  static const Color transparentColor = Colors.transparent;
  
  // Status Colors
  static const Color errorColor = Color(0xFFEF4444);
  static const Color successColor = Color(0xFF22C55E);
  static const Color warningColor = Color(0xFFF59E0B);
  
  // Help border used for specific cases
  static const Color helpCardBorderColor = Color(0xFFCBD5E1);
}

// Extension to easily fetch semantic colors based on theme
extension ThemeColors on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  Color get backgroundColor =>
      isDarkMode ? AppColor.backgroundDark : AppColor.backgroundLight;

  Color get surfaceColor =>
      isDarkMode ? AppColor.surfaceDark : AppColor.surfaceLight;

  Color get textPrimary =>
      isDarkMode ? AppColor.textPrimaryDark : AppColor.textPrimaryLight;

  Color get textSecondary =>
      isDarkMode ? AppColor.textSecondaryDark : AppColor.textSecondaryLight;

  Color get borderColor =>
      isDarkMode ? AppColor.cardBorderDark : AppColor.cardBorderLight;
}
