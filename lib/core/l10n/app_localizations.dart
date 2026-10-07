import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// The name of the application
  ///
  /// In en, this message translates to:
  /// **'LastSpot'**
  String get appName;

  /// No description provided for @todayAt.
  ///
  /// In en, this message translates to:
  /// **'Today at {time}'**
  String todayAt(Object time);

  /// No description provided for @yesterdayAt.
  ///
  /// In en, this message translates to:
  /// **'Yesterday at {time}'**
  String yesterdayAt(Object time);

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'On-Demand Sports & Activity Partner Finder'**
  String get appDescription;

  /// No description provided for @updateNow.
  ///
  /// In en, this message translates to:
  /// **'Update Now'**
  String get updateNow;

  /// No description provided for @maybeLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get maybeLater;

  /// No description provided for @maintenanceMode.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Mode'**
  String get maintenanceMode;

  /// No description provided for @requestToJoin.
  ///
  /// In en, this message translates to:
  /// **'Request to Join Match'**
  String get requestToJoin;

  /// No description provided for @publishSpot.
  ///
  /// In en, this message translates to:
  /// **'PUBLISH SPOT TO FEED'**
  String get publishSpot;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search turfs, sports, players...'**
  String get searchHint;

  /// No description provided for @urgentMatches.
  ///
  /// In en, this message translates to:
  /// **'URGENT MATCHES (STARTING TODAY)'**
  String get urgentMatches;

  /// No description provided for @recentPosts.
  ///
  /// In en, this message translates to:
  /// **'RECENT POSTS'**
  String get recentPosts;

  /// No description provided for @openGroundMap.
  ///
  /// In en, this message translates to:
  /// **'Open Ground Map ↗'**
  String get openGroundMap;

  /// No description provided for @mapLocation.
  ///
  /// In en, this message translates to:
  /// **'Map Location'**
  String get mapLocation;

  /// No description provided for @viewSpot.
  ///
  /// In en, this message translates to:
  /// **'View Spot'**
  String get viewSpot;

  /// No description provided for @spotsNeeded.
  ///
  /// In en, this message translates to:
  /// **'{count} SPOTS'**
  String spotsNeeded(Object count);

  /// No description provided for @spotNeeded.
  ///
  /// In en, this message translates to:
  /// **'{count} SPOT'**
  String spotNeeded(Object count);

  /// No description provided for @hostPrefix.
  ///
  /// In en, this message translates to:
  /// **'Host: {name}'**
  String hostPrefix(Object name);

  /// No description provided for @homeTab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTab;

  /// No description provided for @myMatchesTab.
  ///
  /// In en, this message translates to:
  /// **'My Matches'**
  String get myMatchesTab;

  /// No description provided for @profileTab.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTab;

  /// No description provided for @hostMatchTitle.
  ///
  /// In en, this message translates to:
  /// **'Host a Match'**
  String get hostMatchTitle;

  /// No description provided for @selectSportCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Sport Category*'**
  String get selectSportCategory;

  /// No description provided for @playersNeeded.
  ///
  /// In en, this message translates to:
  /// **'Players Needed*'**
  String get playersNeeded;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule*'**
  String get schedule;

  /// No description provided for @datePrefix.
  ///
  /// In en, this message translates to:
  /// **'Date: '**
  String get datePrefix;

  /// No description provided for @timePrefix.
  ///
  /// In en, this message translates to:
  /// **'Time: '**
  String get timePrefix;

  /// No description provided for @venueDetails.
  ///
  /// In en, this message translates to:
  /// **'Venue Details*'**
  String get venueDetails;

  /// No description provided for @venueNameHint.
  ///
  /// In en, this message translates to:
  /// **'Venue Name: e.g. Decathlon Sports Turf'**
  String get venueNameHint;

  /// No description provided for @mapsLinkHint.
  ///
  /// In en, this message translates to:
  /// **'https://maps.app.goo.gl/... [Paste]'**
  String get mapsLinkHint;

  /// No description provided for @mapsGuidance.
  ///
  /// In en, this message translates to:
  /// **'Users will tap this to get turn-by-turn directions directly in Google Maps.'**
  String get mapsGuidance;

  /// No description provided for @additionalGuidelines.
  ///
  /// In en, this message translates to:
  /// **'Additional Guidelines (Optional)'**
  String get additionalGuidelines;

  /// No description provided for @matchOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Match Overview'**
  String get matchOverviewTitle;

  /// No description provided for @statusActiveNeeded.
  ///
  /// In en, this message translates to:
  /// **'Status: Active • Needed: {count} Players'**
  String statusActiveNeeded(Object count);

  /// No description provided for @hostedBy.
  ///
  /// In en, this message translates to:
  /// **'Hosted by {name}'**
  String hostedBy(Object name);

  /// No description provided for @locationAndDirections.
  ///
  /// In en, this message translates to:
  /// **'LOCATION & DIRECTIONS'**
  String get locationAndDirections;

  /// No description provided for @tapForNavigation.
  ///
  /// In en, this message translates to:
  /// **'Tap below for live navigation'**
  String get tapForNavigation;

  /// No description provided for @openInMaps.
  ///
  /// In en, this message translates to:
  /// **'🧭 Open in Google / Apple Maps ↗'**
  String get openInMaps;

  /// No description provided for @confirmedPlayers.
  ///
  /// In en, this message translates to:
  /// **'CONFIRMED PLAYERS ({current}/{total})'**
  String confirmedPlayers(Object current, Object total);

  /// No description provided for @safetyAndConduct.
  ///
  /// In en, this message translates to:
  /// **'SAFETY & CONDUCT'**
  String get safetyAndConduct;

  /// No description provided for @reportActivity.
  ///
  /// In en, this message translates to:
  /// **'🚩 Report this activity or host'**
  String get reportActivity;

  /// No description provided for @manageMatchRequests.
  ///
  /// In en, this message translates to:
  /// **'Manage Match Requests'**
  String get manageMatchRequests;

  /// No description provided for @openSpotsRemaining.
  ///
  /// In en, this message translates to:
  /// **'Open Spots Remaining: {current} / {total}'**
  String openSpotsRemaining(Object current, Object total);

  /// No description provided for @pendingRequests.
  ///
  /// In en, this message translates to:
  /// **'PENDING REQUESTS ({count})'**
  String pendingRequests(Object count);

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'❌ Reject'**
  String get reject;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'✅ Accept'**
  String get accept;

  /// No description provided for @openMatchChat.
  ///
  /// In en, this message translates to:
  /// **'💬 Open Match Group Chat'**
  String get openMatchChat;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get yourName;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @joinCommunity.
  ///
  /// In en, this message translates to:
  /// **'Join the community and play.'**
  String get joinCommunity;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navExplore;

  /// No description provided for @navCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get navCreate;

  /// No description provided for @navActivities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get navActivities;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @explorePlaceholderText.
  ///
  /// In en, this message translates to:
  /// **'Discover activities near you'**
  String get explorePlaceholderText;

  /// No description provided for @activitiesEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Your activities will appear here.\nActivities you create or join will appear here.'**
  String get activitiesEmptyMessage;

  /// No description provided for @exploreActivitiesAction.
  ///
  /// In en, this message translates to:
  /// **'Explore Activities'**
  String get exploreActivitiesAction;

  /// No description provided for @logoutDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Log out?'**
  String get logoutDialogTitle;

  /// No description provided for @logoutDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ll need to sign in again to access your LastSpot account.'**
  String get logoutDialogMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @profileSectionActivity.
  ///
  /// In en, this message translates to:
  /// **'My Activity'**
  String get profileSectionActivity;

  /// No description provided for @profileSectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profileSectionAccount;

  /// No description provided for @profileSectionLegal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get profileSectionLegal;

  /// No description provided for @myRequests.
  ///
  /// In en, this message translates to:
  /// **'My Requests'**
  String get myRequests;

  /// No description provided for @myActivities.
  ///
  /// In en, this message translates to:
  /// **'My Activities'**
  String get myActivities;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditions;

  /// No description provided for @statCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get statCreated;

  /// No description provided for @statJoined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get statJoined;

  /// No description provided for @statCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statCompleted;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning,'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon,'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening,'**
  String get goodEvening;

  /// No description provided for @whatAreYouUpTo.
  ///
  /// In en, this message translates to:
  /// **'What are you up for today?'**
  String get whatAreYouUpTo;

  /// No description provided for @urgentMatchesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join nearby activities before they fill up!'**
  String get urgentMatchesSubtitle;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @popularSports.
  ///
  /// In en, this message translates to:
  /// **'Popular Sports'**
  String get popularSports;

  /// No description provided for @popularSportsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find your favorite sport and join the action'**
  String get popularSportsSubtitle;

  /// No description provided for @nearbyActivities.
  ///
  /// In en, this message translates to:
  /// **'Nearby Activities'**
  String get nearbyActivities;

  /// No description provided for @comingUp.
  ///
  /// In en, this message translates to:
  /// **'Coming Up'**
  String get comingUp;

  /// No description provided for @spotsLeft.
  ///
  /// In en, this message translates to:
  /// **'{count} SPOTS LEFT'**
  String spotsLeft(Object count);

  /// No description provided for @oneSpotLeft.
  ///
  /// In en, this message translates to:
  /// **'1 SPOT LEFT'**
  String get oneSpotLeft;

  /// No description provided for @perPerson.
  ///
  /// In en, this message translates to:
  /// **'per person'**
  String get perPerson;

  /// No description provided for @filterCricket.
  ///
  /// In en, this message translates to:
  /// **'Cricket'**
  String get filterCricket;

  /// No description provided for @filterFootball.
  ///
  /// In en, this message translates to:
  /// **'Football'**
  String get filterFootball;

  /// No description provided for @filterBadminton.
  ///
  /// In en, this message translates to:
  /// **'Badminton'**
  String get filterBadminton;

  /// No description provided for @filterTennis.
  ///
  /// In en, this message translates to:
  /// **'Tennis'**
  String get filterTennis;

  /// No description provided for @verifiedHost.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get verifiedHost;

  /// No description provided for @noSpotsFound.
  ///
  /// In en, this message translates to:
  /// **'No active spots found.\nBe the first to create one!'**
  String get noSpotsFound;

  /// No description provided for @validationTitleLocationCategory.
  ///
  /// In en, this message translates to:
  /// **'Title, Location, and Category are required.'**
  String get validationTitleLocationCategory;

  /// No description provided for @activityGeneratedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Activity Created!'**
  String get activityGeneratedSuccess;

  /// No description provided for @generateActivity.
  ///
  /// In en, this message translates to:
  /// **'Create Activity'**
  String get generateActivity;

  /// No description provided for @activityImages.
  ///
  /// In en, this message translates to:
  /// **'Activity Images'**
  String get activityImages;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select a category'**
  String get selectCategory;

  /// No description provided for @failedToLoadCategories.
  ///
  /// In en, this message translates to:
  /// **'Failed to load categories'**
  String get failedToLoadCategories;

  /// No description provided for @activityTitle.
  ///
  /// In en, this message translates to:
  /// **'Activity Title'**
  String get activityTitle;

  /// No description provided for @activityTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Sunday Morning Football'**
  String get activityTitleHint;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Share some details about this activity...'**
  String get descriptionHint;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @locationHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Central Park Turf'**
  String get locationHint;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @maxParticipants.
  ///
  /// In en, this message translates to:
  /// **'Max Participants'**
  String get maxParticipants;

  /// No description provided for @pricePerPerson.
  ///
  /// In en, this message translates to:
  /// **'Price per person'**
  String get pricePerPerson;

  /// No description provided for @previewActivity.
  ///
  /// In en, this message translates to:
  /// **'Preview Activity'**
  String get previewActivity;

  /// No description provided for @publishActivity.
  ///
  /// In en, this message translates to:
  /// **'Publish Activity'**
  String get publishActivity;

  /// No description provided for @noCategoriesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No categories available'**
  String get noCategoriesAvailable;

  /// No description provided for @noCitiesFound.
  ///
  /// In en, this message translates to:
  /// **'No cities found'**
  String get noCitiesFound;

  /// No description provided for @createAnother.
  ///
  /// In en, this message translates to:
  /// **'Create Another'**
  String get createAnother;

  /// No description provided for @youAreParticipant1.
  ///
  /// In en, this message translates to:
  /// **'Current participants: 1 (You)'**
  String get youAreParticipant1;

  /// No description provided for @addPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add Photos'**
  String get addPhotos;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @acceptTerms.
  ///
  /// In en, this message translates to:
  /// **'I accept the Terms & Conditions'**
  String get acceptTerms;

  /// No description provided for @acceptTermsError.
  ///
  /// In en, this message translates to:
  /// **'Please accept the Terms & Conditions'**
  String get acceptTermsError;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Find your activity partner instantly.'**
  String get loginSubtitle;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign up'**
  String get dontHaveAccount;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @passwordResetSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent to your email!'**
  String get passwordResetSent;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @resetPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a link to reset your password.'**
  String get resetPasswordDesc;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @themeTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeTitle;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get languageFrench;

  /// No description provided for @cityRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please select a city'**
  String get cityRequiredError;

  /// No description provided for @joinCommunitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join the community and find activities near you.'**
  String get joinCommunitySubtitle;

  /// No description provided for @fullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full Name is required'**
  String get fullNameRequired;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get invalidEmail;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordLengthError.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordLengthError;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @cityLabel.
  ///
  /// In en, this message translates to:
  /// **'City *'**
  String get cityLabel;

  /// No description provided for @selectCityHint.
  ///
  /// In en, this message translates to:
  /// **'Select your city'**
  String get selectCityHint;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @noInternetError.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network and try again.'**
  String get noInternetError;

  /// No description provided for @setupProfile.
  ///
  /// In en, this message translates to:
  /// **'Setup Profile'**
  String get setupProfile;

  /// No description provided for @bioOptional.
  ///
  /// In en, this message translates to:
  /// **'Bio (Optional)'**
  String get bioOptional;

  /// No description provided for @sportsPreferences.
  ///
  /// In en, this message translates to:
  /// **'Sports Preferences'**
  String get sportsPreferences;

  /// No description provided for @saveAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Save & Continue'**
  String get saveAndContinue;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @cityIsRequired.
  ///
  /// In en, this message translates to:
  /// **'City is required'**
  String get cityIsRequired;

  /// No description provided for @findActivitiesNearYou.
  ///
  /// In en, this message translates to:
  /// **'Find activities near you'**
  String get findActivitiesNearYou;

  /// No description provided for @searchActivitiesHint.
  ///
  /// In en, this message translates to:
  /// **'Search activities...'**
  String get searchActivitiesHint;

  /// No description provided for @activitiesNearYou.
  ///
  /// In en, this message translates to:
  /// **'Activities near you'**
  String get activitiesNearYou;

  /// No description provided for @activitiesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} activities'**
  String activitiesCount(Object count);

  /// No description provided for @couldNotLoadActivities.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load activities'**
  String get couldNotLoadActivities;

  /// No description provided for @checkConnectionRetry.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again.'**
  String get checkConnectionRetry;

  /// No description provided for @noActivitiesFound.
  ///
  /// In en, this message translates to:
  /// **'No activities found'**
  String get noActivitiesFound;

  /// No description provided for @noActivitiesInArea.
  ///
  /// In en, this message translates to:
  /// **'There are no upcoming activities in your area right now.'**
  String get noActivitiesInArea;

  /// No description provided for @noActivitiesMatchSearch.
  ///
  /// In en, this message translates to:
  /// **'No activities match your search'**
  String get noActivitiesMatchSearch;

  /// No description provided for @tryDifferentKeyword.
  ///
  /// In en, this message translates to:
  /// **'Try searching with a different keyword.'**
  String get tryDifferentKeyword;

  /// No description provided for @noActivitiesInCategory.
  ///
  /// In en, this message translates to:
  /// **'No activities in this category'**
  String get noActivitiesInCategory;

  /// No description provided for @tryDifferentCategory.
  ///
  /// In en, this message translates to:
  /// **'Try selecting \'All\' or a different category.'**
  String get tryDifferentCategory;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @allFilter.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allFilter;

  /// No description provided for @selectYourCity.
  ///
  /// In en, this message translates to:
  /// **'Select your city'**
  String get selectYourCity;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @anyDate.
  ///
  /// In en, this message translates to:
  /// **'Any date'**
  String get anyDate;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @thisWeekend.
  ///
  /// In en, this message translates to:
  /// **'This weekend'**
  String get thisWeekend;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @any.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get any;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @participants.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get participants;

  /// No description provided for @spots1to2.
  ///
  /// In en, this message translates to:
  /// **'1–2 spots'**
  String get spots1to2;

  /// No description provided for @spots3to5.
  ///
  /// In en, this message translates to:
  /// **'3–5 spots'**
  String get spots3to5;

  /// No description provided for @spots5plus.
  ///
  /// In en, this message translates to:
  /// **'5+ spots'**
  String get spots5plus;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @todaysMatches.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Matches'**
  String get todaysMatches;

  /// No description provided for @urgentMatchesTitle.
  ///
  /// In en, this message translates to:
  /// **'Urgent Matches'**
  String get urgentMatchesTitle;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @recommendedForYou.
  ///
  /// In en, this message translates to:
  /// **'Recommended for you'**
  String get recommendedForYou;

  /// No description provided for @newThisWeek.
  ///
  /// In en, this message translates to:
  /// **'New this week'**
  String get newThisWeek;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @selectCity.
  ///
  /// In en, this message translates to:
  /// **'Select City'**
  String get selectCity;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @deleteImageNotSupported.
  ///
  /// In en, this message translates to:
  /// **'Deleting existing images is not supported yet.'**
  String get deleteImageNotSupported;

  /// No description provided for @howManyPeopleCanJoin.
  ///
  /// In en, this message translates to:
  /// **'How many people can join?'**
  String get howManyPeopleCanJoin;

  /// No description provided for @youAreIncluded.
  ///
  /// In en, this message translates to:
  /// **'You are included (1)'**
  String get youAreIncluded;

  /// No description provided for @morning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morning;

  /// No description provided for @afternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get afternoon;

  /// No description provided for @evening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get evening;

  /// No description provided for @night.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get night;

  /// No description provided for @pleaseSelectFutureTime.
  ///
  /// In en, this message translates to:
  /// **'Please select a future time'**
  String get pleaseSelectFutureTime;

  /// No description provided for @supportContactComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Support contact feature coming soon.'**
  String get supportContactComingSoon;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @thisIsHowActivityAppears.
  ///
  /// In en, this message translates to:
  /// **'This is how your activity will appear to others.'**
  String get thisIsHowActivityAppears;

  /// No description provided for @viewOnMap.
  ///
  /// In en, this message translates to:
  /// **'View on Map'**
  String get viewOnMap;

  /// No description provided for @noPendingRequests.
  ///
  /// In en, this message translates to:
  /// **'No pending requests.'**
  String get noPendingRequests;

  /// No description provided for @matchGroupChat.
  ///
  /// In en, this message translates to:
  /// **'Match Group Chat'**
  String get matchGroupChat;

  /// No description provided for @chatComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Chat coming soon!'**
  String get chatComingSoon;

  /// No description provided for @realtimeMessagingAvailableHere.
  ///
  /// In en, this message translates to:
  /// **'Realtime messaging will be available here.'**
  String get realtimeMessagingAvailableHere;

  /// No description provided for @pleaseEnterValidPrice.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid price'**
  String get pleaseEnterValidPrice;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Status: Active'**
  String get statusActive;

  /// No description provided for @neededPlayers.
  ///
  /// In en, this message translates to:
  /// **' • Needed: {count} Players'**
  String neededPlayers(Object count);

  /// No description provided for @openInGoogleMaps.
  ///
  /// In en, this message translates to:
  /// **'Open in Google Maps'**
  String get openInGoogleMaps;

  /// No description provided for @player.
  ///
  /// In en, this message translates to:
  /// **'Player'**
  String get player;

  /// No description provided for @inviteAFriend.
  ///
  /// In en, this message translates to:
  /// **'Invite a Friend'**
  String get inviteAFriend;

  /// No description provided for @reportThisActivityOrHost.
  ///
  /// In en, this message translates to:
  /// **'Report this activity or host'**
  String get reportThisActivityOrHost;

  /// No description provided for @learnAboutSafetyGuidelines.
  ///
  /// In en, this message translates to:
  /// **'Learn about Safety Guidelines'**
  String get learnAboutSafetyGuidelines;

  /// No description provided for @manageActivitiesDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage the activities you host, joined, or need to review.'**
  String get manageActivitiesDesc;

  /// No description provided for @tabMyActivitiesCount.
  ///
  /// In en, this message translates to:
  /// **'My activities {count}'**
  String tabMyActivitiesCount(String count);

  /// No description provided for @tabJoinedCount.
  ///
  /// In en, this message translates to:
  /// **'Joined {count}'**
  String tabJoinedCount(String count);

  /// No description provided for @tabRequestsCount.
  ///
  /// In en, this message translates to:
  /// **'Requests {count}'**
  String tabRequestsCount(String count);

  /// No description provided for @mockGoldenGateTitle.
  ///
  /// In en, this message translates to:
  /// **'Golden Gate Sunset Walk'**
  String get mockGoldenGateTitle;

  /// No description provided for @mockGoldenGateDate.
  ///
  /// In en, this message translates to:
  /// **'Today · 6:00 PM'**
  String get mockGoldenGateDate;

  /// No description provided for @mockGoldenGateLoc.
  ///
  /// In en, this message translates to:
  /// **'Golden Gate Park'**
  String get mockGoldenGateLoc;

  /// No description provided for @mockGoldenGateStats.
  ///
  /// In en, this message translates to:
  /// **'6/10 participants · FREE'**
  String get mockGoldenGateStats;

  /// No description provided for @mockSunsetVolleyballTitle.
  ///
  /// In en, this message translates to:
  /// **'Sunset beach volleyball'**
  String get mockSunsetVolleyballTitle;

  /// No description provided for @mockSunsetVolleyballDate.
  ///
  /// In en, this message translates to:
  /// **'Thu, Jun 20 · 6:30 PM'**
  String get mockSunsetVolleyballDate;

  /// No description provided for @mockSunsetVolleyballLoc.
  ///
  /// In en, this message translates to:
  /// **'Ocean Beach'**
  String get mockSunsetVolleyballLoc;

  /// No description provided for @mockRooftopCookingTitle.
  ///
  /// In en, this message translates to:
  /// **'Rooftop cooking class'**
  String get mockRooftopCookingTitle;

  /// No description provided for @mockRooftopCookingDate.
  ///
  /// In en, this message translates to:
  /// **'Sat, Jun 22 · 6:30 PM'**
  String get mockRooftopCookingDate;

  /// No description provided for @mockRooftopCookingLoc.
  ///
  /// In en, this message translates to:
  /// **'Mission District rooftop'**
  String get mockRooftopCookingLoc;

  /// No description provided for @mockRooftopCookingStats.
  ///
  /// In en, this message translates to:
  /// **'8/8 participants · \$24'**
  String get mockRooftopCookingStats;

  /// No description provided for @mockSalsaTitle.
  ///
  /// In en, this message translates to:
  /// **'Beginner salsa class'**
  String get mockSalsaTitle;

  /// No description provided for @mockSalsaDate.
  ///
  /// In en, this message translates to:
  /// **'Sun, Jun 23 · 5:00 PM'**
  String get mockSalsaDate;

  /// No description provided for @mockSalsaLoc.
  ///
  /// In en, this message translates to:
  /// **'Mission Dance Hall'**
  String get mockSalsaLoc;

  /// No description provided for @mockSalsaStats.
  ///
  /// In en, this message translates to:
  /// **'2/10 participants · \$12'**
  String get mockSalsaStats;

  /// No description provided for @tabPreviewData.
  ///
  /// In en, this message translates to:
  /// **'Tab preview data'**
  String get tabPreviewData;

  /// No description provided for @previewJoined.
  ///
  /// In en, this message translates to:
  /// **'Joined · Weekend pottery class · Saturday · 4 participants'**
  String get previewJoined;

  /// No description provided for @previewRequests.
  ///
  /// In en, this message translates to:
  /// **'Requests · 3 pending join requests · Review now'**
  String get previewRequests;

  /// No description provided for @statusHosted.
  ///
  /// In en, this message translates to:
  /// **'Hosted'**
  String get statusHosted;

  /// No description provided for @statusFull.
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get statusFull;

  /// No description provided for @pendingRequest.
  ///
  /// In en, this message translates to:
  /// **'Pending Request'**
  String get pendingRequest;

  /// No description provided for @joined.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get joined;

  /// No description provided for @requestRejected.
  ///
  /// In en, this message translates to:
  /// **'Request Rejected'**
  String get requestRejected;

  /// No description provided for @requestCancelled.
  ///
  /// In en, this message translates to:
  /// **'Request Cancelled'**
  String get requestCancelled;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @cancelActivity.
  ///
  /// In en, this message translates to:
  /// **'Cancel Activity'**
  String get cancelActivity;

  /// No description provided for @closeActivity.
  ///
  /// In en, this message translates to:
  /// **'Close Activity'**
  String get closeActivity;

  /// No description provided for @reportActivityAction.
  ///
  /// In en, this message translates to:
  /// **'Report Activity'**
  String get reportActivityAction;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @statusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get statusExpired;

  /// No description provided for @emptyHostedTitle.
  ///
  /// In en, this message translates to:
  /// **'No Hosted Activities'**
  String get emptyHostedTitle;

  /// No description provided for @emptyHostedDesc.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t created any activities yet.'**
  String get emptyHostedDesc;

  /// No description provided for @emptyJoinedTitle.
  ///
  /// In en, this message translates to:
  /// **'No Joined Activities'**
  String get emptyJoinedTitle;

  /// No description provided for @emptyJoinedDesc.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t joined any activities yet.'**
  String get emptyJoinedDesc;

  /// No description provided for @emptyRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Join Requests'**
  String get emptyRequestsTitle;

  /// No description provided for @emptyRequestsDesc.
  ///
  /// In en, this message translates to:
  /// **'Join requests functionality will be here.'**
  String get emptyRequestsDesc;

  /// No description provided for @aboutSection.
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get aboutSection;

  /// No description provided for @scheduleSection.
  ///
  /// In en, this message translates to:
  /// **'SCHEDULE'**
  String get scheduleSection;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status: {status}'**
  String statusLabel(Object status);

  /// No description provided for @errorUnknownState.
  ///
  /// In en, this message translates to:
  /// **'Error or unknown state'**
  String get errorUnknownState;

  /// No description provided for @reportReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a reason for reporting.'**
  String get reportReasonRequired;

  /// No description provided for @reportSubmittedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Report submitted successfully. We will review it shortly.'**
  String get reportSubmittedSuccess;

  /// No description provided for @whyReporting.
  ///
  /// In en, this message translates to:
  /// **'Why are you reporting this?'**
  String get whyReporting;

  /// No description provided for @additionalDetailsOptional.
  ///
  /// In en, this message translates to:
  /// **'Additional Details (Optional)'**
  String get additionalDetailsOptional;

  /// No description provided for @reportDescHint.
  ///
  /// In en, this message translates to:
  /// **'Please provide more details to help us understand...'**
  String get reportDescHint;

  /// No description provided for @submitReport.
  ///
  /// In en, this message translates to:
  /// **'Submit Report'**
  String get submitReport;

  /// No description provided for @tabReceived.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get tabReceived;

  /// No description provided for @tabSent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get tabSent;

  /// No description provided for @noReceivedRequests.
  ///
  /// In en, this message translates to:
  /// **'No received requests.'**
  String get noReceivedRequests;

  /// No description provided for @noSentRequests.
  ///
  /// In en, this message translates to:
  /// **'No sent requests.'**
  String get noSentRequests;

  /// No description provided for @accountSuspendedTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Suspended'**
  String get accountSuspendedTitle;

  /// No description provided for @accountSuspendedDesc.
  ///
  /// In en, this message translates to:
  /// **'Your account has been temporarily suspended due to a violation of our terms of service.'**
  String get accountSuspendedDesc;

  /// No description provided for @accountBannedTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Banned'**
  String get accountBannedTitle;

  /// No description provided for @accountBannedDesc.
  ///
  /// In en, this message translates to:
  /// **'Your account has been permanently banned due to severe violations of our policies.'**
  String get accountBannedDesc;

  /// No description provided for @accountDeletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Deleted'**
  String get accountDeletedTitle;

  /// No description provided for @accountDeletedDesc.
  ///
  /// In en, this message translates to:
  /// **'This account has been deleted. If you believe this is a mistake, please contact support.'**
  String get accountDeletedDesc;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @appeal.
  ///
  /// In en, this message translates to:
  /// **'Appeal'**
  String get appeal;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
