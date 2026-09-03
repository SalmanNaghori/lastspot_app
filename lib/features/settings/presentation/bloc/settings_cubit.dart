import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/shared_prefs_util.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SharedPrefsUtil _prefs;

  SettingsCubit({required SharedPrefsUtil prefs})
    : _prefs = prefs,
      super(
        SettingsState(
          themeMode: prefs.getThemeMode(),
          locale: prefs.getLocale(),
        ),
      );

  Future<void> updateThemeMode(ThemeMode mode) async {
    await _prefs.setThemeMode(mode);
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> updateLocale(String locale) async {
    await _prefs.setLocale(locale);
    emit(state.copyWith(locale: locale));
  }
}
