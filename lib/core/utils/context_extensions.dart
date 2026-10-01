import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../l10n/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  /// Quick access to AppLocalizations
  AppLocalizations get loc => AppLocalizations.of(this)!;
}

/// Helper to debounce navigation and avoid duplicate pageKey exceptions in go_router
extension GoRouterNavigationExtension on BuildContext {
  static DateTime? _lastPushTime;

  /// Pushes a location with a 300ms debounce to prevent double-taps causing duplicate page exceptions.
  Future<T?> safePush<T extends Object?>(
    String location, {
    Object? extra,
  }) async {
    final now = DateTime.now();
    if (_lastPushTime != null &&
        now.difference(_lastPushTime!).inMilliseconds < 300) {
      return null; // Debounce
    }
    _lastPushTime = now;
    return push<T>(location, extra: extra);
  }

  /// Navigates to a location with a 300ms debounce to prevent double-taps.
  void safeGo(String location, {Object? extra}) {
    final now = DateTime.now();
    if (_lastPushTime != null &&
        now.difference(_lastPushTime!).inMilliseconds < 300) {
      return; // Debounce
    }
    _lastPushTime = now;
    go(location, extra: extra);
  }
}
