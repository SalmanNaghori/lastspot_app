import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final AppThemeColor appThemeColor;
  final String locale;

  const SettingsState({
    required this.themeMode,
    required this.appThemeColor,
    required this.locale,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    AppThemeColor? appThemeColor,
    String? locale,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      appThemeColor: appThemeColor ?? this.appThemeColor,
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object?> get props => [themeMode, appThemeColor, locale];
}
