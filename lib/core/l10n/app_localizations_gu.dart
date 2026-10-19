// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get appName => 'ખેલભાઈ';

  @override
  String todayAt(Object time) {
    return 'આજે $time પર';
  }

  @override
  String yesterdayAt(Object time) {
    return 'ગઈકાલે $time પર';
  }

  @override
  String get appDescription => 'ભાઈ, રમવા આવ ને!';

  @override
  String get updateNow => 'હમણાં અપડેટ કરો';

  @override
  String get maybeLater => 'કદાચ પછીથી';

  @override
  String get maintenanceMode => 'જાળવણી મોડ';

  @override
  String get requestToJoin => 'મેચમાં જોડાવા વિનંતી';

  @override
  String get publishSpot => 'ફીડ માટે સ્પોટ પ્રકાશિત કરો';

  @override
  String get searchHint => 'ટર્ફ, રમતગમત, ખેલાડીઓ શોધો...';

  @override
  String get urgentMatches => 'અર્જન્ટ મેચો (આજથી શરૂ થઈ રહી છે)';

  @override
  String get recentPosts => 'તાજેતરની પોસ્ટ્સ';

  @override
  String get openGroundMap => 'જમીનનો નકશો ખોલો ↗';

  @override
  String get mapLocation => 'શેર કરેલ નકશાની લિંક';

  @override
  String get viewSpot => 'સ્પોટ જુઓ';

  @override
  String spotsNeeded(Object count) {
    return '$count સ્પોટ્સ';
  }

  @override
  String spotNeeded(Object count) {
    return '$count સ્પોટ';
  }

  @override
  String hostPrefix(Object name) {
    return 'હોસ્ટ: $name';
  }

  @override
  String get homeTab => 'હોમ';

  @override
  String get myMatchesTab => 'મારા મેચ';

  @override
  String get profileTab => 'પ્રોફાઇલ';

  @override
  String get hostMatchTitle => 'એક મેચ હોસ્ટ કરો';

  @override
  String get selectSportCategory => 'સ્પોર્ટ કેટેગરી પસંદ કરો*';

  @override
  String get playersNeeded => 'ખેલાડીઓની જરૂર છે*';

  @override
  String get schedule => 'સમયપત્રક*';

  @override
  String get datePrefix => 'તારીખ:';

  @override
  String get timePrefix => 'સમય:';

  @override
  String get venueDetails => 'સ્થળની વિગતો*';

  @override
  String get venueNameHint => 'સ્થળનું નામ: દા.ત. ડેકાથલોન સ્પોર્ટ્સ ટર્ફ';

  @override
  String get mapsLinkHint => 'https://maps.app.goo.gl/... [પેસ્ટ કરો]';

  @override
  String get mapsGuidance =>
      'વપરાશકર્તાઓ સીધા Google નકશામાં વારાફરતી દિશા નિર્દેશો મેળવવા માટે આને ટેપ કરશે.';

  @override
  String get additionalGuidelines => 'વધારાની માર્ગદર્શિકા (વૈકલ્પિક)';

  @override
  String get matchOverviewTitle => 'મેચ વિહંગાવલોકન';

  @override
  String statusActiveNeeded(Object count) {
    return 'સ્થિતિ: સક્રિય • જરૂરી: $count ખેલાડીઓ';
  }

  @override
  String hostedBy(Object name) {
    return '$name દ્વારા હોસ્ટ';
  }

  @override
  String get locationAndDirections => 'સ્થાન અને દિશાઓ';

  @override
  String get tapForNavigation => 'લાઈવ નેવિગેશન માટે નીચે ટેપ કરો';

  @override
  String get openInMaps => '🧭 Google / Apple Maps માં ખોલો ↗';

  @override
  String confirmedPlayers(Object current, Object total) {
    return 'કન્ફર્મ્ડ પ્લેયર્સ ($current/$total)';
  }

  @override
  String get safetyAndConduct => 'સલામતી અને આચાર';

  @override
  String get reportActivity => '🚩 આ પ્રવૃત્તિ અથવા હોસ્ટને જાણ કરો';

  @override
  String get manageMatchRequests => 'મેચ વિનંતીઓ મેનેજ કરો';

  @override
  String openSpotsRemaining(Object current, Object total) {
    return 'ઓપન સ્પોટ્સ બાકી: $current / $total';
  }

  @override
  String pendingRequests(Object count) {
    return 'બાકી વિનંતીઓ ($count)';
  }

  @override
  String get reject => 'અસ્વીકાર કરો';

  @override
  String get accept => 'સ્વીકારો';

  @override
  String get openMatchChat => 'મેચ ગ્રુપ ચેટ ખોલો';

  @override
  String get messageHost => 'સંદેશ હોસ્ટ';

  @override
  String get directMessage => 'સીધો સંદેશ';

  @override
  String get groupChat => 'જૂથ ચેટ';

  @override
  String get activity => 'પ્રવૃત્તિ';

  @override
  String get messageHint => 'એક સંદેશ લખો';

  @override
  String get sendMessage => 'સંદેશ મોકલો';

  @override
  String get signInToChat => 'ચેટનો ઉપયોગ કરવા માટે સાઇન ઇન કરો';

  @override
  String get chatEmpty => 'હજુ સુધી કોઈ સંદેશા નથી. વાતચીત શરૂ કરો.';

  @override
  String get messageSendFailed =>
      'સંદેશ મોકલી શકાયો નથી. કૃપા કરીને ફરી પ્રયાસ કરો.';

  @override
  String get login => 'લૉગિન કરો';

  @override
  String get signup => 'સાઇન અપ કરો';

  @override
  String get email => 'ઈમેલ';

  @override
  String get password => 'પાસવર્ડ';

  @override
  String get fullName => 'પૂરું નામ';

  @override
  String get yourName => 'તમારું નામ';

  @override
  String get forgotPassword => 'પાસવર્ડ ભૂલી ગયા છો?';

  @override
  String get createAccount => 'એકાઉન્ટ બનાવો';

  @override
  String get joinCommunity => 'સમુદાયમાં જોડાઓ અને રમો.';

  @override
  String get navHome => 'હોમ';

  @override
  String get navExplore => 'શોધો';

  @override
  String get navCreate => 'બનાવો';

  @override
  String get navActivities => 'પ્રવૃત્તિઓ';

  @override
  String get navChats => 'ચેટ્સ';

  @override
  String get navProfile => 'પ્રોફાઇલ';

  @override
  String get openProfile => 'પ્રોફાઇલ ખોલો';

  @override
  String get searchConversations => 'વાર્તાલાપ શોધો...';

  @override
  String get noConversationsFound => 'કોઈ વાતચીત મળી નથી';

  @override
  String get noConversationsFoundDesc =>
      'તમે જે શોધી રહ્યાં છો તે શોધવા માટે તમારી શોધ અથવા ફિલ્ટરને સમાયોજિત કરવાનો પ્રયાસ કરો.';

  @override
  String get explorePlaceholderText => 'તમારી નજીકની પ્રવૃત્તિઓ શોધો';

  @override
  String get activitiesEmptyMessage =>
      'તમારી પ્રવૃત્તિઓ અહીં દેખાશે.\nતમે બનાવો છો અથવા જોડાશો તે પ્રવૃત્તિઓ અહીં દેખાશે.';

  @override
  String get exploreActivitiesAction => 'પ્રવૃત્તિઓનું અન્વેષણ કરો';

  @override
  String get logoutDialogTitle => 'લૉગ આઉટ કરીએ?';

  @override
  String get logoutDialogMessage =>
      'તમારા ખેલભાઈ એકાઉન્ટને ઍક્સેસ કરવા માટે તમારે ફરીથી સાઇન ઇન કરવાની જરૂર પડશે.';

  @override
  String get cancel => 'રદ કરો';

  @override
  String get logout => 'લોગ આઉટ કરો';

  @override
  String get editProfile => 'પ્રોફાઇલ સંપાદિત કરો';

  @override
  String get profileSectionActivity => 'મારી પ્રવૃત્તિ';

  @override
  String get profileSectionAccount => 'એકાઉન્ટ';

  @override
  String get profileSectionLegal => 'કાનૂની';

  @override
  String get myRequests => 'મારી વિનંતીઓ';

  @override
  String get myActivities => 'મારી પ્રવૃત્તિઓ';

  @override
  String get notifications => 'સૂચનાઓ';

  @override
  String get settings => 'સેટિંગ્સ';

  @override
  String get helpSupport => 'મદદ અને આધાર';

  @override
  String get privacyPolicy => 'ગોપનીયતા નીતિ';

  @override
  String get termsConditions => 'નિયમો અને શરતો';

  @override
  String get statCreated => 'બનાવ્યું';

  @override
  String get statJoined => 'જોડાયા';

  @override
  String get statCompleted => 'પૂર્ણ થયું';

  @override
  String get goodMorning => 'શુભ સવાર';

  @override
  String get goodAfternoon => 'શુભ બપોર';

  @override
  String get goodEvening => 'શુભ સાંજ';

  @override
  String get whatAreYouUpTo => 'તમે આજે શું માટે તૈયાર છો?';

  @override
  String get urgentMatchesSubtitle =>
      'તેઓ ભરાય તે પહેલાં નજીકની પ્રવૃત્તિઓમાં જોડાઓ!';

  @override
  String get viewAll => 'બધા જુઓ';

  @override
  String get popularSports => 'લોકપ્રિય રમતો';

  @override
  String get popularSportsSubtitle =>
      'તમારી મનપસંદ રમત શોધો અને ક્રિયામાં જોડાઓ';

  @override
  String get sportsCarouselHint =>
      'રમતગમતનું અન્વેષણ કરવા માટે સ્વાઇપ કરો · પ્રવૃત્તિઓ જોવા માટે ટૅપ કરો';

  @override
  String get searchCityHint => 'શહેર અથવા રાજ્ય શોધો...';

  @override
  String get nearbyActivities => 'નજીકની પ્રવૃત્તિઓ';

  @override
  String get comingUp => 'કમિંગ અપ';

  @override
  String spotsLeft(Object count) {
    return '$count સ્પોટ્સ ડાબે';
  }

  @override
  String get oneSpotLeft => '1 સ્પોટ ડાબે';

  @override
  String get perPerson => 'વ્યક્તિ દીઠ';

  @override
  String get filterCricket => 'ક્રિકેટ';

  @override
  String get filterFootball => 'ફૂટબૉલ';

  @override
  String get filterBadminton => 'બેડમિન્ટન';

  @override
  String get filterTennis => 'ટેનિસ';

  @override
  String get verifiedHost => 'યજમાન';

  @override
  String get noSpotsFound =>
      'કોઈ સક્રિય સ્થળો મળ્યાં નથી.\nએક બનાવનાર પ્રથમ બનો!';

  @override
  String get validationTitleLocationCategory =>
      'શીર્ષક, સ્થાન અને શ્રેણી જરૂરી છે.';

  @override
  String get activityGeneratedSuccess => 'પ્રવૃત્તિ બનાવી!';

  @override
  String get generateActivity => 'પ્રવૃત્તિ બનાવો';

  @override
  String get activityImages => 'પ્રવૃત્તિ છબીઓ';

  @override
  String get category => 'શ્રેણી';

  @override
  String get selectCategory => 'શ્રેણી પસંદ કરો';

  @override
  String get failedToLoadCategories => 'શ્રેણીઓ લોડ કરવામાં નિષ્ફળ';

  @override
  String get activityTitle => 'પ્રવૃત્તિ શીર્ષક';

  @override
  String get activityTitleHint => 'દા.ત. સન્ડે મોર્નિંગ ફૂટબોલ';

  @override
  String get description => 'વર્ણન';

  @override
  String get descriptionHint => 'આ પ્રવૃત્તિ વિશે કેટલીક વિગતો શેર કરો...';

  @override
  String get location => 'સ્થાન';

  @override
  String get locationHint => 'દા.ત. સેન્ટ્રલ પાર્ક ટર્ફ';

  @override
  String get date => 'તારીખ';

  @override
  String get time => 'સમય';

  @override
  String get maxParticipants => 'મહત્તમ સહભાગીઓ';

  @override
  String get pricePerPerson => 'વ્યક્તિ દીઠ કિંમત';

  @override
  String get previewActivity => 'પૂર્વાવલોકન પ્રવૃત્તિ';

  @override
  String get publishActivity => 'પ્રવૃત્તિ પ્રકાશિત કરો';

  @override
  String get noCategoriesAvailable => 'કોઈ શ્રેણીઓ ઉપલબ્ધ નથી';

  @override
  String get noCitiesFound => 'કોઈ શહેરો મળ્યાં નથી';

  @override
  String get createAnother => 'બીજું બનાવો';

  @override
  String get youAreParticipant1 => 'વર્તમાન સહભાગીઓ: 1 (તમે)';

  @override
  String get addPhotos => 'ફોટા ઉમેરો';

  @override
  String get gallery => 'ગેલેરી';

  @override
  String get camera => 'કેમેરા';

  @override
  String get acceptTerms => 'હું નિયમો અને શરતો સ્વીકારું છું';

  @override
  String get acceptTermsError => 'કૃપા કરીને નિયમો અને શરતો સ્વીકારો';

  @override
  String get confirmPassword => 'પાસવર્ડની પુષ્ટિ કરો';

  @override
  String get loginSubtitle => 'તમારા પ્રવૃત્તિ ભાગીદારને તરત જ શોધો.';

  @override
  String get dontHaveAccount => 'ખાતું નથી? સાઇન અપ કરો';

  @override
  String get sendResetLink => 'રીસેટ લિંક મોકલો';

  @override
  String get passwordResetSent =>
      'પાસવર્ડ રીસેટ લિંક તમારા ઇમેઇલ પર મોકલવામાં આવી છે!';

  @override
  String get resetPassword => 'પાસવર્ડ રીસેટ કરો';

  @override
  String get resetPasswordDesc =>
      'તમારું ઇમેઇલ સરનામું દાખલ કરો અને અમે તમને તમારો પાસવર્ડ રીસેટ કરવા માટે એક લિંક મોકલીશું.';

  @override
  String get settingsTitle => 'સેટિંગ્સ';

  @override
  String get themeTitle => 'થીમ';

  @override
  String get appColorTitle => 'એપ્લિકેશન રંગ';

  @override
  String get themeSystem => 'સિસ્ટમ ડિફૉલ્ટ';

  @override
  String get themeLight => 'લાઇટ';

  @override
  String get themeDark => 'ડાર્ક';

  @override
  String get languageTitle => 'ભાષા';

  @override
  String get languageEnglish => 'અંગ્રેજી';

  @override
  String get languageHindi => 'હિન્દી';

  @override
  String get languageGujarati => 'ગુજરાતી';

  @override
  String get cityRequiredError => 'કૃપા કરીને એક શહેર પસંદ કરો';

  @override
  String get joinCommunitySubtitle =>
      'સમુદાયમાં જોડાઓ અને તમારી નજીકની પ્રવૃત્તિઓ શોધો.';

  @override
  String get fullNameRequired => 'પૂરું નામ જરૂરી છે';

  @override
  String get emailRequired => 'ઇમેઇલ આવશ્યક છે';

  @override
  String get invalidEmail => 'માન્ય ઇમેઇલ દાખલ કરો';

  @override
  String get passwordRequired => 'પાસવર્ડ જરૂરી છે';

  @override
  String get passwordLengthError => 'પાસવર્ડ ઓછામાં ઓછો 6 અક્ષરનો હોવો જોઈએ';

  @override
  String get passwordsDoNotMatch => 'પાસવર્ડ મેળ ખાતા નથી';

  @override
  String get cityLabel => 'શહેર*';

  @override
  String get selectCityHint => 'તમારું શહેર પસંદ કરો';

  @override
  String get alreadyHaveAccount => 'પહેલેથી એકાઉન્ટ છે?';

  @override
  String get noInternetError =>
      'ઇન્ટરનેટ કનેક્શન નથી. કૃપા કરીને તમારું નેટવર્ક તપાસો અને ફરી પ્રયાસ કરો.';

  @override
  String get setupProfile => 'સેટઅપ પ્રોફાઇલ';

  @override
  String get bioOptional => 'બાયો (વૈકલ્પિક)';

  @override
  String get sportsPreferences => 'રમતગમતની પસંદગીઓ';

  @override
  String get saveAndContinue => 'સાચવો અને ચાલુ રાખો';

  @override
  String get saveChanges => 'ફેરફારો સાચવો';

  @override
  String get cityIsRequired => 'શહેર જરૂરી છે';

  @override
  String get findActivitiesNearYou => 'તમારી નજીકની પ્રવૃત્તિઓ શોધો';

  @override
  String get searchActivitiesHint => 'શોધ પ્રવૃત્તિઓ...';

  @override
  String get activitiesNearYou => 'તમારી નજીકની પ્રવૃત્તિઓ';

  @override
  String activitiesCount(Object count) {
    return '$count પ્રવૃત્તિઓ';
  }

  @override
  String get couldNotLoadActivities => 'પ્રવૃત્તિઓ લોડ કરી શકાઈ નથી';

  @override
  String get checkConnectionRetry => 'તમારું કનેક્શન તપાસો અને ફરી પ્રયાસ કરો.';

  @override
  String get noActivitiesFound => 'કોઈ પ્રવૃત્તિઓ મળી નથી';

  @override
  String get noActivitiesInArea =>
      'તમારા વિસ્તારમાં અત્યારે કોઈ આગામી પ્રવૃત્તિઓ નથી.';

  @override
  String get noActivitiesMatchSearch =>
      'કોઈ પ્રવૃત્તિઓ તમારી શોધ સાથે મેળ ખાતી નથી';

  @override
  String get tryDifferentKeyword => 'કોઈ અલગ કીવર્ડ સાથે શોધવાનો પ્રયાસ કરો.';

  @override
  String get noActivitiesInCategory => 'આ શ્રેણીમાં કોઈ પ્રવૃત્તિઓ નથી';

  @override
  String get tryDifferentCategory =>
      '\'બધા\' અથવા અલગ શ્રેણી પસંદ કરવાનો પ્રયાસ કરો.';

  @override
  String get retry => 'ફરી પ્રયાસ કરો';

  @override
  String get allFilter => 'બધા';

  @override
  String get selectYourCity => 'તમારું શહેર પસંદ કરો';

  @override
  String get filters => 'ફિલ્ટર્સ';

  @override
  String get anyDate => 'કોઈપણ તારીખ';

  @override
  String get today => 'આજે';

  @override
  String get tomorrow => 'કાલે';

  @override
  String get thisWeekend => 'આ સપ્તાહમાં';

  @override
  String get price => 'કિંમત';

  @override
  String get any => 'કોઈપણ';

  @override
  String get free => 'મફત';

  @override
  String get paid => 'ચૂકવેલ';

  @override
  String get participants => 'સહભાગીઓ';

  @override
  String get spots1to2 => '1-2 ફોલ્લીઓ';

  @override
  String get spots3to5 => '3-5 ફોલ્લીઓ';

  @override
  String get spots5plus => '5+ સ્પોટ';

  @override
  String get reset => 'રીસેટ કરો';

  @override
  String get applyFilters => 'ફિલ્ટર્સ લાગુ કરો';

  @override
  String get loading => 'લોડ કરી રહ્યું છે...';

  @override
  String get todaysMatches => 'આજની મેચો';

  @override
  String get urgentMatchesTitle => 'અર્જન્ટ મેચો';

  @override
  String get tryAgain => 'ફરી પ્રયાસ કરો';

  @override
  String get recommendedForYou => 'તમારા માટે ભલામણ કરેલ';

  @override
  String get newThisWeek => 'આ અઠવાડિયે નવું';

  @override
  String get city => 'શહેર';

  @override
  String get selectCity => 'શહેર પસંદ કરો';

  @override
  String get edit => 'સંપાદિત કરો';

  @override
  String get deleteImageNotSupported =>
      'હાલની છબીઓ કાઢી નાખવાનું હજી સુધી સમર્થિત નથી.';

  @override
  String get howManyPeopleCanJoin => 'કેટલા લોકો જોડાઈ શકે છે?';

  @override
  String get youAreIncluded => 'તમે શામેલ છો (1)';

  @override
  String get morning => 'સવાર';

  @override
  String get afternoon => 'બપોર';

  @override
  String get evening => 'સાંજ';

  @override
  String get night => 'રાત્રિ';

  @override
  String get pleaseSelectFutureTime => 'કૃપા કરીને ભાવિ સમય પસંદ કરો';

  @override
  String get supportContactComingSoon =>
      'સપોર્ટ સંપર્ક સુવિધા ટૂંક સમયમાં આવી રહી છે.';

  @override
  String get contactSupport => 'સપોર્ટનો સંપર્ક કરો';

  @override
  String get thisIsHowActivityAppears =>
      'આ રીતે તમારી પ્રવૃત્તિ અન્ય લોકોને દેખાશે.';

  @override
  String get viewOnMap => 'નકશા પર જુઓ';

  @override
  String get noPendingRequests => 'કોઈ બાકી વિનંતીઓ નથી.';

  @override
  String get matchGroupChat => 'ગ્રુપ ચેટ મેચ કરો';

  @override
  String get chatComingSoon => 'ચેટ ટૂંક સમયમાં આવી રહી છે!';

  @override
  String get realtimeMessagingAvailableHere =>
      'રીયલ ટાઇમ મેસેજિંગ અહીં ઉપલબ્ધ રહેશે.';

  @override
  String get pleaseEnterValidPrice => 'કૃપા કરીને માન્ય કિંમત દાખલ કરો';

  @override
  String get statusActive => 'સ્થિતિ: સક્રિય';

  @override
  String neededPlayers(Object count) {
    return '• જરૂરી: $count પ્લેયર્સ';
  }

  @override
  String get openInGoogleMaps => 'Google Maps માં ખોલો';

  @override
  String get player => 'પ્લેયર';

  @override
  String get inviteAFriend => 'મિત્રને આમંત્રણ આપો';

  @override
  String get reportThisActivityOrHost => 'આ પ્રવૃત્તિ અથવા હોસ્ટની જાણ કરો';

  @override
  String get learnAboutSafetyGuidelines => 'સલામતી દિશાનિર્દેશો વિશે જાણો';

  @override
  String get manageActivitiesDesc =>
      'તમે હોસ્ટ કરો છો, જોડાયા છો અથવા સમીક્ષા કરવાની જરૂર છે તે પ્રવૃત્તિઓનું સંચાલન કરો.';

  @override
  String tabMyActivitiesCount(String count) {
    return 'મારી પ્રવૃત્તિઓ $count';
  }

  @override
  String tabJoinedCount(String count) {
    return '$count માં જોડાયા';
  }

  @override
  String tabRequestsCount(String count) {
    return '$count વિનંતી કરે છે';
  }

  @override
  String get tabChats => 'ચેટ્સ';

  @override
  String tabChatsCount(String count) {
    return 'ચેટ્સ $count';
  }

  @override
  String get noConversations => 'હજુ સુધી કોઈ વાતચીત નથી';

  @override
  String get noConversationsDesc =>
      'અન્ય ખેલાડીઓ સાથે ચેટિંગ શરૂ કરવા માટે કોઈ પ્રવૃત્તિમાં જોડાઓ અથવા હોસ્ટ કરો.';

  @override
  String get conversationLoadError =>
      'વાર્તાલાપ લોડ કરી શકાયા નથી. કૃપા કરીને ફરી પ્રયાસ કરો.';

  @override
  String get yesterday => 'ગઈકાલે';

  @override
  String get messageCopied => 'સંદેશ કૉપિ કર્યો';

  @override
  String get jumpToLatest => 'નવીનતમ પર જાઓ';

  @override
  String get newMessage => 'નવો સંદેશ';

  @override
  String activityContext(String title) {
    return 'પ્રવૃત્તિ: $title';
  }

  @override
  String get filterAll => 'બધા';

  @override
  String get filterDirect => 'પ્રત્યક્ષ';

  @override
  String get filterGroups => 'જૂથો';

  @override
  String get groupInfoTitle => 'જૂથ માહિતી';

  @override
  String get groupInfoParticipants => 'સહભાગીઓ';

  @override
  String get groupInfoHost => 'યજમાન';

  @override
  String get groupInfoOrganizer => 'આયોજક';

  @override
  String get groupInfoNoParticipants => 'હજી સુધી કોઈ પુષ્ટિ થયેલ સહભાગીઓ નથી.';

  @override
  String get groupInfoActivityDetails => 'પ્રવૃત્તિ વિગતો';

  @override
  String welcomeToActivity(String activityTitle, String emoji) {
    return '$activityTitle માં આપનું સ્વાગત છે! $emoji';
  }

  @override
  String get groupWelcomeSubtitle =>
      'આ જૂથ પ્રવૃત્તિના સંકલન માટે છે. આદર બનો અને આનંદ કરો!';

  @override
  String get groupOnlyParticipantsCanChat =>
      'માત્ર પુષ્ટિ થયેલ સહભાગીઓ અને હોસ્ટ સંદેશા મોકલી શકે છે.';

  @override
  String get noGroupConversations => 'હજી સુધી કોઈ જૂથ ચેટ નથી';

  @override
  String get noGroupConversationsDesc =>
      'સહભાગીઓ સાથે ચેટિંગ શરૂ કરવા માટે કોઈ પ્રવૃત્તિમાં જોડાઓ અથવા હોસ્ટ કરો.';

  @override
  String get noDirectConversations => 'હજુ સુધી કોઈ સીધા સંદેશા નથી';

  @override
  String get noDirectConversationsDesc =>
      'તમારી અને પ્રવૃત્તિ હોસ્ટ વચ્ચેના સીધા સંદેશા અહીં દેખાશે.';

  @override
  String get you => 'તમે';

  @override
  String get mockGoldenGateTitle => 'ગોલ્ડન ગેટ સનસેટ વોક';

  @override
  String get mockGoldenGateDate => 'આજે · 6:00 PM';

  @override
  String get mockGoldenGateLoc => 'ગોલ્ડન ગેટ પાર્ક';

  @override
  String get mockGoldenGateStats => '6/10 સહભાગીઓ · મફત';

  @override
  String get mockSunsetVolleyballTitle => 'સૂર્યાસ્ત બીચ વોલીબોલ';

  @override
  String get mockSunsetVolleyballDate => 'ગુરુ, જૂન 20 · સાંજે 6:30 વાગ્યે';

  @override
  String get mockSunsetVolleyballLoc => 'મહાસાગર બીચ';

  @override
  String get mockRooftopCookingTitle => 'છત પર રસોઈ વર્ગ';

  @override
  String get mockRooftopCookingDate => 'શનિ, 22 જૂન · 6:30 PM';

  @override
  String get mockRooftopCookingLoc => 'મિશન જિલ્લા છત';

  @override
  String get mockRooftopCookingStats => '8/8 સહભાગીઓ · \$24';

  @override
  String get mockSalsaTitle => 'પ્રારંભિક સાલસા વર્ગ';

  @override
  String get mockSalsaDate => 'રવિ, જૂન 23 · સાંજે 5:00 PM';

  @override
  String get mockSalsaLoc => 'મિશન ડાન્સ હોલ';

  @override
  String get mockSalsaStats => '2/10 સહભાગીઓ · \$12';

  @override
  String get tabPreviewData => 'ટેબ પૂર્વાવલોકન ડેટા';

  @override
  String get previewJoined =>
      'જોડાયા · વીકએન્ડ પોટરી ક્લાસ · શનિવાર · 4 સહભાગીઓ';

  @override
  String get previewRequests =>
      'વિનંતીઓ · 3 બાકી જોડાવાની વિનંતીઓ · હમણાં સમીક્ષા કરો';

  @override
  String get statusHosted => 'યજમાન';

  @override
  String get statusFull => 'સંપૂર્ણ';

  @override
  String get pendingRequest => 'બાકી વિનંતી';

  @override
  String get joined => 'જોડાયા';

  @override
  String get requestRejected => 'વિનંતી નકારી';

  @override
  String get requestCancelled => 'વિનંતી રદ કરી';

  @override
  String get share => 'શેર કરો';

  @override
  String get cancelActivity => 'પ્રવૃત્તિ રદ કરો';

  @override
  String get closeActivity => 'પ્રવૃત્તિ બંધ કરો';

  @override
  String get reportActivityAction => 'પ્રવૃત્તિની જાણ કરો';

  @override
  String get statusCompleted => 'પૂર્ણ થયું';

  @override
  String get statusCancelled => 'રદ કરેલ';

  @override
  String get statusExpired => 'સમાપ્ત';

  @override
  String get emptyHostedTitle => 'કોઈ હોસ્ટ કરેલી પ્રવૃત્તિઓ નથી';

  @override
  String get emptyHostedDesc => 'તમે હજુ સુધી કોઈ પ્રવૃત્તિઓ બનાવી નથી.';

  @override
  String get emptyJoinedTitle => 'કોઈ જોડાઈ પ્રવૃત્તિઓ';

  @override
  String get emptyJoinedDesc => 'તમે હજુ સુધી કોઈપણ પ્રવૃત્તિઓમાં જોડાયા નથી.';

  @override
  String get emptyRequestsTitle => 'કોઈ જોડાવા વિનંતીઓ નથી';

  @override
  String get emptyRequestsDesc => 'જોડાવા વિનંતીઓ કાર્યક્ષમતા અહીં હશે.';

  @override
  String get aboutSection => 'વિશે';

  @override
  String get scheduleSection => 'શેડ્યૂલ';

  @override
  String statusLabel(Object status) {
    return 'સ્થિતિ: $status';
  }

  @override
  String get errorUnknownState => 'ભૂલ અથવા અજાણી સ્થિતિ';

  @override
  String get reportReasonRequired =>
      'કૃપા કરીને જાણ કરવા માટેનું કારણ પસંદ કરો.';

  @override
  String get reportSubmittedSuccess =>
      'રિપોર્ટ સફળતાપૂર્વક સબમિટ કર્યો. અમે ટૂંક સમયમાં તેની સમીક્ષા કરીશું.';

  @override
  String get whyReporting => 'તમે આની જાણ કેમ કરી રહ્યા છો?';

  @override
  String get additionalDetailsOptional => 'વધારાની વિગતો (વૈકલ્પિક)';

  @override
  String get reportDescHint =>
      'અમને સમજવામાં મદદ કરવા કૃપા કરીને વધુ વિગતો આપો...';

  @override
  String get submitReport => 'રિપોર્ટ સબમિટ કરો';

  @override
  String get tabReceived => 'પ્રાપ્ત';

  @override
  String get tabSent => 'મોકલેલ';

  @override
  String get noReceivedRequests => 'હજુ સુધી કોઈ વિનંતીઓ પ્રાપ્ત થઈ નથી';

  @override
  String get noSentRequests => 'હજુ સુધી કોઈ મોકલેલ વિનંતીઓ નથી';

  @override
  String get emptyReceivedRequestsDesc =>
      'જ્યારે કોઈ તમારી પ્રવૃત્તિઓમાં જોડાવાનું કહેશે, ત્યારે તેમની વિનંતી અહીં દેખાશે.';

  @override
  String get emptySentRequestsDesc =>
      'જ્યારે તમે પ્રતિસાદની રાહ જુઓ ત્યારે તમે જોડાવા માટે કહો છો તે પ્રવૃત્તિઓ અહીં દેખાશે.';

  @override
  String get accountSuspendedTitle => 'એકાઉન્ટ સસ્પેન્ડ કર્યું';

  @override
  String get accountSuspendedDesc =>
      'અમારી સેવાની શરતોના ઉલ્લંઘનને કારણે તમારું એકાઉન્ટ અસ્થાયી રૂપે સસ્પેન્ડ કરવામાં આવ્યું છે.';

  @override
  String get accountBannedTitle => 'એકાઉન્ટ પ્રતિબંધિત';

  @override
  String get accountBannedDesc =>
      'અમારી નીતિઓના ગંભીર ઉલ્લંઘનને કારણે તમારું એકાઉન્ટ કાયમી ધોરણે પ્રતિબંધિત કરવામાં આવ્યું છે.';

  @override
  String get accountDeletedTitle => 'એકાઉન્ટ કાઢી નાખ્યું';

  @override
  String get accountDeletedDesc =>
      'આ એકાઉન્ટ કાઢી નાખવામાં આવ્યું છે. જો તમે માનતા હોવ કે આ એક ભૂલ છે, તો કૃપા કરીને સમર્થનનો સંપર્ક કરો.';

  @override
  String get signOut => 'સાઇન આઉટ કરો';

  @override
  String get appeal => 'અપીલ';

  @override
  String get sportSoccer => 'સોકર';

  @override
  String get sportBasketball => 'બાસ્કેટબૉલ';

  @override
  String get sportTennis => 'ટેનિસ';

  @override
  String get sportVolleyball => 'વોલીબૉલ';

  @override
  String get sportBadminton => 'બેડમિન્ટન';

  @override
  String get sportTableTennis => 'ટેબલ ટેનિસ';

  @override
  String get sportCricket => 'ક્રિકેટ';

  @override
  String get sportSwimming => 'સ્વિમિંગ';

  @override
  String get sportRunning => 'ચાલી રહી છે';

  @override
  String get sportCycling => 'સાયકલિંગ';

  @override
  String get sportKabaddi => 'કબડ્ડી';

  @override
  String get sportKhoKho => 'ખો-ખો';

  @override
  String get sportGilliDanda => 'ગિલ્લી-દંડા';

  @override
  String get sportSatoliya => 'સાતોલીયા/લગોરી';

  @override
  String get sportKiteFlying => 'કાઈટ ફ્લાઈંગ';

  @override
  String get sportSkating => 'સ્કેટિંગ';

  @override
  String get sportHockey => 'ફીલ્ડ હોકી';

  @override
  String get sportUltimateFrisbee => 'અલ્ટીમેટ ફ્રિસ્બી';

  @override
  String get sportPickleball => 'પિકલબોલ';

  @override
  String get sportTugOfWar => 'ટગ ઓફ વોર';

  @override
  String get sportHiking => 'હાઇકિંગ / ટ્રેકિંગ';

  @override
  String get sportOutdoorYoga => 'આઉટડોર યોગા';

  @override
  String get confirmAction => 'પુષ્ટિ કરો';

  @override
  String get activityHost => 'યજમાન';

  @override
  String get activityFull => 'સંપૂર્ણ';

  @override
  String activityCapacity(int current, int total) {
    return '$total ના $current જોડાયા';
  }

  @override
  String get detailsTitle => 'પ્રવૃત્તિ વિગતો';

  @override
  String get detailsAbout => 'આ પ્રવૃત્તિ વિશે';

  @override
  String get detailsWhen => 'જ્યારે આપણે રમીએ છીએ';

  @override
  String get detailsWhere => 'અહીં મળો';

  @override
  String get detailsPlayers => 'કોણ રમે છે';

  @override
  String get detailsNoPlayers => 'લાઇનઅપ હમણાં જ શરૂ થઈ રહ્યું છે.';

  @override
  String get detailsNoPlayersHint =>
      'એકવાર યજમાન તેમની વિનંતીઓ સ્વીકારે તે પછી પુષ્ટિ થયેલ ખેલાડીઓ અહીં દેખાશે.';

  @override
  String get detailsHostedBy => 'તમારા યજમાન';

  @override
  String get detailsJoinHint => 'વિનંતી મોકલો. હોસ્ટ તમારા સ્થળની પુષ્ટિ કરશે.';

  @override
  String get detailsPendingHint =>
      'તમારી વિનંતી યજમાન પાસે છે. જ્યારે તેઓ જવાબ આપશે ત્યારે અમે તમને સૂચિત કરીશું.';

  @override
  String get detailsJoinedHint =>
      'તમે લાઇનઅપ પર છો. તમે બહાર નીકળો તે પહેલાં સમય અને સ્થળ તપાસો.';

  @override
  String get detailsHostHint =>
      'જોડાવાની વિનંતીઓની સમીક્ષા કરો અને તમારી લાઇનઅપ બનાવો.';

  @override
  String get detailsClosed => 'જોડાવાનું બંધ';

  @override
  String get detailsDraft => 'ડ્રાફ્ટ';

  @override
  String get detailsOpen => 'ખેલાડીઓ માટે ખુલ્લું છે';

  @override
  String get detailsCopy => 'પ્રવૃત્તિ વિગતો કૉપિ કરો';

  @override
  String get detailsCopied => 'પ્રવૃત્તિ વિગતો કૉપિ કરી';

  @override
  String get detailsCopyFailed =>
      'વિગતોની નકલ કરી શકાઈ નથી. કૃપા કરીને ફરી પ્રયાસ કરો.';

  @override
  String get detailsMenu => 'પ્રવૃત્તિ વિકલ્પો';

  @override
  String get detailsSafety => 'સારી રીતે રમો, સાથે';

  @override
  String get detailsSafetyNote =>
      'તમારા હોસ્ટ સાથે મીટિંગ પોઈન્ટની પુષ્ટિ કરો, અન્ય ખેલાડીઓનો આદર કરો અને કોઈપણ ચિંતાની જાણ કરો.';

  @override
  String get detailsLoadError => 'અમે આ પ્રવૃત્તિ લોડ કરી શક્યાં નથી.';

  @override
  String get detailsPrice => 'વ્યક્તિ દીઠ';

  @override
  String get detailsJoin => 'જોડાવા વિનંતી';

  @override
  String detailsPhotoCount(int current, int total) {
    return '$current / $total';
  }

  @override
  String detailsAvailability(int available, int total) {
    return '$total સ્પોટમાંથી $available ઉપલબ્ધ છે';
  }

  @override
  String detailsPhotoLabel(int current, int total) {
    return '$total નો $current પ્રવૃત્તિ ફોટો';
  }

  @override
  String get galleryOpen => 'ફોટા જુઓ';

  @override
  String get galleryZoomHint =>
      'ઝૂમ કરવા માટે પિંચ કરો · અન્વેષણ કરવા માટે સ્વાઇપ કરો';

  @override
  String get galleryPrevious => 'અગાઉનો ફોટો';

  @override
  String get galleryNext => 'આગળનો ફોટો';

  @override
  String get galleryZoomIn => 'ઝૂમ ઇન કરો';

  @override
  String get galleryZoomOut => 'ઝૂમ રીસેટ કરો';

  @override
  String get detailsSharedMapLink => 'શેર કરેલ નકશાની લિંક';

  @override
  String get detailsMapLinkHint => 'હોસ્ટ દ્વારા શેર કરેલ સ્થાન ખોલો.';

  @override
  String get detailsMapSearchHint =>
      'નકશામાં આ સ્થળ શોધો; તમારા હોસ્ટ સાથે મીટિંગ પોઇન્ટની પુષ્ટિ કરો.';

  @override
  String get detailsOpenMapLink => 'નકશાની લિંક ખોલો';

  @override
  String get detailsSearchMaps => 'નકશામાં શોધો';

  @override
  String get homeComingUpSubtitle => 'આગામી 7 દિવસમાં રમતો';

  @override
  String get homeLaterOn => 'પાછળથી';

  @override
  String get homeLaterSubtitle => 'આગામી સપ્તાહ પછીની પ્રવૃત્તિઓ';

  @override
  String get detailsMapOpenFailed =>
      'નકશા ખોલી શકાયા નથી. કૃપા કરીને ફરી પ્રયાસ કરો.';

  @override
  String get activityNowLive =>
      'તમારી પ્રવૃત્તિ હવે લાઇવ છે. લોકો જોડાવા માટે વિનંતી કરવાનું શરૂ કરી શકે છે.';

  @override
  String get nextGameStartsHere => 'તમારી આગલી રમત અહીં શરૂ થાય છે';

  @override
  String get turnSoundOff => 'અવાજ બંધ કરો';

  @override
  String get turnSoundOn => 'અવાજ ચાલુ કરો';

  @override
  String get goToHome => 'હોમ પર જાઓ';

  @override
  String get yourActivityHub => 'તમારું પ્રવૃત્તિ હબ';

  @override
  String homeActivityHubPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'સમીક્ષા કરવા માટે તમારી પાસે $count બાકી વિનંતીઓ છે.',
      one: 'સમીક્ષા કરવા માટે તમારી પાસે 1 બાકી વિનંતી છે.',
    );
    return '$_temp0';
  }

  @override
  String get homeActivityHubJoined =>
      'તમારી આગામી જોડાવાની પ્રવૃત્તિ આવી રહી છે.';

  @override
  String get homeActivityHubHosted =>
      'તમારી આગામી હોસ્ટ કરેલ પ્રવૃત્તિ આવી રહી છે.';

  @override
  String get homeActivityHubEmpty =>
      'હજુ સુધી કોઈ આગામી પ્રવૃત્તિઓ નથી. પ્રારંભ કરવા માટે એક બનાવો.';

  @override
  String get homeActivityHubRecommendation =>
      'તમારા પસંદ કરેલા શહેરમાં ભાવિ પ્રવૃત્તિ ઉપલબ્ધ છે.';

  @override
  String get homeActivityHubError => 'તમારી પ્રવૃત્તિ વિગતો લોડ કરી શકાઈ નથી.';

  @override
  String get homeReviewRequests => 'વિનંતીઓની સમીક્ષા કરો';

  @override
  String get homeViewActivity => 'પ્રવૃત્તિ જુઓ';

  @override
  String get homeManageActivity => 'પ્રવૃત્તિ મેનેજ કરો';

  @override
  String get homeCreateActivity => 'પ્રવૃત્તિ બનાવો';

  @override
  String get homeGroupChat => 'ગ્રુપ ચેટ';

  @override
  String get homeCityLoadError => 'શહેરો લોડ કરી શકાયા નથી';

  @override
  String get homeRetryCategories => 'શ્રેણીઓનો ફરી પ્રયાસ કરો';

  @override
  String get homeFeedNetworkError =>
      'પ્રવૃત્તિઓ લોડ કરી શકાઈ નથી. તમારું કનેક્શન તપાસો અને ફરી પ્રયાસ કરો.';

  @override
  String get homeFeedLoadError => 'પ્રવૃત્તિઓ લોડ કરતી વખતે કંઈક ખોટું થયું.';

  @override
  String get dismiss => 'કાઢી નાખો';

  @override
  String get notificationPermissionTitle => 'અપડેટ રહો';

  @override
  String get notificationPermissionBody =>
      'જ્યારે કોઈ તમારા સ્પોટ પર જોડાવા માંગે છે અથવા જ્યારે તમને સ્પોટ પર સ્વીકારવામાં આવે છે ત્યારે તમને ચેતવણી આપવા માટે અમને સૂચના પરવાનગીઓની જરૂર છે.';

  @override
  String get allow => 'પરવાનગી આપે છે';

  @override
  String get notNow => 'હવે નહીં';

  @override
  String get full => 'સંપૂર્ણ';

  @override
  String get host => 'યજમાન';

  @override
  String get ofText => 'ના';

  @override
  String get spots => 'ફોલ્લીઓ';

  @override
  String get suggestedPlayingHours => 'સુચવાયેલા રમવાના કલાકો';

  @override
  String get bestTimeToPlay => 'રમવા માટેનો શ્રેષ્ઠ સમય';

  @override
  String get mySportsSpaceTitle => 'માય સ્પોર્ટ્સ સ્પેસ';

  @override
  String get statHosted => 'યજમાન';

  @override
  String get statUpcoming => 'આગામી';

  @override
  String get sportsJourney => 'મારી સ્પોર્ટ્સ જર્ની';

  @override
  String get upcomingGames => 'આગામી રમતો';

  @override
  String get pastActivities => 'ભૂતકાળની પ્રવૃત્તિઓ';

  @override
  String get hostedMatches => 'હોસ્ટ કરેલ મેચ';

  @override
  String get joinedMatches => 'મેચોમાં જોડાયા';

  @override
  String get sportsInterests => 'રમતગમતની રુચિઓ';

  @override
  String get editInterests => 'રુચિઓ સંપાદિત કરો';

  @override
  String get noSportsInterests =>
      'હજુ સુધી કોઈ રમતગમતની રુચિઓ ઉમેરવામાં આવી નથી.';

  @override
  String get noJourneyActivities => 'આ વિભાગમાં કોઈ પ્રવૃત્તિઓ નથી.';

  @override
  String get achievementsTitle => 'રમતગમતની સિદ્ધિઓ';

  @override
  String get achievementFirstHost => 'પ્રથમ યજમાન';

  @override
  String get achievementFirstHostDesc => 'તમારી પ્રથમ મેચનું આયોજન કર્યું';

  @override
  String get achievementTeamPlayer => 'ટીમ પ્લેયર';

  @override
  String get achievementTeamPlayerDesc => 'રમતગમતની પ્રવૃત્તિમાં જોડાયા';

  @override
  String get achievementActiveAthlete => 'સક્રિય રમતવીર';

  @override
  String get achievementActiveAthleteDesc => '5 રમતગમતની પ્રવૃત્તિઓ પૂર્ણ કરી';

  @override
  String get achievementSportsLegend => 'સ્પોર્ટ્સ લિજેન્ડ';

  @override
  String get achievementSportsLegendDesc => '10 રમતગમતની પ્રવૃત્તિઓ પૂર્ણ કરી';

  @override
  String get quickActions => 'ઝડપી ક્રિયાઓ';

  @override
  String get quickActionFindGame => 'એક રમત શોધો';

  @override
  String get quickActionOrganize => 'મેચ ગોઠવો';

  @override
  String get quickActionMyMatches => 'મારા મેચ';

  @override
  String get quickActionChats => 'ટીમ ચેટ્સ';

  @override
  String get participantRoleHost => 'યજમાન';

  @override
  String get participantRolePlayer => 'પ્લેયર';

  @override
  String get statusOpen => 'ખોલો';

  @override
  String get statusPending => 'બાકી છે';

  @override
  String get statusAccepted => 'સ્વીકાર્યું';

  @override
  String get statusRejected => 'ફગાવી દીધી';

  @override
  String get onboardingSkip => 'છોડો';

  @override
  String get onboardingBack => 'પાછળ';

  @override
  String get onboardingGetStarted => 'શરૂ કરો';

  @override
  String get onboardingContinue => 'આગળ વધો';

  @override
  String get onboardingLetsPlay => 'ચાલો રમીએ';

  @override
  String get onboardingAlreadyHaveAccount => 'પહેલેથી ખાતું છે? ';

  @override
  String get onboardingSignIn => 'સાઇન ઇન';

  @override
  String get onboardingSlide1Title => 'તમારી રમત. તમારી ટોળી.';

  @override
  String get onboardingSlide1Tagline => 'ભાઈ, ટીમ બનાવીએ! મેચ જમાવીએ!';

  @override
  String get onboardingSlide1Desc =>
      'ખેલાડીઓ શોધો, ટીમ બનાવો અને યોજનાઓને સાચી રમતમાં બદલો.';

  @override
  String get onboardingSlide2Title => 'ખેલાડીઓ ઓછા છે? ખેલભાઈ છે ને!';

  @override
  String get onboardingSlide2Desc =>
      'તમારી નજીકના એવા લોકોને શોધો જે તમારી આગામી રમતમાં જોડાવા માટે તૈયાર છે.';

  @override
  String get onboardingSlide3Title => 'મેચ બનાવો. ટીમને બોલાવો.';

  @override
  String get onboardingSlide3Desc =>
      'મેચ હોસ્ટ કરો, પ્રવૃત્તિઓ શોધો અને રમતના મેદાનમાં ઉતરો.';

  @override
  String get onboardingSlide4Title => 'ટીમ બની? હવે મેચ જમાવો!';

  @override
  String get onboardingSlide4Desc =>
      'સાથીઓ સાથે ચેટ કરો, પ્લાન બનાવો અને રમવા માટે તૈયાર થાઓ.';

  @override
  String get onboardingReadyHeading => 'તૈયાર, ભાઈ? ચાલો રમીએ!';

  @override
  String get completedMatches => 'પૂર્ણ થયેલ મેચ';

  @override
  String get verifiedEmail => 'ચકાસાયેલ';
}
