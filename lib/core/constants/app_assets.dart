import 'package:flutter/material.dart';
import '../../gen/assets.gen.dart';

/// Centralized asset management for LastSpot sports design system.
///
/// Backed by flutter_gen code generation (@directory:gen -> lib/gen/assets.gen.dart).
/// Maps categories by stable backend slug identifiers (not localized display names).
/// Provides reliable offline asset paths, fallback icons, soft tints, suggested playing windows, and groupings.
class AppAssets {
  AppAssets._();

  // ============================================================
  // CATEGORY 3D ILLUSTRATIONS (FROM lib/gen/assets.gen.dart)
  // ============================================================
  // Core & Team Sports
  static AssetGenImage get cricketGen => Assets.images.categories.cricket;
  static AssetGenImage get footballGen => Assets.images.categories.football;
  static AssetGenImage get volleyballGen => Assets.images.categories.volleyball;
  static AssetGenImage get basketballGen => Assets.images.categories.basketball;
  static AssetGenImage get hockeyGen => Assets.images.categories.hockey;
  static AssetGenImage get ultimateFrisbeeGen =>
      Assets.images.categories.ultimateFrisbee;
  static AssetGenImage get tugOfWarGen => Assets.images.categories.tugOfWar;

  // Racket Sports
  static AssetGenImage get badmintonGen => Assets.images.categories.badminton;
  static AssetGenImage get tennisGen => Assets.images.categories.tennis;
  static AssetGenImage get tableTennisGen =>
      Assets.images.categories.tableTennis;
  static AssetGenImage get pickleballGen => Assets.images.categories.pickleball;

  // Traditional Gujarat Games
  static AssetGenImage get kabaddiGen => Assets.images.categories.kabaddi;
  static AssetGenImage get khoKhoGen => Assets.images.categories.khoKho;
  static AssetGenImage get gilliDandaGen => Assets.images.categories.gilliDanda;
  static AssetGenImage get satoliyaGen => Assets.images.categories.satoliya;
  static AssetGenImage get lagoriGen => Assets.images.categories.lagori;
  static AssetGenImage get kiteFlyingGen => Assets.images.categories.kiteFlying;

  // Fitness & Adventure
  static AssetGenImage get cyclingGen => Assets.images.categories.cycling;
  static AssetGenImage get runningGen => Assets.images.categories.running;
  static AssetGenImage get skatingGen => Assets.images.categories.skating;
  static AssetGenImage get swimmingGen => Assets.images.categories.swimming;
  static AssetGenImage get hikingGen => Assets.images.categories.hiking;
  static AssetGenImage get outdoorYogaGen =>
      Assets.images.categories.outdoorYoga;

  // Community Activities
  static AssetGenImage get rideSharingGen =>
      Assets.images.categories.rideSharing;
  static AssetGenImage get eventsGen => Assets.images.categories.events;
  static AssetGenImage get otherSportGen => Assets.images.categories.other;

  // Feature & Auth Aliases
  static AssetGenImage get cricketEquipmentGen =>
      Assets.images.categories.cricket;
  static AssetGenImage get footballEquipmentGen =>
      Assets.images.categories.football;
  static AssetGenImage get sportsEquipmentCollectionGen =>
      Assets.images.onboarding.welcomeSportsCollection;
  static AssetGenImage get sportsEquipment3dGen =>
      Assets.images.onboarding.welcomeSportsCollection;

