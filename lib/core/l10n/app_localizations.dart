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
  /// **'Activity generated successfully!'**
  String get activityGeneratedSuccess;

  /// No description provided for @generateActivity.
  ///
  /// In en, this message translates to:
  /// **'Generate Activity'**
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
  /// **'Price per person (\$)'**
  String get pricePerPerson;

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
