import 'package:flutter/foundation.dart';

/// Shared service that bridges Home → Explore category navigation.
///
/// Home taps a category → writes [pendingCategoryId] → navigates to Explore tab.
/// Explore reads [pendingCategoryId] on mount / focus → applies the category filter
/// → clears [pendingCategoryId] to prevent re-applying on future tab switches.
///
/// This avoids duplicated state and is compatible with [StatefulShellRoute.indexedStack]
/// where the Explore branch stays mounted in the background.
class ExploreNavigationService extends ChangeNotifier {
  String? _pendingCategoryId;
  String? _selectedCityId;
  String? _selectedCityName;

  /// Sentinel: explicitly request the "All" filter (clear category).
  static const String kSelectAll = '__all__';

  /// True when a pending category navigation is waiting to be consumed.
  bool get hasPendingNavigation => _pendingCategoryId != null;

  /// The raw pending value (`null` = nothing pending, kSelectAll = clear filter).
  String? get pendingCategoryId => _pendingCategoryId;

  /// The currently synchronized city ID across Home and Explore.
  String? get selectedCityId => _selectedCityId;

  /// The currently synchronized city name across Home and Explore.
  String? get selectedCityName => _selectedCityName;

  /// Called by Home when a category is tapped.
  /// Pass `null` or omit [categoryId] to navigate to Explore with All selected.
  void navigateToCategory(String? categoryId) {
    _pendingCategoryId = categoryId ?? kSelectAll;
    notifyListeners();
  }

  /// Called by Explore once the pending navigation has been applied.
  void consumePendingNavigation() {
    _pendingCategoryId = null;
  }

  /// Synchronize selected city between Home and Explore.
  void updateSelectedCity({required String cityId, required String cityName}) {
    if (_selectedCityId == cityId && _selectedCityName == cityName) return;
    _selectedCityId = cityId;
    _selectedCityName = cityName;
    notifyListeners();
  }
}