  // Backwards compatibility path getters
  static String get cricket => Assets.images.categories.cricket.path;
  static String get football => Assets.images.categories.football.path;
  static String get volleyball => Assets.images.categories.volleyball.path;
  static String get basketball => Assets.images.categories.basketball.path;
  static String get hockey => Assets.images.categories.hockey.path;
  static String get ultimateFrisbee =>
      Assets.images.categories.ultimateFrisbee.path;
  static String get tugOfWar => Assets.images.categories.tugOfWar.path;
  static String get badminton => Assets.images.categories.badminton.path;
  static String get tennis => Assets.images.categories.tennis.path;
  static String get tableTennis => Assets.images.categories.tableTennis.path;
  static String get pickleball => Assets.images.categories.pickleball.path;
  static String get kabaddi => Assets.images.categories.kabaddi.path;
  static String get khoKho => Assets.images.categories.khoKho.path;
  static String get gilliDanda => Assets.images.categories.gilliDanda.path;
  static String get satoliya => Assets.images.categories.satoliya.path;
  static String get lagori => Assets.images.categories.lagori.path;
  static String get kiteFlying => Assets.images.categories.kiteFlying.path;
  static String get cycling => Assets.images.categories.cycling.path;
  static String get running => Assets.images.categories.running.path;
  static String get skating => Assets.images.categories.skating.path;
  static String get swimming => Assets.images.categories.swimming.path;
  static String get hiking => Assets.images.categories.hiking.path;
  static String get outdoorYoga => Assets.images.categories.outdoorYoga.path;
  static String get rideSharing => Assets.images.categories.rideSharing.path;
  static String get events => Assets.images.categories.events.path;
  static String get otherSport => Assets.images.categories.other.path;

  // ============================================================
  // EMPTY STATES & SYSTEM ILLUSTRATIONS (FROM lib/gen/assets.gen.dart)
  // ============================================================
  static AssetGenImage get emptyActivitiesGen =>
      Assets.images.emptyStates.noActivities;
  static AssetGenImage get emptySearchResultsGen =>
      Assets.images.emptyStates.noSearchResults;
  static AssetGenImage get emptyJoinRequestsGen =>
      Assets.images.emptyStates.noJoinRequests;
  static AssetGenImage get emptyChatsGen => Assets.images.emptyStates.noChats;
  static AssetGenImage get emptyNotificationsGen =>
      Assets.images.emptyStates.noNotifications;
  static AssetGenImage get createSuccessGen =>
      Assets.images.emptyStates.activityCreatedSuccess;

  static String get emptyActivities =>
      Assets.images.emptyStates.noActivities.path;
  static String get emptySearchResults =>
      Assets.images.emptyStates.noSearchResults.path;
  static String get emptyJoinRequests =>
      Assets.images.emptyStates.noJoinRequests.path;
  static String get emptyChats => Assets.images.emptyStates.noChats.path;
  static String get emptyNotifications =>
      Assets.images.emptyStates.noNotifications.path;
  static String get createSuccess =>
      Assets.images.emptyStates.activityCreatedSuccess.path;

  // ============================================================
  // ONBOARDING & WELCOME (FROM lib/gen/assets.gen.dart)
  // ============================================================
  static AssetGenImage get welcomeSportsCollectionGen =>
      Assets.images.onboarding.welcomeSportsCollection;
  static String get welcomeSportsCollection =>
      Assets.images.onboarding.welcomeSportsCollection.path;

  // 3D Activity Hub & Request Icons
  static AssetGenImage get joinRequest3dGen => Assets.icons.joinRequest3d;
  static String get joinRequest3d => Assets.icons.joinRequest3d.path;

  // 3D Activity & Metadata Icons (Fareeq / LastSpot 3D clay aesthetic)
  static AssetGenImage get calendar3dGen => Assets.icons.calendar3d;
  static String get calendar3d => Assets.icons.calendar3d.path;

  static AssetGenImage get locationPin3dGen => Assets.icons.locationPin3d;
  static String get locationPin3d => Assets.icons.locationPin3d.path;

  /// Pigment sampled from the shared pin for theme recoloring only.
  static const locationPinSourceColor = Color.fromARGB(255, 13, 132, 82);

  /// Recolors the green pigment while keeping neutral highlights and alpha.
  static ColorFilter locationPinColorFilter(Color color) {
    final source = locationPinSourceColor;
    final pigment = source.g - source.r;
    final redShift = (color.r - source.r) / pigment;
    final greenShift = (color.g - source.g) / pigment;
    final blueShift = (color.b - source.b) / pigment;
    return ColorFilter.matrix([
      1 - redShift,
      redShift,
      0,
      0,
      0,
      -greenShift,
      1 + greenShift,
      0,
      0,
      0,
      -blueShift,
      blueShift,
      1,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]);
  }

