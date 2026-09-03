import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Centralized storage keys for SharedPreferences to avoid raw strings.
class SharedPrefsKeys {
  SharedPrefsKeys._();

  static const String themeMode = 'theme_mode';
  static const String locale = 'locale';
  static const String skippedUpdateVersion = 'skipped_update_version';
  static const String userToken = 'user_token';
  static const String userId = 'user_id';
  static const String onboardingCompleted = 'onboarding_completed';
}

/// Abstract contract for SharedPreferences utility (Dependency Inversion Principle).
abstract class SharedPrefsUtil {
  // Theme & Locale
  ThemeMode getThemeMode();
  Future<bool> setThemeMode(ThemeMode mode);

  String getLocale();
  Future<bool> setLocale(String locale);

  // Version Control
  String? getSkippedUpdateVersion();
  Future<bool> setSkippedUpdateVersion(String version);

  // Generic Primitive Storage
  String? getString(String key);
  Future<bool> setString(String key, String value);

  int? getInt(String key);
  Future<bool> setInt(String key, int value);

  bool getBool(String key, {bool defaultValue = false});
  Future<bool> setBool(String key, bool value);

  double? getDouble(String key);
  Future<bool> setDouble(String key, double value);

  List<String>? getStringList(String key);
  Future<bool> setStringList(String key, List<String> value);

  bool containsKey(String key);
  Future<bool> remove(String key);
  Future<bool> clear();
  Future<void> reload();
}

/// Implementation of [SharedPrefsUtil] wrapping [SharedPreferences].
/// Injected via GetIt service locator.
class SharedPrefsUtilImpl implements SharedPrefsUtil {
  final SharedPreferences _prefs;

  SharedPrefsUtilImpl(this._prefs);

  @override
  ThemeMode getThemeMode() {
    final index = _prefs.getInt(SharedPrefsKeys.themeMode);
    if (index != null && index >= 0 && index < ThemeMode.values.length) {
      return ThemeMode.values[index];
    }
    return ThemeMode.system;
  }

  @override
  Future<bool> setThemeMode(ThemeMode mode) {
    return _prefs.setInt(SharedPrefsKeys.themeMode, mode.index);
  }

  @override
  String getLocale() {
    return _prefs.getString(SharedPrefsKeys.locale) ?? 'en';
  }

  @override
  Future<bool> setLocale(String locale) {
    return _prefs.setString(SharedPrefsKeys.locale, locale);
  }

  @override
  String? getSkippedUpdateVersion() {
    return _prefs.getString(SharedPrefsKeys.skippedUpdateVersion);
  }

  @override
  Future<bool> setSkippedUpdateVersion(String version) {
    return _prefs.setString(SharedPrefsKeys.skippedUpdateVersion, version);
  }

  @override
  String? getString(String key) => _prefs.getString(key);

  @override
  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);

  @override
  int? getInt(String key) => _prefs.getInt(key);

  @override
  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);

  @override
  bool getBool(String key, {bool defaultValue = false}) =>
      _prefs.getBool(key) ?? defaultValue;

  @override
  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);

  @override
  double? getDouble(String key) => _prefs.getDouble(key);

  @override
  Future<bool> setDouble(String key, double value) =>
      _prefs.setDouble(key, value);

  @override
  List<String>? getStringList(String key) => _prefs.getStringList(key);

  @override
  Future<bool> setStringList(String key, List<String> value) =>
      _prefs.setStringList(key, value);

  @override
  bool containsKey(String key) => _prefs.containsKey(key);

  @override
  Future<bool> remove(String key) => _prefs.remove(key);

  @override
  Future<bool> clear() => _prefs.clear();

  @override
  Future<void> reload() => _prefs.reload();
}
