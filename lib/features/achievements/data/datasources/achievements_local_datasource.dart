import 'package:lastspot_app/core/base_import.dart';

abstract class AchievementsLocalDataSource {
  Future<Set<String>> getCelebratedAchievementIds(String userId);
  Future<void> markAchievementCelebrated(String userId, String achievementId);
}

class AchievementsLocalDataSourceImpl implements AchievementsLocalDataSource {
  final SharedPrefsUtil _sharedPrefsUtil;

  AchievementsLocalDataSourceImpl(this._sharedPrefsUtil);

  String _getKey(String userId) => 'celebrated_achievements_$userId';

  @override
  Future<Set<String>> getCelebratedAchievementIds(String userId) async {
    final list = _sharedPrefsUtil.getStringList(_getKey(userId));
    if (list == null) return <String>{};
    return list.toSet();
  }

  @override
  Future<void> markAchievementCelebrated(
    String userId,
    String achievementId,
  ) async {
    final current = await getCelebratedAchievementIds(userId);
    if (!current.contains(achievementId)) {
      final updated = Set<String>.from(current)..add(achievementId);
      await _sharedPrefsUtil.setStringList(_getKey(userId), updated.toList());
    }
  }
}
