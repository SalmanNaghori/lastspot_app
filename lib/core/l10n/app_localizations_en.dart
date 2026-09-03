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
  String get yourName => 'Your Name';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get createAccount => 'Create Account';

  @override
  String get joinCommunity => 'Join the community and play.';

  @override
  String get navHome => 'Home';

  @override
  String get navExplore => 'Explore';

  @override
  String get navCreate => 'Create';

  @override
  String get navActivities => 'Activities';

  @override
  String get navProfile => 'Profile';

  @override
  String get explorePlaceholderText => 'Discover activities near you';

  @override
  String get activitiesEmptyMessage =>
      'Your activities will appear here.\nActivities you create or join will appear here.';

  @override
  String get exploreActivitiesAction => 'Explore Activities';

  @override
  String get logoutDialogTitle => 'Log out?';

  @override
  String get logoutDialogMessage =>
      'You\'ll need to sign in again to access your LastSpot account.';

  @override
  String get cancel => 'Cancel';

  @override
  String get logout => 'Log Out';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get profileSectionActivity => 'My Activity';

  @override
  String get profileSectionAccount => 'Account';

  @override
  String get profileSectionLegal => 'Legal';

  @override
  String get myRequests => 'My Requests';

  @override
  String get myActivities => 'My Activities';

  @override
  String get notifications => 'Notifications';

  @override
  String get settings => 'Settings';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsConditions => 'Terms & Conditions';

  @override
  String get statCreated => 'Created';

  @override
  String get statJoined => 'Joined';

  @override
  String get statCompleted => 'Completed';

  @override
  String get goodMorning => 'Good morning,';

  @override
  String get goodAfternoon => 'Good afternoon,';

  @override
  String get goodEvening => 'Good evening,';

  @override
  String get whatAreYouUpTo => 'What are you up for today?';

  @override
  String get urgentMatchesSubtitle =>
      'Join nearby activities before they fill up!';

  @override
  String get viewAll => 'View All';

  @override
  String get popularSports => 'Popular Sports';

  @override
  String get popularSportsSubtitle =>
      'Find your favorite sport and join the action';

  @override
  String get nearbyActivities => 'Nearby Activities';

  @override
  String spotsLeft(Object count) {
    return '$count SPOTS LEFT';
  }

  @override
  String get oneSpotLeft => '1 SPOT LEFT';

  @override
  String get perPerson => 'per person';

  @override
  String get filterCricket => 'Cricket';

  @override
  String get filterFootball => 'Football';

  @override
  String get filterBadminton => 'Badminton';

  @override
  String get filterTennis => 'Tennis';

  @override
  String get verifiedHost => 'Host';

  @override
  String get noSpotsFound =>
      'No active spots found.\nBe the first to create one!';

  @override
  String get validationTitleLocationCategory =>
      'Title, Location, and Category are required.';

  @override
  String get activityGeneratedSuccess => 'Activity generated successfully!';

  @override
  String get generateActivity => 'Generate Activity';

  @override
  String get activityImages => 'Activity Images';

  @override
  String get category => 'Category';

  @override
  String get selectCategory => 'Select a category';

  @override
  String get failedToLoadCategories => 'Failed to load categories';

  @override
  String get activityTitle => 'Activity Title';

  @override
  String get activityTitleHint => 'e.g. Sunday Morning Football';

  @override
  String get description => 'Description';

  @override
  String get descriptionHint => 'Share some details about this activity...';

  @override
  String get location => 'Location';

  @override
  String get locationHint => 'e.g. Central Park Turf';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get maxParticipants => 'Max Participants';

  @override
  String get pricePerPerson => 'Price per person (\$)';

  @override
  String get acceptTerms => 'I accept the Terms & Conditions';

  @override
  String get acceptTermsError => 'Please accept the Terms & Conditions';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get loginSubtitle => 'Find your activity partner instantly.';

  @override
  String get dontHaveAccount => 'Don\'t have an account? Sign up';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get passwordResetSent => 'Password reset link sent to your email!';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get resetPasswordDesc =>
      'Enter your email address and we\'ll send you a link to reset your password.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get themeTitle => 'Theme';

  @override
  String get themeSystem => 'System Default';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get languageTitle => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageFrench => 'French';
}