  static AssetGenImage get participants3dGen => Assets.icons.participants3d;
  static String get participants3d => Assets.icons.participants3d.path;

  static AssetGenImage get priceTag3dGen => Assets.icons.priceTag3d;
  static String get priceTag3d => Assets.icons.priceTag3d.path;

  static AssetGenImage get arrowForward3dGen => Assets.icons.arrowForward3d;
  static String get arrowForward3d => Assets.icons.arrowForward3d.path;

  // ============================================================
  // 3D BOTTOM NAVIGATION ICONS (FROM lib/gen/assets.gen.dart)
  // ============================================================
  static AssetGenImage get navHomeGen => Assets.navigation.home3d;
  static AssetGenImage get navExploreGen => Assets.navigation.explore3d;
  static AssetGenImage get navCreateGen => Assets.navigation.create3d;
  static AssetGenImage get navActivitiesGen => Assets.navigation.activities3d;
  static AssetGenImage get navChatsGen => Assets.navigation.chats3d;

  static String get navHome => Assets.navigation.home3d.path;
  static String get navExplore => Assets.navigation.explore3d.path;
  static String get navCreate => Assets.navigation.create3d.path;
  static String get navActivities => Assets.navigation.activities3d.path;
  static String get navChats => Assets.navigation.chats3d.path;

  // ============================================================
  // BRANDING & SPLASH IDENTITY ASSETS (FROM lib/gen/assets.gen.dart)
  // ============================================================
  static AssetGenImage get khelbhaiLauncherMasterGen =>
      Assets.branding.khelbhaiLauncherMaster;
  static AssetGenImage get khelbhaiLogoGen => Assets.branding.khelbhaiLogo;
  static AssetGenImage get khelbhaiLogoWhiteGen =>
      Assets.branding.khelbhaiLogoWhite;

  static String get khelbhaiLauncherMaster =>
      Assets.branding.khelbhaiLauncherMaster.path;
  static String get khelbhaiLogo => Assets.branding.khelbhaiLogo.path;
  static String get khelbhaiLogoWhite => Assets.branding.khelbhaiLogoWhite.path;

  // ============================================================
  // CATEGORY STABLE SLUG MAPPING TO GENERATED ASSETS
  // ============================================================
  static final Map<String, AssetGenImage> _slugToGen = {
    // Team Sports
    'cricket': Assets.images.categories.cricket,
    'football': Assets.images.categories.football,
    'soccer': Assets.images.categories.football,
    'volleyball': Assets.images.categories.volleyball,
    'basketball': Assets.images.categories.basketball,
    'hockey': Assets.images.categories.hockey,
    'field-hockey': Assets.images.categories.hockey,
    'field_hockey': Assets.images.categories.hockey,
    'ultimate-frisbee': Assets.images.categories.ultimateFrisbee,
    'ultimate_frisbee': Assets.images.categories.ultimateFrisbee,
    'frisbee': Assets.images.categories.ultimateFrisbee,
    'tug-of-war': Assets.images.categories.tugOfWar,
    'tug_of_war': Assets.images.categories.tugOfWar,

    // Racket Sports
    'badminton': Assets.images.categories.badminton,
    'tennis': Assets.images.categories.tennis,
    'table-tennis': Assets.images.categories.tableTennis,
    'table_tennis': Assets.images.categories.tableTennis,
    'ping-pong': Assets.images.categories.tableTennis,
    'pickleball': Assets.images.categories.pickleball,

    // Traditional Gujarat Games
    'kabaddi': Assets.images.categories.kabaddi,
    'kho-kho': Assets.images.categories.khoKho,
    'kho_kho': Assets.images.categories.khoKho,
    'khokho': Assets.images.categories.khoKho,
    'gilli-danda': Assets.images.categories.gilliDanda,
    'gilli_danda': Assets.images.categories.gilliDanda,
    'gillidanda': Assets.images.categories.gilliDanda,
    'satoliya': Assets.images.categories.satoliya,
    'lagori': Assets.images.categories.lagori,
    'pithu': Assets.images.categories.satoliya,
    'seven-stones': Assets.images.categories.satoliya,
    'kite-flying': Assets.images.categories.kiteFlying,
    'kite_flying': Assets.images.categories.kiteFlying,
    'patang': Assets.images.categories.kiteFlying,
    'uttarayan': Assets.images.categories.kiteFlying,

    // Fitness & Adventure
    'cycling': Assets.images.categories.cycling,
    'running': Assets.images.categories.running,
    'skating': Assets.images.categories.skating,
    'roller-skating': Assets.images.categories.skating,
    'inline-skating': Assets.images.categories.skating,
    'swimming': Assets.images.categories.swimming,
    'hiking': Assets.images.categories.hiking,
    'trekking': Assets.images.categories.hiking,
    'outdoor-yoga': Assets.images.categories.outdoorYoga,
    'outdoor_yoga': Assets.images.categories.outdoorYoga,
    'yoga': Assets.images.categories.outdoorYoga,

    // Community Activities
    'ride-sharing': Assets.images.categories.rideSharing,
    'ride_sharing': Assets.images.categories.rideSharing,
    'ridesharing': Assets.images.categories.rideSharing,
    'events': Assets.images.categories.events,
    'event': Assets.images.categories.events,
    'other': Assets.images.categories.other,
  };

