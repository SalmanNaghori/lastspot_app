// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'LastSpot';

  @override
  String get appDescription => 'On-Demand Sports & Activity Partner Finder';

  @override
  String get updateNow => 'Update Now';

  @override
  String get maybeLater => 'Maybe Later';

  @override
  String get maintenanceMode => 'Maintenance Mode';

  @override
  String get requestToJoin => 'Request to Join Match';

  @override
  String get publishSpot => 'PUBLISH SPOT TO FEED';

  @override
  String get searchHint => 'Search turfs, sports, players...';

  @override
  String get urgentMatches => 'URGENT MATCHES (STARTING TODAY)';

  @override
  String get recentPosts => 'RECENT POSTS';

  @override
  String get openGroundMap => 'Open Ground Map ↗';

  @override
  String get viewSpot => 'View Spot';

  @override
  String spotsNeeded(Object count) {
    return '$count SPOTS';
  }

  @override
  String spotNeeded(Object count) {
    return '$count SPOT';
  }

  @override
  String hostPrefix(Object name) {
    return 'Host: $name';
  }

  @override
  String get homeTab => 'Home';

  @override
  String get myMatchesTab => 'My Matches';

  @override
  String get profileTab => 'Profile';

  @override
  String get hostMatchTitle => 'Host a Match';

  @override
  String get selectSportCategory => 'Select Sport Category*';

  @override
  String get playersNeeded => 'Players Needed*';

  @override
  String get schedule => 'Schedule*';

  @override
  String get datePrefix => 'Date: ';

  @override
  String get timePrefix => 'Time: ';

  @override
  String get venueDetails => 'Venue Details*';

  @override
  String get venueNameHint => 'Venue Name: e.g. Decathlon Sports Turf';

  @override
  String get mapsLinkHint => 'https://maps.app.goo.gl/... [Paste]';

  @override
  String get mapsGuidance =>
      'Users will tap this to get turn-by-turn directions directly in Google Maps.';

  @override
  String get additionalGuidelines => 'Additional Guidelines (Optional)';

  @override
  String get matchOverviewTitle => 'Match Overview';

  @override
  String statusActiveNeeded(Object count) {
    return 'Status: Active • Needed: $count Players';
  }

  @override
  String hostedBy(Object name) {
    return 'Hosted by $name';
  }

  @override
  String get locationAndDirections => 'LOCATION & DIRECTIONS';

  @override
  String get tapForNavigation => 'Tap below for live navigation';

  @override
  String get openInMaps => '🧭 Open in Google / Apple Maps ↗';

  @override
  String confirmedPlayers(Object current, Object total) {
    return 'CONFIRMED PLAYERS ($current/$total)';
  }

  @override
  String get safetyAndConduct => 'SAFETY & CONDUCT';

  @override
  String get reportActivity => '🚩 Report this activity or host';

  @override
  String get manageMatchRequests => 'Manage Match Requests';

  @override
  String openSpotsRemaining(Object current, Object total) {
    return 'Open Spots Remaining: $current / $total';
  }

  @override
  String pendingRequests(Object count) {
    return 'PENDING REQUESTS ($count)';
  }

  @override
  String get reject => '❌ Reject';

  @override
  String get accept => '✅ Accept';

  @override
  String get openMatchChat => '💬 Open Match Group Chat';

  @override
  String get login => 'Login';

  @override
  String get signup => 'Sign Up';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get fullName => 'Full Name';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get createAccount => 'Create Account';

  @override
  String get joinCommunity => 'Join the community and play.';
}
