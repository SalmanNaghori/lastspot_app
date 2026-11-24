import '../../../categories/domain/entities/category.dart';
import '../../../spot/domain/entities/request_entity.dart';
import '../../domain/entities/achievement_entity.dart';
import '../../domain/repositories/achievements_repository.dart';
import '../datasources/achievements_local_datasource.dart';

class AchievementsRepositoryImpl implements AchievementsRepository {
  final AchievementsLocalDataSource _localDataSource;

  AchievementsRepositoryImpl(this._localDataSource);

  static const String idCricket = 'cricket_champion';
  static const String idFootball = 'football_star';
  static const String idEvents = 'event_organizer';
  static const String idBadminton = 'badminton_pro';
  static const String idCreator = 'activity_creator';

  @override
  Future<List<AchievementEntity>> calculateAchievements({
    required String userId,
    required List<RequestEntity> userActivities,
    List<CategoryEntity>? categories,
  }) async {
    // 1. Filter valid activities created by this user
    // Respect business rules: draft or cancelled activities do NOT count.
    // Distinct by ID to prevent duplicate counting on edits.
    final distinctValidActivities = <String, RequestEntity>{};
    for (final activity in userActivities) {
      if (activity.userId == userId &&
          activity.status != RequestStatus.cancelled &&
          activity.status != RequestStatus.draft) {
        distinctValidActivities[activity.id] = activity;
      }
    }

    // 2. Build Category lookup map (id/name/slug -> normalized slug)
    final categoryMap = <String, String>{};
    if (categories != null) {
      for (final cat in categories) {
        final normSlug = cat.slug.toLowerCase().trim();
        categoryMap[cat.id.toLowerCase().trim()] = normSlug;
        categoryMap[cat.name.toLowerCase().trim()] = normSlug;
        categoryMap[normSlug] = normSlug;
      }
    }

    // 3. Count progress per sport / milestone
    int cricketCount = 0;
    int footballCount = 0;
    int eventCount = 0;
    int badmintonCount = 0;
    final totalValidCount = distinctValidActivities.length;

    for (final activity in distinctValidActivities.values) {
      final rawCatId = activity.categoryId.toLowerCase().trim();
      final resolvedSlug = categoryMap[rawCatId] ?? rawCatId;

      if (_isCricket(resolvedSlug, activity.title)) {
        cricketCount++;
      } else if (_isFootball(resolvedSlug, activity.title)) {
        footballCount++;
      } else if (_isEvents(resolvedSlug, activity.title)) {
        eventCount++;
      } else if (_isBadminton(resolvedSlug, activity.title)) {
        badmintonCount++;
      }
    }

    // 4. Fetch celebrated IDs from local storage
    final celebratedIds = await _localDataSource.getCelebratedAchievementIds(
      userId,
    );

    // 5. Build Achievement entities
    return [
      _buildAchievement(
        id: idCricket,
        titleKey: 'achievementCricketChampion',
        descriptionKey: 'achievementCricketChampionDesc',
        categorySlug: 'cricket',
        targetCount: 5,
        currentProgress: cricketCount,
        rewardTitleKey: 'achievementRewardGoldTrophy',
        celebratedIds: celebratedIds,
      ),
      _buildAchievement(
        id: idFootball,
        titleKey: 'achievementFootballStar',
        descriptionKey: 'achievementFootballStarDesc',
        categorySlug: 'football',
        targetCount: 5,
        currentProgress: footballCount,
        rewardTitleKey: 'achievementRewardStarBadge',
        celebratedIds: celebratedIds,
      ),
      _buildAchievement(
        id: idEvents,
        titleKey: 'achievementEventOrganizer',
        descriptionKey: 'achievementEventOrganizerDesc',
        categorySlug: 'events',
        targetCount: 5,
        currentProgress: eventCount,
        rewardTitleKey: 'achievementRewardHostBadge',
        celebratedIds: celebratedIds,
      ),
      _buildAchievement(
        id: idBadminton,
        titleKey: 'achievementBadmintonPro',
        descriptionKey: 'achievementBadmintonProDesc',
        categorySlug: 'badminton',
        targetCount: 5,
        currentProgress: badmintonCount,
        rewardTitleKey: 'achievementRewardAceBadge',
        celebratedIds: celebratedIds,
      ),
      _buildAchievement(
        id: idCreator,
        titleKey: 'achievementActivityCreator',
        descriptionKey: 'achievementActivityCreatorDesc',
        categorySlug: null,
        targetCount: 10,
        currentProgress: totalValidCount,
        rewardTitleKey: 'achievementRewardCreatorTrophy',
        celebratedIds: celebratedIds,
      ),
    ];
  }

  AchievementEntity _buildAchievement({
    required String id,
    required String titleKey,
    required String descriptionKey,
    required String? categorySlug,
    required int targetCount,
    required int currentProgress,
    required String rewardTitleKey,
    required Set<String> celebratedIds,
  }) {
    final isUnlocked = currentProgress >= targetCount;
    return AchievementEntity(
      id: id,
      titleKey: titleKey,
      descriptionKey: descriptionKey,
      categorySlug: categorySlug,
      targetCount: targetCount,
      currentProgress: currentProgress,
      isUnlocked: isUnlocked,
      isCelebrated: celebratedIds.contains(id),
      rewardTitleKey: rewardTitleKey,
    );
  }

  bool _isCricket(String slug, String title) {
    if (slug == 'cricket') return true;
    return title.toLowerCase().contains('cricket');
  }

  bool _isFootball(String slug, String title) {
    if (slug == 'football' || slug == 'soccer') return true;
    final lowerTitle = title.toLowerCase();
    return lowerTitle.contains('football') || lowerTitle.contains('soccer');
  }

  bool _isEvents(String slug, String title) {
    if (slug == 'events' || slug == 'event') return true;
    final lowerTitle = title.toLowerCase();
    return lowerTitle.contains('event') ||
        lowerTitle.contains('tournament') ||
        lowerTitle.contains('meetup');
  }

  bool _isBadminton(String slug, String title) {
    if (slug == 'badminton') return true;
    return title.toLowerCase().contains('badminton');
  }

  @override
  Future<void> markAchievementCelebrated({
    required String userId,
    required String achievementId,
  }) async {
    await _localDataSource.markAchievementCelebrated(userId, achievementId);
  }

  @override
  Future<Set<String>> getCelebratedAchievementIds({
    required String userId,
  }) async {
    return _localDataSource.getCelebratedAchievementIds(userId);
  }
}