  static final Map<String, String> _idToSlug = {};
  static final Map<String, String> _idToName = {};
  static final Map<String, String> _slugToName = {};

  /// Dynamically registers category models loaded from Supabase or memory
  /// so that UUIDs map reliably to their 3D assets.
  static void registerCategories(List<dynamic> categories) {
    for (final cat in categories) {
      try {
        final id = (cat.id as String).trim().toLowerCase();
        final slug = (cat.slug as String).trim().toLowerCase();
        final name = (cat.name as String).trim();
        _idToSlug[id] = slug;
        _idToName[id] = name;
        _slugToName[slug] = name;
      } catch (_) {}
    }
  }

  /// Returns the strongly-typed [AssetGenImage] from @directory:gen for a category ID, slug, or title.
  static AssetGenImage getCategoryGen(String? identifierOrTitle) {
    if (identifierOrTitle == null || identifierOrTitle.trim().isEmpty) {
      return Assets.images.categories.other;
    }
    final raw = identifierOrTitle.trim().toLowerCase();

    // 1. Check if it's a registered UUID
    if (_idToSlug.containsKey(raw)) {
      final slug = _idToSlug[raw]!;
      return _slugToGen[slug] ?? Assets.images.categories.other;
    }

    // 2. Direct slug lookup (with hyphens & underscores)
    final normalized = raw.replaceAll('_', '-');
    if (_slugToGen.containsKey(normalized)) {
      return _slugToGen[normalized]!;
    }
    if (_slugToGen.containsKey(raw)) {
      return _slugToGen[raw]!;
    }

    // 3. Smart keyword matching for activity titles & mixed inputs
    final fromKeywords = _detectCategoryFromKeywords(raw);
    if (fromKeywords != null) {
      return fromKeywords;
    }

    return Assets.images.categories.other;
  }

