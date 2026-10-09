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
  String todayAt(Object time) {
    return 'Today at $time';
  }

  @override
  String yesterdayAt(Object time) {
    return 'Yesterday at $time';
  }

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
  String get mapLocation => 'Shared map link';

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
  String get comingUp => 'Coming Up';

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
  String get activityGeneratedSuccess => 'Activity Created!';

  @override
  String get generateActivity => 'Create Activity';

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
  String get pricePerPerson => 'Price per person';

  @override
  String get previewActivity => 'Preview Activity';

  @override
  String get publishActivity => 'Publish Activity';

  @override
  String get noCategoriesAvailable => 'No categories available';

  @override
  String get noCitiesFound => 'No cities found';

  @override
  String get createAnother => 'Create Another';

  @override
  String get youAreParticipant1 => 'Current participants: 1 (You)';

  @override
  String get addPhotos => 'Add Photos';

  @override
  String get gallery => 'Gallery';

  @override
  String get camera => 'Camera';

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

  @override
  String get cityRequiredError => 'Please select a city';

  @override
  String get joinCommunitySubtitle =>
      'Join the community and find activities near you.';

  @override
  String get fullNameRequired => 'Full Name is required';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get invalidEmail => 'Enter a valid email';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordLengthError => 'Password must be at least 6 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get cityLabel => 'City *';

  @override
  String get selectCityHint => 'Select your city';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get noInternetError =>
      'No internet connection. Please check your network and try again.';

  @override
  String get setupProfile => 'Setup Profile';

  @override
  String get bioOptional => 'Bio (Optional)';

  @override
  String get sportsPreferences => 'Sports Preferences';

  @override
  String get saveAndContinue => 'Save & Continue';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get cityIsRequired => 'City is required';

  @override
  String get findActivitiesNearYou => 'Find activities near you';

  @override
  String get searchActivitiesHint => 'Search activities...';

  @override
  String get activitiesNearYou => 'Activities near you';

  @override
  String activitiesCount(Object count) {
    return '$count activities';
  }

  @override
  String get couldNotLoadActivities => 'Couldn\'t load activities';

  @override
  String get checkConnectionRetry => 'Check your connection and try again.';

  @override
  String get noActivitiesFound => 'No activities found';

  @override
  String get noActivitiesInArea =>
      'There are no upcoming activities in your area right now.';

  @override
  String get noActivitiesMatchSearch => 'No activities match your search';

  @override
  String get tryDifferentKeyword => 'Try searching with a different keyword.';

  @override
  String get noActivitiesInCategory => 'No activities in this category';

  @override
  String get tryDifferentCategory =>
      'Try selecting \'All\' or a different category.';

  @override
  String get retry => 'Retry';

  @override
  String get allFilter => 'All';

  @override
  String get selectYourCity => 'Select your city';

  @override
  String get filters => 'Filters';

  @override
  String get anyDate => 'Any date';

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get thisWeekend => 'This weekend';

  @override
  String get price => 'Price';

  @override
  String get any => 'Any';

  @override
  String get free => 'Free';

  @override
  String get paid => 'Paid';

  @override
  String get participants => 'Participants';

  @override
  String get spots1to2 => '1–2 spots';

  @override
  String get spots3to5 => '3–5 spots';

  @override
  String get spots5plus => '5+ spots';

  @override
  String get reset => 'Reset';

  @override
  String get applyFilters => 'Apply Filters';

  @override
  String get loading => 'Loading...';

  @override
  String get todaysMatches => 'Today\'s Matches';

  @override
  String get urgentMatchesTitle => 'Urgent Matches';

  @override
  String get tryAgain => 'Try again';

  @override
  String get recommendedForYou => 'Recommended for you';

  @override
  String get newThisWeek => 'New this week';

  @override
  String get city => 'City';

  @override
  String get selectCity => 'Select City';

  @override
  String get edit => 'Edit';

  @override
  String get deleteImageNotSupported =>
      'Deleting existing images is not supported yet.';

  @override
  String get howManyPeopleCanJoin => 'How many people can join?';

  @override
  String get youAreIncluded => 'You are included (1)';

  @override
  String get morning => 'Morning';

  @override
  String get afternoon => 'Afternoon';

  @override
  String get evening => 'Evening';

  @override
  String get night => 'Night';

  @override
  String get pleaseSelectFutureTime => 'Please select a future time';

  @override
  String get supportContactComingSoon => 'Support contact feature coming soon.';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get thisIsHowActivityAppears =>
      'This is how your activity will appear to others.';

  @override
  String get viewOnMap => 'View on Map';

  @override
  String get noPendingRequests => 'No pending requests.';

  @override
  String get matchGroupChat => 'Match Group Chat';

  @override
  String get chatComingSoon => 'Chat coming soon!';

  @override
  String get realtimeMessagingAvailableHere =>
      'Realtime messaging will be available here.';

  @override
  String get pleaseEnterValidPrice => 'Please enter a valid price';

  @override
  String get statusActive => 'Status: Active';

  @override
  String neededPlayers(Object count) {
    return ' • Needed: $count Players';
  }

  @override
  String get openInGoogleMaps => 'Open in Google Maps';

  @override
  String get player => 'Player';

  @override
  String get inviteAFriend => 'Invite a Friend';

  @override
  String get reportThisActivityOrHost => 'Report this activity or host';

  @override
  String get learnAboutSafetyGuidelines => 'Learn about Safety Guidelines';

  @override
  String get manageActivitiesDesc =>
      'Manage the activities you host, joined, or need to review.';

  @override
  String tabMyActivitiesCount(String count) {
    return 'My activities $count';
  }

  @override
  String tabJoinedCount(String count) {
    return 'Joined $count';
  }

  @override
  String tabRequestsCount(String count) {
    return 'Requests $count';
  }

  @override
  String get mockGoldenGateTitle => 'Golden Gate Sunset Walk';

  @override
  String get mockGoldenGateDate => 'Today · 6:00 PM';

  @override
  String get mockGoldenGateLoc => 'Golden Gate Park';

  @override
  String get mockGoldenGateStats => '6/10 participants · FREE';

  @override
  String get mockSunsetVolleyballTitle => 'Sunset beach volleyball';

  @override
  String get mockSunsetVolleyballDate => 'Thu, Jun 20 · 6:30 PM';

  @override
  String get mockSunsetVolleyballLoc => 'Ocean Beach';

  @override
  String get mockRooftopCookingTitle => 'Rooftop cooking class';

  @override
  String get mockRooftopCookingDate => 'Sat, Jun 22 · 6:30 PM';

  @override
  String get mockRooftopCookingLoc => 'Mission District rooftop';

  @override
  String get mockRooftopCookingStats => '8/8 participants · \$24';

  @override
  String get mockSalsaTitle => 'Beginner salsa class';

  @override
  String get mockSalsaDate => 'Sun, Jun 23 · 5:00 PM';

  @override
  String get mockSalsaLoc => 'Mission Dance Hall';

  @override
  String get mockSalsaStats => '2/10 participants · \$12';

  @override
  String get tabPreviewData => 'Tab preview data';

  @override
  String get previewJoined =>
      'Joined · Weekend pottery class · Saturday · 4 participants';

  @override
  String get previewRequests =>
      'Requests · 3 pending join requests · Review now';

  @override
  String get statusHosted => 'Hosted';

  @override
  String get statusFull => 'Full';

  @override
  String get pendingRequest => 'Pending Request';

  @override
  String get joined => 'Joined';

  @override
  String get requestRejected => 'Request Rejected';

  @override
  String get requestCancelled => 'Request Cancelled';

  @override
  String get share => 'Share';

  @override
  String get cancelActivity => 'Cancel Activity';

  @override
  String get closeActivity => 'Close Activity';

  @override
  String get reportActivityAction => 'Report Activity';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get statusExpired => 'Expired';

  @override
  String get emptyHostedTitle => 'No Hosted Activities';

  @override
  String get emptyHostedDesc => 'You haven\'t created any activities yet.';

  @override
  String get emptyJoinedTitle => 'No Joined Activities';

  @override
  String get emptyJoinedDesc => 'You haven\'t joined any activities yet.';

  @override
  String get emptyRequestsTitle => 'No Join Requests';

  @override
  String get emptyRequestsDesc => 'Join requests functionality will be here.';

  @override
  String get aboutSection => 'ABOUT';

  @override
  String get scheduleSection => 'SCHEDULE';

  @override
  String statusLabel(Object status) {
    return 'Status: $status';
  }

  @override
  String get errorUnknownState => 'Error or unknown state';

  @override
  String get reportReasonRequired => 'Please select a reason for reporting.';

  @override
  String get reportSubmittedSuccess =>
      'Report submitted successfully. We will review it shortly.';

  @override
  String get whyReporting => 'Why are you reporting this?';

  @override
  String get additionalDetailsOptional => 'Additional Details (Optional)';

  @override
  String get reportDescHint =>
      'Please provide more details to help us understand...';

  @override
  String get submitReport => 'Submit Report';

  @override
  String get tabReceived => 'Received';

  @override
  String get tabSent => 'Sent';

  @override
  String get noReceivedRequests => 'No received requests yet';

  @override
  String get noSentRequests => 'No sent requests yet';

  @override
  String get emptyReceivedRequestsDesc =>
      'When someone asks to join one of your activities, their request will appear here.';

  @override
  String get emptySentRequestsDesc =>
      'Activities you ask to join will appear here while you wait for a response.';

  @override
  String get accountSuspendedTitle => 'Account Suspended';

  @override
  String get accountSuspendedDesc =>
      'Your account has been temporarily suspended due to a violation of our terms of service.';

  @override
  String get accountBannedTitle => 'Account Banned';

  @override
  String get accountBannedDesc =>
      'Your account has been permanently banned due to severe violations of our policies.';

  @override
  String get accountDeletedTitle => 'Account Deleted';

  @override
  String get accountDeletedDesc =>
      'This account has been deleted. If you believe this is a mistake, please contact support.';

  @override
  String get signOut => 'Sign Out';

  @override
  String get appeal => 'Appeal';

  @override
  String get sportSoccer => 'Soccer';

  @override
  String get sportBasketball => 'Basketball';

  @override
  String get sportTennis => 'Tennis';

  @override
  String get sportVolleyball => 'Volleyball';

  @override
  String get sportBadminton => 'Badminton';

  @override
  String get sportTableTennis => 'Table Tennis';

  @override
  String get sportCricket => 'Cricket';

  @override
  String get sportSwimming => 'Swimming';

  @override
  String get sportRunning => 'Running';

  @override
  String get sportCycling => 'Cycling';

  @override
  String get confirmAction => 'Confirm';

  @override
  String get discoveryHeadline => 'Less scrolling.\nMore playing.';

  @override
  String get discoverySubtitle =>
      'Find your people. Make your next game happen.';

  @override
  String get browseActivities => 'Find a game';

  @override
  String get activityHost => 'Host';

  @override
  String get activityFull => 'Full';

  @override
  String activityCapacity(int current, int total) {
    return '$current of $total joined';
  }

  @override
  String get detailsTitle => 'Activity details';

  @override
  String get detailsAbout => 'About this activity';

  @override
  String get detailsWhen => 'When we play';

  @override
  String get detailsWhere => 'Meet here';

  @override
  String get detailsPlayers => 'Who’s playing';

  @override
  String get detailsNoPlayers => 'The lineup is just getting started.';

  @override
  String get detailsNoPlayersHint =>
      'Confirmed players will appear here once the host accepts their requests.';

  @override
  String get detailsHostedBy => 'Your host';

  @override
  String get detailsJoinHint =>
      'Send a request. The host will confirm your spot.';

  @override
  String get detailsPendingHint =>
      'Your request is with the host. We’ll notify you when they respond.';

  @override
  String get detailsJoinedHint =>
      'You’re on the lineup. Check the time and venue before you head out.';

  @override
  String get detailsHostHint => 'Review join requests and build your lineup.';

  @override
  String get detailsClosed => 'Joining closed';

  @override
  String get detailsDraft => 'Draft';

  @override
  String get detailsOpen => 'Open for players';

  @override
  String get detailsCopy => 'Copy activity details';

  @override
  String get detailsCopied => 'Activity details copied';

  @override
  String get detailsCopyFailed =>
      'Could not copy the details. Please try again.';

  @override
  String get detailsMenu => 'Activity options';

  @override
  String get detailsSafety => 'Play well, together';

  @override
  String get detailsSafetyNote =>
      'Confirm the meeting point with your host, respect other players, and report any concerns.';

  @override
  String get detailsLoadError => 'We couldn’t load this activity.';

  @override
  String get detailsPrice => 'Per person';

  @override
  String get detailsJoin => 'Request to join';

  @override
  String detailsPhotoCount(int current, int total) {
    return '$current / $total';
  }

  @override
  String detailsAvailability(int available, int total) {
    return '$available of $total spots available';
  }

  @override
  String detailsPhotoLabel(int current, int total) {
    return 'Activity photo $current of $total';
  }

  @override
  String get galleryOpen => 'View photos';

  @override
  String get galleryZoomHint => 'Pinch to zoom · Swipe to explore';

  @override
  String get galleryPrevious => 'Previous photo';

  @override
  String get galleryNext => 'Next photo';

  @override
  String get galleryZoomIn => 'Zoom in';

  @override
  String get galleryZoomOut => 'Reset zoom';

  @override
  String get discoveryEyebrow => 'YOUR NEXT GOOD TIME';

  @override
  String get discoveryHost => 'Host an activity';

  @override
  String get detailsSharedMapLink => 'Shared map link';

  @override
  String get detailsMapLinkHint => 'Open the location shared by the host.';

  @override
  String get detailsMapSearchHint =>
      'Search this venue in Maps; confirm the meeting point with your host.';

  @override
  String get detailsOpenMapLink => 'Open map link';

  @override
  String get detailsSearchMaps => 'Search in Maps';

  @override
  String get homeComingUpSubtitle => 'Games over the next 7 days';

  @override
  String get homeLaterOn => 'Later on';

  @override
  String get homeLaterSubtitle => 'Activities after next week';

  @override
  String get detailsMapOpenFailed => 'Could not open Maps. Please try again.';
}