  static AssetGenImage? _detectCategoryFromKeywords(String text) {
    if (text.contains('cricket')) return Assets.images.categories.cricket;
    if (text.contains('football') || text.contains('soccer')) {
      return Assets.images.categories.football;
    }
    if (text.contains('badminton')) return Assets.images.categories.badminton;
    if (text.contains('table tennis') ||
        text.contains('table-tennis') ||
        text.contains('ping pong') ||
        text.contains('ping-pong')) {
      return Assets.images.categories.tableTennis;
    }
    if (text.contains('tennis')) return Assets.images.categories.tennis;
    if (text.contains('pickleball')) return Assets.images.categories.pickleball;
    if (text.contains('volleyball')) return Assets.images.categories.volleyball;
    if (text.contains('basketball')) return Assets.images.categories.basketball;
    if (text.contains('hockey')) return Assets.images.categories.hockey;
    if (text.contains('frisbee')) {
      return Assets.images.categories.ultimateFrisbee;
    }
    if (text.contains('tug of war') || text.contains('tug-of-war')) {
      return Assets.images.categories.tugOfWar;
    }
    if (text.contains('kabaddi')) return Assets.images.categories.kabaddi;
    if (text.contains('kho kho') ||
        text.contains('kho-kho') ||
        text.contains('khokho')) {
      return Assets.images.categories.khoKho;
    }
    if (text.contains('cycling') ||
        text.contains('cycle') ||
        text.contains('bike')) {
      return Assets.images.categories.cycling;
    }
    if (text.contains('running') || text.contains('run')) {
      return Assets.images.categories.running;
    }
    if (text.contains('skating') || text.contains('roller')) {
      return Assets.images.categories.skating;
    }
    if (text.contains('swimming') || text.contains('swim')) {
      return Assets.images.categories.swimming;
    }
    if (text.contains('hiking') || text.contains('trek')) {
      return Assets.images.categories.hiking;
    }
    if (text.contains('yoga')) return Assets.images.categories.outdoorYoga;
    if (text.contains('ride') || text.contains('carpool')) {
      return Assets.images.categories.rideSharing;
    }
    if (text.contains('event')) return Assets.images.categories.events;
    return null;
  }

  /// Resolves user-friendly display name from category ID, slug, or title.
  static String resolveCategoryName(String? categoryIdOrName) {
    if (categoryIdOrName == null || categoryIdOrName.trim().isEmpty) {
      return 'Activity';
    }
    final raw = categoryIdOrName.trim();
    final lower = raw.toLowerCase();

    // Check registered UUID name
    if (_idToName.containsKey(lower)) {
      return _idToName[lower]!;
    }

    // Check registered slug name
    if (_slugToName.containsKey(lower)) {
      return _slugToName[lower]!;
    }

    // If it looks like a raw UUID (36 chars with hyphens), do not display it!
    if (raw.length == 36 && raw.contains('-')) {
      if (_idToSlug.containsKey(lower)) {
        final slug = _idToSlug[lower]!;
        return slug.replaceAll('-', ' ').replaceAll('_', ' ');
      }
      return 'Sport';
    }

    return raw;
  }

  /// Returns the asset path for a category slug, falling back to [otherSport].
  static String getCategoryAsset(String? slug) {
    return getCategoryGen(slug).path;
  }

  /// Fallback Material icon when an asset fails or for small inline indicators.
  static IconData getCategoryFallbackIcon(String? slug) {
    if (slug == null) return Icons.sports;
    final normalized = slug.trim().toLowerCase().replaceAll('_', '-');
    switch (normalized) {
      case 'cricket':
        return Icons.sports_cricket;
      case 'football':
      case 'soccer':
        return Icons.sports_soccer;
      case 'volleyball':
        return Icons.sports_volleyball;
      case 'basketball':
        return Icons.sports_basketball;
      case 'hockey':
      case 'field-hockey':
        return Icons.sports_hockey;
      case 'ultimate-frisbee':
      case 'frisbee':
        return Icons.album;
      case 'tug-of-war':
        return Icons.group_work;
      case 'badminton':
      case 'tennis':
        return Icons.sports_tennis;
      case 'table-tennis':
      case 'ping-pong':
        return Icons.sports_tennis;
      case 'pickleball':
        return Icons.sports_tennis;
      case 'kabaddi':
        return Icons.sports_kabaddi;
      case 'kho-kho':
      case 'khokho':
        return Icons.directions_run;
      case 'gilli-danda':
      case 'gillidanda':
        return Icons.sports;
      case 'satoliya':
      case 'lagori':
      case 'pithu':
        return Icons.filter_hdr;
      case 'kite-flying':
      case 'patang':
      case 'uttarayan':
        return Icons.air;
      case 'cycling':
        return Icons.directions_bike;
      case 'running':
        return Icons.directions_run;
      case 'skating':
      case 'roller-skating':
        return Icons.ice_skating;
      case 'swimming':
        return Icons.pool;
      case 'hiking':
      case 'trekking':
        return Icons.hiking;
      case 'outdoor-yoga':
      case 'yoga':
        return Icons.self_improvement;
      case 'ride-sharing':
      case 'ridesharing':
        return Icons.directions_car;
      case 'events':
      case 'event':
        return Icons.celebration;
      default:
        return Icons.sports;
    }
  }

  /// Warm accent color corresponding to sport category for chips/tags.
  static Color getCategorySoftTint(String? slug) {
    final normalized = slug?.trim().toLowerCase().replaceAll('_', '-');
    switch (normalized) {
      case 'cricket':
        return const Color(0xFFFFEADB); // Warm Peach
      case 'football':
      case 'soccer':
        return const Color(0xFFE0F2FE); // Light Sky Blue
      case 'volleyball':
        return const Color(0xFFFEF3C7); // Warm Yellow
      case 'basketball':
        return const Color(0xFFFFF7ED); // Warm Amber
      case 'hockey':
      case 'field-hockey':
        return const Color(0xFFECFDF5); // Mint Green
      case 'ultimate-frisbee':
      case 'frisbee':
        return const Color(0xFFCCFBF1); // Aqua Teal
      case 'tug-of-war':
        return const Color(0xFFFEF2F2); // Warm Red tint
      case 'badminton':
        return const Color(0xFFF3E8FF); // Soft Lavender
      case 'tennis':
        return const Color(0xFFF5F3FF); // Violet
      case 'table-tennis':
      case 'ping-pong':
        return const Color(0xFFFFEDD5); // Soft Apricot
      case 'pickleball':
        return const Color(0xFFF0FDF4); // Lime Mint
      case 'kabaddi':
        return const Color(0xFFFFEDD5); // Clay Ochre
      case 'kho-kho':
      case 'khokho':
        return const Color(0xFFFEF9C3); // Sun Yellow
      case 'gilli-danda':
      case 'gillidanda':
        return const Color(0xFFFEF3C7); // Teak Wood
      case 'satoliya':
      case 'lagori':
      case 'pithu':
        return const Color(0xFFF1F5F9); // Slate Gray
      case 'kite-flying':
      case 'patang':
      case 'uttarayan':
        return const Color(0xFFFCE7F3); // Festival Rose
      case 'cycling':
        return const Color(0xFFECFDF5); // Forest Mint
      case 'running':
        return const Color(0xFFFFF1F2); // Coral Track
      case 'skating':
        return const Color(0xFFE0F2FE); // Cyan Speed
      case 'swimming':
        return const Color(0xFFE0F2FE); // Pool Blue
      case 'hiking':
      case 'trekking':
        return const Color(0xFFFEFCE8); // Sun Gold Alpine
      case 'outdoor-yoga':
      case 'yoga':
        return const Color(0xFFF0FDFA); // Morning Teal
      case 'ride-sharing':
      case 'ridesharing':
      case 'carpool':
        return const Color(0xFFCCFBF1); // Muted Aqua
      case 'events':
      case 'event':
      case 'tournament':
        return const Color(0xFFFEF9C3); // Pale Yellow
      default:
        return const Color(0xFFF3EFE9); // Warm cream neutral
    }
  }

  /// Logical grouping for categories in Onboarding, Explore, and Create Activity.
  static String getCategoryGroup(String? slug) {
    final normalized = slug?.trim().toLowerCase().replaceAll('_', '-');
    switch (normalized) {
      case 'kabaddi':
      case 'kho-kho':
      case 'khokho':
      case 'gilli-danda':
      case 'gillidanda':
      case 'satoliya':
      case 'lagori':
      case 'pithu':
      case 'kite-flying':
      case 'patang':
      case 'uttarayan':
        return 'Traditional Games';
      case 'cricket':
      case 'football':
      case 'soccer':
      case 'volleyball':
      case 'basketball':
      case 'hockey':
      case 'field-hockey':
      case 'ultimate-frisbee':
      case 'frisbee':
      case 'tug-of-war':
        return 'Team Sports';
      case 'badminton':
      case 'tennis':
      case 'table-tennis':
      case 'ping-pong':
      case 'pickleball':
        return 'Racket Sports';
      case 'cycling':
      case 'running':
      case 'skating':
      case 'swimming':
      case 'hiking':
      case 'trekking':
      case 'outdoor-yoga':
      case 'yoga':
        return 'Fitness & Adventure';
      case 'ride-sharing':
      case 'ridesharing':
      case 'events':
      case 'event':
      case 'other':
      default:
        return 'Community Activities';
    }
  }

  /// Suggested playing windows as optional guidance for activity creators (STEP 9).
  static String getSuggestedPlayingTimes(String? slug) {
    final normalized = slug?.trim().toLowerCase().replaceAll('_', '-');
    switch (normalized) {
      case 'cricket':
        return 'Morning (6:30 AM - 9:30 AM) or Evening (4:30 PM - 7:00 PM)';
      case 'football':
      case 'soccer':
        return 'Morning (6:00 AM - 8:30 AM) or Evening (5:00 PM - 8:00 PM)';
      case 'volleyball':
        return 'Evening (5:00 PM - 7:30 PM)';
      case 'basketball':
        return 'Morning (6:30 AM - 8:30 AM) or Evening (5:30 PM - 8:30 PM)';
      case 'hockey':
      case 'field-hockey':
        return 'Morning (6:30 AM - 8:30 AM) or Evening (5:00 PM - 7:00 PM)';
      case 'badminton':
        return 'Morning (6:00 AM - 9:00 AM) or Evening (6:00 PM - 9:00 PM)';
      case 'tennis':
      case 'table-tennis':
      case 'pickleball':
        return 'Morning (7:00 AM - 9:30 AM) or Evening (5:30 PM - 8:30 PM)';
      case 'kabaddi':
        return 'Early Morning (6:00 AM - 8:00 AM) or Sunset (5:00 PM - 7:00 PM)';
      case 'kho-kho':
      case 'khokho':
        return 'Morning (7:00 AM - 9:00 AM) or Evening (4:30 PM - 6:30 PM)';
      case 'gilli-danda':
      case 'gillidanda':
        return 'Late Afternoon (4:00 PM - 6:30 PM)';
      case 'satoliya':
      case 'lagori':
      case 'pithu':
        return 'Evening (4:30 PM - 7:00 PM)';
      case 'kite-flying':
      case 'patang':
      case 'uttarayan':
        return 'Daylight with suitable wind (11:00 AM - 5:30 PM)';
      case 'cycling':
        return 'Early Morning (5:30 AM - 8:00 AM)';
      case 'running':
        return 'Early Morning (5:30 AM - 7:30 AM)';
      case 'skating':
        return 'Morning (6:00 AM - 8:00 AM) or Smooth Evening (5:30 PM - 7:30 PM)';
      case 'swimming':
        return 'Morning (6:00 AM - 9:00 AM) or Evening (5:00 PM - 8:00 PM)';
      case 'ultimate-frisbee':
      case 'frisbee':
        return 'Late Afternoon with calm breeze (4:30 PM - 6:30 PM)';
      case 'tug-of-war':
        return 'Late Afternoon (4:00 PM - 6:30 PM)';
      case 'hiking':
      case 'trekking':
        return 'Dawn start (5:00 AM - 10:00 AM)';
      case 'outdoor-yoga':
      case 'yoga':
        return 'Sunrise / Early Morning (6:00 AM - 7:30 AM)';
      default:
        return 'Flexible hours / Schedule at your preferred time';
    }
  }
}
