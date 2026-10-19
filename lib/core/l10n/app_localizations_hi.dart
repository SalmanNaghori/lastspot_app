// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'खेलभाई';

  @override
  String todayAt(Object time) {
    return 'आज $time पर';
  }

  @override
  String yesterdayAt(Object time) {
    return 'कल $time पर';
  }

  @override
  String get appDescription => 'भाई, टीम बनाओ! मैच जमाओ!';

  @override
  String get updateNow => 'अभी अद्यतन करें';

  @override
  String get maybeLater => 'शायद बाद में';

  @override
  String get maintenanceMode => 'रखरखाव मोड';

  @override
  String get requestToJoin => 'मैच में शामिल होने का अनुरोध';

  @override
  String get publishSpot => 'फ़ीड करने के लिए स्थान प्रकाशित करें';

  @override
  String get searchHint => 'मैदान, खेल, खिलाड़ी खोजें...';

  @override
  String get urgentMatches => 'अत्यावश्यक मैच (आज से प्रारंभ)';

  @override
  String get recentPosts => 'हाल के पोस्ट';

  @override
  String get openGroundMap => 'खुला मैदान मानचित्र ↗';

  @override
  String get mapLocation => 'साझा मानचित्र लिंक';

  @override
  String get viewSpot => 'स्पॉट देखें';

  @override
  String spotsNeeded(Object count) {
    return '$count स्पॉट';
  }

  @override
  String spotNeeded(Object count) {
    return '$count स्पॉट';
  }

  @override
  String hostPrefix(Object name) {
    return 'होस्ट: $name';
  }

  @override
  String get homeTab => 'होम';

  @override
  String get myMatchesTab => 'मेरे मैच';

  @override
  String get profileTab => 'प्रोफ़ाइल';

  @override
  String get hostMatchTitle => 'एक मैच की मेजबानी करें';

  @override
  String get selectSportCategory => 'खेल श्रेणी चुनें*';

  @override
  String get playersNeeded => 'खिलाड़ियों की आवश्यकता*';

  @override
  String get schedule => 'अनुसूची*';

  @override
  String get datePrefix => 'तारीख:';

  @override
  String get timePrefix => 'समय:';

  @override
  String get venueDetails => 'स्थान विवरण*';

  @override
  String get venueNameHint => 'स्थान का नाम: उदा. डेकाथलॉन स्पोर्ट्स टर्फ';

  @override
  String get mapsLinkHint => 'https://maps.app.goo.gl/... [पेस्ट करें]';

  @override
  String get mapsGuidance =>
      'उपयोगकर्ता सीधे Google मानचित्र में बारी-बारी दिशा-निर्देश प्राप्त करने के लिए इस पर टैप करेंगे।';

  @override
  String get additionalGuidelines => 'अतिरिक्त दिशानिर्देश (वैकल्पिक)';

  @override
  String get matchOverviewTitle => 'मैच का अवलोकन';

  @override
  String statusActiveNeeded(Object count) {
    return 'स्थिति: सक्रिय • आवश्यक: $count खिलाड़ी';
  }

  @override
  String hostedBy(Object name) {
    return '$name द्वारा होस्ट किया गया';
  }

  @override
  String get locationAndDirections => 'स्थान एवं दिशाएँ';

  @override
  String get tapForNavigation => 'लाइव नेविगेशन के लिए नीचे टैप करें';

  @override
  String get openInMaps => '🧭 Google/Apple मैप्स में खोलें ↗';

  @override
  String confirmedPlayers(Object current, Object total) {
    return 'पुष्टि किए गए खिलाड़ी ($current/$total)';
  }

  @override
  String get safetyAndConduct => 'सुरक्षा एवं आचरण';

  @override
  String get reportActivity => '🚩इस गतिविधि या होस्ट की रिपोर्ट करें';

  @override
  String get manageMatchRequests => 'मिलान अनुरोध प्रबंधित करें';

  @override
  String openSpotsRemaining(Object current, Object total) {
    return 'शेष खुले स्थान: $current / $total';
  }

  @override
  String pendingRequests(Object count) {
    return 'लंबित अनुरोध ($count)';
  }

  @override
  String get reject => 'अस्वीकार करना';

  @override
  String get accept => 'स्वीकार करना';

  @override
  String get openMatchChat => 'मैच ग्रुप चैट खोलें';

  @override
  String get messageHost => 'संदेश होस्ट';

  @override
  String get directMessage => 'सीधा संदेश';

  @override
  String get groupChat => 'समूह बातचीत';

  @override
  String get activity => 'गतिविधि';

  @override
  String get messageHint => 'एक सन्देश लिखिए';

  @override
  String get sendMessage => 'मेसेज भेजें';

  @override
  String get signInToChat => 'चैट का उपयोग करने के लिए साइन इन करें';

  @override
  String get chatEmpty => 'अभी तक कोई संदेश नहीं. बातचीत शुरू करें.';

  @override
  String get messageSendFailed =>
      'संदेश नहीं भेजा जा सका. कृपया पुन: प्रयास करें।';

  @override
  String get login => 'लॉग इन करें';

  @override
  String get signup => 'साइन अप करें';

  @override
  String get email => 'ईमेल';

  @override
  String get password => 'पासवर्ड';

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get yourName => 'आपका नाम';

  @override
  String get forgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get createAccount => 'खाता बनाएं';

  @override
  String get joinCommunity => 'समुदाय में शामिल हों और खेलें।';

  @override
  String get navHome => 'होम';

  @override
  String get navExplore => 'खोजें';

  @override
  String get navCreate => 'बनाएं';

  @override
  String get navActivities => 'गतिविधियां';

  @override
  String get navChats => 'बातचीत';

  @override
  String get navProfile => 'प्रोफ़ाइल';

  @override
  String get openProfile => 'प्रोफ़ाइल खोलें';

  @override
  String get searchConversations => 'वार्तालाप खोजें...';

  @override
  String get noConversationsFound => 'कोई बातचीत नहीं मिली';

  @override
  String get noConversationsFoundDesc =>
      'आप जो खोज रहे हैं उसे ढूंढने के लिए अपनी खोज या फ़िल्टर को समायोजित करने का प्रयास करें।';

  @override
  String get explorePlaceholderText => 'अपने आस-पास की गतिविधियों की खोज करें';

  @override
  String get activitiesEmptyMessage =>
      'आपकी गतिविधियां यहां दिखाई देंगी.\nआपके द्वारा बनाई गई या शामिल होने वाली गतिविधियाँ यहां दिखाई देंगी।';

  @override
  String get exploreActivitiesAction => 'गतिविधियों का अन्वेषण करें';

  @override
  String get logoutDialogTitle => 'लॉग आउट?';

  @override
  String get logoutDialogMessage =>
      'आपको अपने खेलभाई खाते तक पहुंचने के लिए फिर से साइन इन करना होगा।';

  @override
  String get cancel => 'रद्द करना';

  @override
  String get logout => 'लॉग आउट';

  @override
  String get editProfile => 'प्रोफ़ाइल संपादित करें';

  @override
  String get profileSectionActivity => 'मेरी गतिविधि';

  @override
  String get profileSectionAccount => 'खाता';

  @override
  String get profileSectionLegal => 'कानूनी';

  @override
  String get myRequests => 'मेरा अनुभव';

  @override
  String get myActivities => 'मेरी गतिविधियाँ';

  @override
  String get notifications => 'सूचनाएं';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get helpSupport => 'सहायता एवं सहायता';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get termsConditions => 'नियम एवं शर्तें';

  @override
  String get statCreated => 'बनाया था';

  @override
  String get statJoined => 'सम्मिलित हुए';

  @override
  String get statCompleted => 'पुरा होना।';

  @override
  String get goodMorning => 'शुभ प्रभात';

  @override
  String get goodAfternoon => 'शुभ दोपहर';

  @override
  String get goodEvening => 'शुभ संध्या';

  @override
  String get whatAreYouUpTo => 'आज आप किस लिए तैयार हैं?';

  @override
  String get urgentMatchesSubtitle =>
      'उनके भरने से पहले आस-पास की गतिविधियों में शामिल हों!';

  @override
  String get viewAll => 'सभी को देखें';

  @override
  String get popularSports => 'लोकप्रिय खेल';

  @override
  String get popularSportsSubtitle =>
      'अपना पसंदीदा खेल ढूंढें और कार्रवाई में शामिल हों';

  @override
  String get sportsCarouselHint =>
      'खेल देखने के लिए स्वाइप करें · गतिविधियाँ देखने के लिए टैप करें';

  @override
  String get searchCityHint => 'शहर या राज्य खोजें...';

  @override
  String get nearbyActivities => 'आस-पास की गतिविधियाँ';

  @override
  String get comingUp => 'आ रहा है';

  @override
  String spotsLeft(Object count) {
    return '$count स्पॉट बचे';
  }

  @override
  String get oneSpotLeft => '1 स्थान शेष';

  @override
  String get perPerson => 'प्रति व्यक्ति';

  @override
  String get filterCricket => 'क्रिकेट';

  @override
  String get filterFootball => 'फ़ुटबॉल';

  @override
  String get filterBadminton => 'बैडमिंटन';

  @override
  String get filterTennis => 'टेनिस';

  @override
  String get verifiedHost => 'मेज़बान';

  @override
  String get noSpotsFound =>
      'कोई सक्रिय स्थान नहीं मिला.\nइसे बनाने वाले पहले बनें!';

  @override
  String get validationTitleLocationCategory =>
      'शीर्षक, स्थान और श्रेणी आवश्यक हैं.';

  @override
  String get activityGeneratedSuccess => 'गतिविधि बनाई गई!';

  @override
  String get generateActivity => 'गतिविधि बनाएँ';

  @override
  String get activityImages => 'गतिविधि छवियाँ';

  @override
  String get category => 'वर्ग';

  @override
  String get selectCategory => 'एक श्रेणी चुनें';

  @override
  String get failedToLoadCategories => 'श्रेणियां लोड करने में विफल';

  @override
  String get activityTitle => 'गतिविधि शीर्षक';

  @override
  String get activityTitleHint => 'जैसे रविवार की सुबह फुटबॉल';

  @override
  String get description => 'विवरण';

  @override
  String get descriptionHint => 'इस गतिविधि के बारे में कुछ विवरण साझा करें...';

  @override
  String get location => 'जगह';

  @override
  String get locationHint => 'जैसे सेंट्रल पार्क टर्फ';

  @override
  String get date => 'तारीख';

  @override
  String get time => 'समय';

  @override
  String get maxParticipants => 'अधिकतम प्रतिभागी';

  @override
  String get pricePerPerson => 'मूल्य प्रति व्यक्ति';

  @override
  String get previewActivity => 'गतिविधि का पूर्वावलोकन करें';

  @override
  String get publishActivity => 'गतिविधि प्रकाशित करें';

  @override
  String get noCategoriesAvailable => 'कोई श्रेणियां उपलब्ध नहीं';

  @override
  String get noCitiesFound => 'कोई शहर नहीं मिला';

  @override
  String get createAnother => 'दूसरा बनाएं';

  @override
  String get youAreParticipant1 => 'वर्तमान प्रतिभागी: 1 (आप)';

  @override
  String get addPhotos => 'तस्वीरें जोडो';

  @override
  String get gallery => 'गैलरी';

  @override
  String get camera => 'कैमरा';

  @override
  String get acceptTerms => 'मैं नियम एवं शर्तें स्वीकार करता हूं';

  @override
  String get acceptTermsError => 'कृपया नियम एवं शर्तें स्वीकार करें';

  @override
  String get confirmPassword => 'पासवर्ड की पुष्टि कीजिये';

  @override
  String get loginSubtitle => 'तुरंत अपना एक्टिविटी पार्टनर ढूंढें।';

  @override
  String get dontHaveAccount => 'कोई खाता नहीं है? साइन अप करें';

  @override
  String get sendResetLink => 'रीसेट लिंक भेजें';

  @override
  String get passwordResetSent => 'पासवर्ड रीसेट लिंक आपके ईमेल पर भेजा गया!';

  @override
  String get resetPassword => 'पासवर्ड रीसेट';

  @override
  String get resetPasswordDesc =>
      'अपना ईमेल पता दर्ज करें और हम आपको अपना पासवर्ड रीसेट करने के लिए एक लिंक भेजेंगे।';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get themeTitle => 'थीम';

  @override
  String get appColorTitle => 'ऐप का रंग';

  @override
  String get themeSystem => 'सिस्टम डिफ़ॉल्ट';

  @override
  String get themeLight => 'लाइट';

  @override
  String get themeDark => 'डार्क';

  @override
  String get languageTitle => 'भाषा';

  @override
  String get languageEnglish => 'अंग्रेज़ी';

  @override
  String get languageHindi => 'हिन्दी';

  @override
  String get languageGujarati => 'गुजराती';

  @override
  String get cityRequiredError => 'कृपया एक शहर चुनें';

  @override
  String get joinCommunitySubtitle =>
      'समुदाय में शामिल हों और अपने आस-पास की गतिविधियाँ खोजें।';

  @override
  String get fullNameRequired => 'पूरा नाम आवश्यक है';

  @override
  String get emailRequired => 'ईमेल की जरूरत है';

  @override
  String get invalidEmail => 'एक वैध ईमेल दर्ज करें';

  @override
  String get passwordRequired => 'पासवर्ड आवश्यक है';

  @override
  String get passwordLengthError => 'पासवर्ड कम से कम 6 अंकों का होना चाहिए';

  @override
  String get passwordsDoNotMatch => 'सांकेतिक शब्द मेल नहीं खाते';

  @override
  String get cityLabel => 'शहर *';

  @override
  String get selectCityHint => 'अपना शहर चुनें';

  @override
  String get alreadyHaveAccount => 'क्या आपके पास पहले से एक खाता मौजूद है?';

  @override
  String get noInternetError =>
      'कोई इंटरनेट कनेक्शन नहीं। कृपया अपना नेटवर्क जांचें और पुनः प्रयास करें।';

  @override
  String get setupProfile => 'सेटअप प्रोफ़ाइल';

  @override
  String get bioOptional => 'जीवनी (वैकल्पिक)';

  @override
  String get sportsPreferences => 'खेल प्राथमिकताएँ';

  @override
  String get saveAndContinue => 'सहेजें जारी रखें';

  @override
  String get saveChanges => 'परिवर्तनों को सुरक्षित करें';

  @override
  String get cityIsRequired => 'शहर की आवश्यकता है';

  @override
  String get findActivitiesNearYou => 'अपने आस-पास गतिविधियाँ खोजें';

  @override
  String get searchActivitiesHint => 'गतिविधियाँ खोजें...';

  @override
  String get activitiesNearYou => 'आपके आस-पास की गतिविधियाँ';

  @override
  String activitiesCount(Object count) {
    return '$count गतिविधियाँ';
  }

  @override
  String get couldNotLoadActivities => 'गतिविधियाँ लोड नहीं की जा सकीं';

  @override
  String get checkConnectionRetry => 'अपना कनेक्शन जांचें और पुनः प्रयास करें।';

  @override
  String get noActivitiesFound => 'कोई गतिविधि नहीं मिली';

  @override
  String get noActivitiesInArea =>
      'आपके क्षेत्र में अभी कोई आगामी गतिविधियाँ नहीं हैं।';

  @override
  String get noActivitiesMatchSearch =>
      'कोई भी गतिविधि आपकी खोज से मेल नहीं खाती';

  @override
  String get tryDifferentKeyword =>
      'किसी भिन्न कीवर्ड से खोजने का प्रयास करें.';

  @override
  String get noActivitiesInCategory => 'इस श्रेणी में कोई गतिविधि नहीं';

  @override
  String get tryDifferentCategory =>
      '\'सभी\' या किसी भिन्न श्रेणी का चयन करने का प्रयास करें।';

  @override
  String get retry => 'पुन: प्रयास करें';

  @override
  String get allFilter => 'सभी';

  @override
  String get selectYourCity => 'अपना शहर चुनें';

  @override
  String get filters => 'फिल्टर';

  @override
  String get anyDate => 'कोई दिन';

  @override
  String get today => 'आज';

  @override
  String get tomorrow => 'कल';

  @override
  String get thisWeekend => 'इस सप्ताहांत';

  @override
  String get price => 'कीमत';

  @override
  String get any => 'कोई';

  @override
  String get free => 'मुक्त';

  @override
  String get paid => 'चुकाया गया';

  @override
  String get participants => 'प्रतिभागियों';

  @override
  String get spots1to2 => '1-2 स्थान';

  @override
  String get spots3to5 => '3-5 स्थान';

  @override
  String get spots5plus => '5+ स्पॉट';

  @override
  String get reset => 'रीसेट करें';

  @override
  String get applyFilters => 'फ़िल्टर लागू करें';

  @override
  String get loading => 'लोड हो रहा है...';

  @override
  String get todaysMatches => 'आज के मैच';

  @override
  String get urgentMatchesTitle => 'अत्यावश्यक मिलान';

  @override
  String get tryAgain => 'पुनः प्रयास करें';

  @override
  String get recommendedForYou => 'आप के लिए अनुशंसित';

  @override
  String get newThisWeek => 'इस सप्ताह नया';

  @override
  String get city => 'शहर';

  @override
  String get selectCity => 'शहर चुनें';

  @override
  String get edit => 'संपादन करना';

  @override
  String get deleteImageNotSupported =>
      'मौजूदा छवियों को हटाना अभी समर्थित नहीं है.';

  @override
  String get howManyPeopleCanJoin => 'कितने लोग शामिल हो सकते हैं?';

  @override
  String get youAreIncluded => 'आप शामिल हैं (1)';

  @override
  String get morning => 'सुबह';

  @override
  String get afternoon => 'दोपहर';

  @override
  String get evening => 'शाम';

  @override
  String get night => 'रात';

  @override
  String get pleaseSelectFutureTime => 'कृपया भविष्य का समय चुनें';

  @override
  String get supportContactComingSoon =>
      'सहायता संपर्क सुविधा जल्द ही आ रही है.';

  @override
  String get contactSupport => 'समर्थन से संपर्क करें';

  @override
  String get thisIsHowActivityAppears =>
      'इस प्रकार आपकी गतिविधि दूसरों को दिखाई देगी.';

  @override
  String get viewOnMap => 'मानचित्र पर देखें';

  @override
  String get noPendingRequests => 'कोई लंबित अनुरोध नहीं.';

  @override
  String get matchGroupChat => 'समूह चैट का मिलान करें';

  @override
  String get chatComingSoon => 'चैट जल्द ही आ रही है!';

  @override
  String get realtimeMessagingAvailableHere =>
      'यहां रियलटाइम मैसेजिंग उपलब्ध होगी.';

  @override
  String get pleaseEnterValidPrice => 'कृपया एक वैध दाम की प्रविष्टि करें';

  @override
  String get statusActive => 'स्थिति: सक्रिय';

  @override
  String neededPlayers(Object count) {
    return '• आवश्यक: $count खिलाड़ी';
  }

  @override
  String get openInGoogleMaps => 'Google मानचित्र में खोलें';

  @override
  String get player => 'खिलाड़ी';

  @override
  String get inviteAFriend => 'किसी मित्र को आमंत्रित करें';

  @override
  String get reportThisActivityOrHost => 'इस गतिविधि या होस्ट की रिपोर्ट करें';

  @override
  String get learnAboutSafetyGuidelines =>
      'सुरक्षा दिशानिर्देशों के बारे में जानें';

  @override
  String get manageActivitiesDesc =>
      'उन गतिविधियों को प्रबंधित करें जिन्हें आप होस्ट करते हैं, शामिल हुए हैं, या जिनकी समीक्षा करने की आवश्यकता है।';

  @override
  String tabMyActivitiesCount(String count) {
    return 'मेरी गतिविधियाँ $count';
  }

  @override
  String tabJoinedCount(String count) {
    return '$count में शामिल हुए';
  }

  @override
  String tabRequestsCount(String count) {
    return 'अनुरोध $count';
  }

  @override
  String get tabChats => 'बातचीत';

  @override
  String tabChatsCount(String count) {
    return 'चैट $count';
  }

  @override
  String get noConversations => 'अभी तक कोई बातचीत नहीं';

  @override
  String get noConversationsDesc =>
      'अन्य खिलाड़ियों के साथ बातचीत शुरू करने के लिए किसी गतिविधि में शामिल हों या उसकी मेजबानी करें।';

  @override
  String get conversationLoadError =>
      'बातचीत लोड नहीं की जा सकी. कृपया पुन: प्रयास करें।';

  @override
  String get yesterday => 'कल';

  @override
  String get messageCopied => 'संदेश कॉपी किया गया';

  @override
  String get jumpToLatest => 'नवीनतम पर जाएं';

  @override
  String get newMessage => 'नया सन्देश';

  @override
  String activityContext(String title) {
    return 'गतिविधि: $title';
  }

  @override
  String get filterAll => 'सभी';

  @override
  String get filterDirect => 'प्रत्यक्ष';

  @override
  String get filterGroups => 'समूह';

  @override
  String get groupInfoTitle => 'समूह जानकारी';

  @override
  String get groupInfoParticipants => 'प्रतिभागियों';

  @override
  String get groupInfoHost => 'मेज़बान';

  @override
  String get groupInfoOrganizer => 'व्यवस्था करनेवाला';

  @override
  String get groupInfoNoParticipants =>
      'अभी तक कोई पुष्टिकृत प्रतिभागी नहीं है।';

  @override
  String get groupInfoActivityDetails => 'गतिविधि विवरण';

  @override
  String welcomeToActivity(String activityTitle, String emoji) {
    return '$activityTitle में आपका स्वागत है! $emoji';
  }

  @override
  String get groupWelcomeSubtitle =>
      'यह समूह गतिविधि के समन्वय के लिए है। सम्मानजनक बनें और आनंद लें!';

  @override
  String get groupOnlyParticipantsCanChat =>
      'केवल पुष्टि किए गए प्रतिभागी और होस्ट ही संदेश भेज सकते हैं।';

  @override
  String get noGroupConversations => 'अभी तक कोई समूह चैट नहीं';

  @override
  String get noGroupConversationsDesc =>
      'प्रतिभागियों के साथ बातचीत शुरू करने के लिए किसी गतिविधि में शामिल हों या उसकी मेजबानी करें।';

  @override
  String get noDirectConversations => 'अभी तक कोई सीधा संदेश नहीं';

  @override
  String get noDirectConversationsDesc =>
      'आपके और गतिविधि होस्ट के बीच सीधे संदेश यहां दिखाई देंगे।';

  @override
  String get you => 'आप';

  @override
  String get mockGoldenGateTitle => 'गोल्डन गेट सनसेट वॉक';

  @override
  String get mockGoldenGateDate => 'आज · शाम 6:00 बजे';

  @override
  String get mockGoldenGateLoc => 'गोल्डन गेट पार्क';

  @override
  String get mockGoldenGateStats => '6/10 प्रतिभागी · मुफ़्त';

  @override
  String get mockSunsetVolleyballTitle => 'सूर्यास्त बीच वॉलीबॉल';

  @override
  String get mockSunsetVolleyballDate => 'गुरु, 20 जून · शाम 6:30 बजे';

  @override
  String get mockSunsetVolleyballLoc => 'महासागर समुद्रतट';

  @override
  String get mockRooftopCookingTitle => 'छत पर खाना पकाने की कक्षा';

  @override
  String get mockRooftopCookingDate => 'शनिवार, 22 जून · शाम 6:30 बजे';

  @override
  String get mockRooftopCookingLoc => 'मिशन जिला छत';

  @override
  String get mockRooftopCookingStats => '8/8 प्रतिभागी · \$24';

  @override
  String get mockSalsaTitle => 'शुरुआती साल्सा क्लास';

  @override
  String get mockSalsaDate => 'रविवार, 23 जून · शाम 5:00 बजे';

  @override
  String get mockSalsaLoc => 'मिशन डांस हॉल';

  @override
  String get mockSalsaStats => '2/10 प्रतिभागी · \$12';

  @override
  String get tabPreviewData => 'टैब पूर्वावलोकन डेटा';

  @override
  String get previewJoined =>
      'शामिल हुए · सप्ताहांत मिट्टी के बर्तनों की कक्षा · शनिवार · 4 प्रतिभागी';

  @override
  String get previewRequests =>
      'अनुरोध · 3 लंबित शामिल होने के अनुरोध · अभी समीक्षा करें';

  @override
  String get statusHosted => 'की मेजबानी';

  @override
  String get statusFull => 'भरा हुआ';

  @override
  String get pendingRequest => 'लंबित अनुरोध';

  @override
  String get joined => 'सम्मिलित हुए';

  @override
  String get requestRejected => 'अनुरोध अस्वीकृत';

  @override
  String get requestCancelled => 'अनुरोध रद्द किया गया';

  @override
  String get share => 'शेयर करना';

  @override
  String get cancelActivity => 'गतिविधि रद्द करें';

  @override
  String get closeActivity => 'गतिविधि बंद करें';

  @override
  String get reportActivityAction => 'गतिविधि रिपोर्ट करें';

  @override
  String get statusCompleted => 'पुरा होना।';

  @override
  String get statusCancelled => 'रद्द कर दिया गया';

  @override
  String get statusExpired => 'खत्म हो चुका';

  @override
  String get emptyHostedTitle => 'कोई होस्ट की गई गतिविधियाँ नहीं';

  @override
  String get emptyHostedDesc => 'आपने अभी तक कोई गतिविधि नहीं बनाई है.';

  @override
  String get emptyJoinedTitle => 'कोई सम्मिलित गतिविधियाँ नहीं';

  @override
  String get emptyJoinedDesc =>
      'आप अभी तक किसी भी गतिविधि में शामिल नहीं हुए हैं.';

  @override
  String get emptyRequestsTitle => 'कोई शामिल होने का अनुरोध नहीं';

  @override
  String get emptyRequestsDesc =>
      'शामिल होने के अनुरोध की कार्यक्षमता यहां होगी.';

  @override
  String get aboutSection => 'के बारे में';

  @override
  String get scheduleSection => 'अनुसूची';

  @override
  String statusLabel(Object status) {
    return 'स्थिति: $status';
  }

  @override
  String get errorUnknownState => 'त्रुटि या अज्ञात स्थिति';

  @override
  String get reportReasonRequired => 'कृपया रिपोर्ट करने का कारण चुनें.';

  @override
  String get reportSubmittedSuccess =>
      'रिपोर्ट सफलतापूर्वक प्रस्तुत की गई. हम शीघ्र ही इसकी समीक्षा करेंगे.';

  @override
  String get whyReporting => 'आप इसकी सूचना क्यों दे रहे हैं?';

  @override
  String get additionalDetailsOptional => 'अतिरिक्त विवरण (वैकल्पिक)';

  @override
  String get reportDescHint =>
      'कृपया हमें समझने में सहायता के लिए अधिक विवरण प्रदान करें...';

  @override
  String get submitReport => 'रिपोर्ट सबमिट करें';

  @override
  String get tabReceived => 'प्राप्त';

  @override
  String get tabSent => 'भेजा';

  @override
  String get noReceivedRequests => 'अभी तक कोई अनुरोध प्राप्त नहीं हुआ';

  @override
  String get noSentRequests => 'अभी तक कोई अनुरोध नहीं भेजा गया';

  @override
  String get emptyReceivedRequestsDesc =>
      'जब कोई आपकी किसी गतिविधि में शामिल होने के लिए कहता है, तो उनका अनुरोध यहां दिखाई देगा।';

  @override
  String get emptySentRequestsDesc =>
      'जिन गतिविधियों में आप शामिल होने के लिए कहेंगे वे प्रतिक्रिया की प्रतीक्षा करते समय यहां दिखाई देंगी।';

  @override
  String get accountSuspendedTitle => 'खाता निलंबित कर दिया गया है';

  @override
  String get accountSuspendedDesc =>
      'हमारी सेवा की शर्तों के उल्लंघन के कारण आपका खाता अस्थायी रूप से निलंबित कर दिया गया है।';

  @override
  String get accountBannedTitle => 'खाता प्रतिबंधित';

  @override
  String get accountBannedDesc =>
      'हमारी नीतियों के गंभीर उल्लंघन के कारण आपका खाता स्थायी रूप से प्रतिबंधित कर दिया गया है।';

  @override
  String get accountDeletedTitle => 'खाता हटा दिया गया';

  @override
  String get accountDeletedDesc =>
      'यह खाता हटा दिया गया है. यदि आपको लगता है कि यह एक गलती है, तो कृपया सहायता से संपर्क करें।';

  @override
  String get signOut => 'साइन आउट';

  @override
  String get appeal => 'निवेदन';

  @override
  String get sportSoccer => 'फुटबॉल';

  @override
  String get sportBasketball => 'बास्केटबॉल';

  @override
  String get sportTennis => 'टेनिस';

  @override
  String get sportVolleyball => 'वॉलीबॉल';

  @override
  String get sportBadminton => 'बैडमिंटन';

  @override
  String get sportTableTennis => 'टेबल टेनिस';

  @override
  String get sportCricket => 'क्रिकेट';

  @override
  String get sportSwimming => 'तैरना';

  @override
  String get sportRunning => 'दौड़ना';

  @override
  String get sportCycling => 'साइकिल चलाना';

  @override
  String get sportKabaddi => 'कबडडी';

  @override
  String get sportKhoKho => 'खो-खो';

  @override
  String get sportGilliDanda => 'गिल्ली-डंडा';

  @override
  String get sportSatoliya => 'सातोलिया/लागोरी';

  @override
  String get sportKiteFlying => 'पतंग उड़ाना';

  @override
  String get sportSkating => 'स्केटिंग';

  @override
  String get sportHockey => 'फील्ड हॉकी';

  @override
  String get sportUltimateFrisbee => 'अद्भुत फ़्रिस्बी';

  @override
  String get sportPickleball => 'अचार का गोला';

  @override
  String get sportTugOfWar => 'रस्साकशी';

  @override
  String get sportHiking => 'पदयात्रा/ट्रेकिंग';

  @override
  String get sportOutdoorYoga => 'आउटडोर योगा';

  @override
  String get confirmAction => 'पुष्टि करना';

  @override
  String get activityHost => 'मेज़बान';

  @override
  String get activityFull => 'भरा हुआ';

  @override
  String activityCapacity(int current, int total) {
    return '$total के $current शामिल हुए';
  }

  @override
  String get detailsTitle => 'गतिविधि विवरण';

  @override
  String get detailsAbout => 'इस गतिविधि के बारे में';

  @override
  String get detailsWhen => 'जब हम खेलते हैं';

  @override
  String get detailsWhere => 'यहां मिलें';

  @override
  String get detailsPlayers => 'कौन खेल रहा है';

  @override
  String get detailsNoPlayers => 'लाइनअप अभी शुरू हो रहा है।';

  @override
  String get detailsNoPlayersHint =>
      'मेजबान द्वारा उनके अनुरोध स्वीकार करने के बाद पुष्टि किए गए खिलाड़ी यहां दिखाई देंगे।';

  @override
  String get detailsHostedBy => 'आपका मेज़बान';

  @override
  String get detailsJoinHint =>
      'एक अनुरोध भेजें. मेज़बान आपके स्थान की पुष्टि करेगा।';

  @override
  String get detailsPendingHint =>
      'आपका अनुरोध मेज़बान के पास है। जब वे जवाब देंगे तो हम आपको सूचित करेंगे।';

  @override
  String get detailsJoinedHint =>
      'आप लाइनअप पर हैं. बाहर निकलने से पहले समय और स्थान की जांच कर लें।';

  @override
  String get detailsHostHint =>
      'शामिल होने के अनुरोधों की समीक्षा करें और अपना लाइनअप बनाएं।';

  @override
  String get detailsClosed => 'शामिल होना बंद';

  @override
  String get detailsDraft => 'मसौदा';

  @override
  String get detailsOpen => 'खिलाड़ियों के लिए खुला';

  @override
  String get detailsCopy => 'गतिविधि विवरण कॉपी करें';

  @override
  String get detailsCopied => 'गतिविधि विवरण कॉपी किया गया';

  @override
  String get detailsCopyFailed =>
      'विवरण कॉपी नहीं किया जा सका. कृपया पुन: प्रयास करें।';

  @override
  String get detailsMenu => 'गतिविधि विकल्प';

  @override
  String get detailsSafety => 'साथ मिलकर अच्छा खेलें';

  @override
  String get detailsSafetyNote =>
      'अपने मेजबान के साथ बैठक स्थल की पुष्टि करें, अन्य खिलाड़ियों का सम्मान करें और किसी भी चिंता की रिपोर्ट करें।';

  @override
  String get detailsLoadError => 'हम इस गतिविधि को लोड नहीं कर सके.';

  @override
  String get detailsPrice => 'प्रति व्यक्ति';

  @override
  String get detailsJoin => 'शामिल होने का अनुरोध';

  @override
  String detailsPhotoCount(int current, int total) {
    return '$current / $total';
  }

  @override
  String detailsAvailability(int available, int total) {
    return '$total में से $available स्पॉट उपलब्ध हैं';
  }

  @override
  String detailsPhotoLabel(int current, int total) {
    return '$total की गतिविधि फ़ोटो $current';
  }

  @override
  String get galleryOpen => 'तस्वीरें देखें';

  @override
  String get galleryZoomHint =>
      'ज़ूम करने के लिए पिंच करें · एक्सप्लोर करने के लिए स्वाइप करें';

  @override
  String get galleryPrevious => 'पिछला फ़ोटो';

  @override
  String get galleryNext => 'अगली फोटो';

  @override
  String get galleryZoomIn => 'ज़ूम इन';

  @override
  String get galleryZoomOut => 'ज़ूम रीसेट करें';

  @override
  String get detailsSharedMapLink => 'साझा मानचित्र लिंक';

  @override
  String get detailsMapLinkHint => 'होस्ट द्वारा साझा किया गया स्थान खोलें.';

  @override
  String get detailsMapSearchHint =>
      'मानचित्र में इस स्थल को खोजें; अपने मेज़बान के साथ बैठक स्थल की पुष्टि करें।';

  @override
  String get detailsOpenMapLink => 'मानचित्र लिंक खोलें';

  @override
  String get detailsSearchMaps => 'मानचित्र में खोजें';

  @override
  String get homeComingUpSubtitle => 'अगले 7 दिनों में खेल';

  @override
  String get homeLaterOn => 'बाद में';

  @override
  String get homeLaterSubtitle => 'अगले सप्ताह के बाद की गतिविधियाँ';

  @override
  String get detailsMapOpenFailed =>
      'मानचित्र नहीं खुल सके. कृपया पुन: प्रयास करें।';

  @override
  String get activityNowLive =>
      'आपकी गतिविधि अब लाइव है. लोग शामिल होने का अनुरोध करना शुरू कर सकते हैं.';

  @override
  String get nextGameStartsHere => 'आपका अगला गेम यहां शुरू होता है';

  @override
  String get turnSoundOff => 'ध्वनि बंद करें';

  @override
  String get turnSoundOn => 'ध्वनि चालू करें';

  @override
  String get goToHome => 'घर जाओ';

  @override
  String get yourActivityHub => 'आपका एक्टिविटी हब';

  @override
  String homeActivityHubPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'समीक्षा के लिए आपके पास $count लंबित अनुरोध हैं।',
      one: 'समीक्षा के लिए आपके पास 1 लंबित अनुरोध है।',
    );
    return '$_temp0';
  }

  @override
  String get homeActivityHubJoined => 'आपकी अगली सम्मिलित गतिविधि आ रही है.';

  @override
  String get homeActivityHubHosted => 'आपकी अगली होस्ट की गई गतिविधि आ रही है.';

  @override
  String get homeActivityHubEmpty =>
      'अभी तक कोई आगामी गतिविधियाँ नहीं. आरंभ करने के लिए एक बनाएं.';

  @override
  String get homeActivityHubRecommendation =>
      'आपके चयनित शहर में भविष्य की गतिविधि उपलब्ध है।';

  @override
  String get homeActivityHubError =>
      'आपकी गतिविधि का विवरण लोड नहीं किया जा सका.';

  @override
  String get homeReviewRequests => 'अनुरोधों की समीक्षा करें';

  @override
  String get homeViewActivity => 'गतिविधि देखें';

  @override
  String get homeManageActivity => 'गतिविधि प्रबंधित करें';

  @override
  String get homeCreateActivity => 'गतिविधि बनाएँ';

  @override
  String get homeGroupChat => 'समूह बातचीत';

  @override
  String get homeCityLoadError => 'शहरों को लोड नहीं किया जा सका';

  @override
  String get homeRetryCategories => 'श्रेणियाँ पुनः प्रयास करें';

  @override
  String get homeFeedNetworkError =>
      'गतिविधियाँ लोड नहीं की जा सकीं. अपना कनेक्शन जांचें और पुनः प्रयास करें।';

  @override
  String get homeFeedLoadError => 'गतिविधियाँ लोड करते समय कुछ गलत हो गया।';

  @override
  String get dismiss => 'नकार देना';

  @override
  String get notificationPermissionTitle => 'अपडेट रहें';

  @override
  String get notificationPermissionBody =>
      'जब कोई आपके स्थान पर शामिल होना चाहता है या जब आपको किसी स्थान पर स्वीकार किया जाता है तो हमें आपको सचेत करने के लिए अधिसूचना अनुमतियों की आवश्यकता होती है।';

  @override
  String get allow => 'अनुमति दें';

  @override
  String get notNow => 'अभी नहीं';

  @override
  String get full => 'भरा हुआ';

  @override
  String get host => 'मेज़बान';

  @override
  String get ofText => 'का';

  @override
  String get spots => 'स्पॉट';

  @override
  String get suggestedPlayingHours => 'खेलने के सुझाए गए घंटे';

  @override
  String get bestTimeToPlay => 'खेलने का सबसे अच्छा समय';

  @override
  String get mySportsSpaceTitle => 'मेरा खेल स्थान';

  @override
  String get statHosted => 'की मेजबानी';

  @override
  String get statUpcoming => 'आगामी';

  @override
  String get sportsJourney => 'मेरी खेल यात्रा';

  @override
  String get upcomingGames => 'आगामी खेल';

  @override
  String get pastActivities => 'पिछली गतिविधियां';

  @override
  String get hostedMatches => 'आयोजित मैच';

  @override
  String get joinedMatches => 'जुड़े हुए मैच';

  @override
  String get sportsInterests => 'खेल रुचियां';

  @override
  String get editInterests => 'रुचियाँ संपादित करें';

  @override
  String get noSportsInterests => 'अभी तक कोई खेल रुचियां नहीं जोड़ी गईं.';

  @override
  String get noJourneyActivities => 'इस अनुभाग में कोई गतिविधि नहीं.';

  @override
  String get achievementsTitle => 'खेल उपलब्धियाँ';

  @override
  String get achievementFirstHost => 'प्रथम मेज़बान';

  @override
  String get achievementFirstHostDesc => 'अपना पहला मैच आयोजित किया';

  @override
  String get achievementTeamPlayer => 'टीम के खिलाड़ी';

  @override
  String get achievementTeamPlayerDesc => 'एक खेल गतिविधि में शामिल हुए';

  @override
  String get achievementActiveAthlete => 'सक्रिय एथलीट';

  @override
  String get achievementActiveAthleteDesc => '5 खेल गतिविधियाँ पूरी कीं';

  @override
  String get achievementSportsLegend => 'खेल किंवदंती';

  @override
  String get achievementSportsLegendDesc => '10 खेल गतिविधियाँ पूरी कीं';

  @override
  String get quickActions => 'त्वरित कार्रवाई';

  @override
  String get quickActionFindGame => 'एक खेल खोजें';

  @override
  String get quickActionOrganize => 'मैच का आयोजन करें';

  @override
  String get quickActionMyMatches => 'मेरे मैच';

  @override
  String get quickActionChats => 'टीम चैट';

  @override
  String get participantRoleHost => 'मेज़बान';

  @override
  String get participantRolePlayer => 'खिलाड़ी';

  @override
  String get statusOpen => 'खुला';

  @override
  String get statusPending => 'लंबित';

  @override
  String get statusAccepted => 'स्वीकृत';

  @override
  String get statusRejected => 'अस्वीकार कर दिया';

  @override
  String get onboardingSkip => 'छोड़ें';

  @override
  String get onboardingBack => 'पीछे';

  @override
  String get onboardingGetStarted => 'शुरू करें';

  @override
  String get onboardingContinue => 'आगे बढ़ें';

  @override
  String get onboardingLetsPlay => 'चलो खेलें';

  @override
  String get onboardingAlreadyHaveAccount => 'क्या आपके पास पहले से खाता है? ';

  @override
  String get onboardingSignIn => 'साइन इन करें';

  @override
  String get onboardingSlide1Title => 'आपका खेल। आपकी टीम।';

  @override
  String get onboardingSlide1Tagline => 'भाई, टीम बनाओ! मैच जमाओ!';

  @override
  String get onboardingSlide1Desc =>
      'खिलाड़ी खोजें, टीम बनाएं और योजनाओं को असली मैच में बदलें।';

  @override
  String get onboardingSlide2Title => 'खिलाड़ी कम हैं? खेलभाई है ना!';

  @override
  String get onboardingSlide2Desc =>
      'अपने आस-पास ऐसे लोगों को खोजें जो आपके अगले खेल में शामिल होने के लिए तैयार हैं।';

  @override
  String get onboardingSlide3Title => 'गेम बनाओ। टीम बुलाओ।';

  @override
  String get onboardingSlide3Desc =>
      'मैच आयोजित करें, आस-पास की गतिविधियां खोजें और मैदान में उतरें।';

  @override
  String get onboardingSlide4Title => 'टीम बनी? अब मैच जमाओ!';

  @override
  String get onboardingSlide4Desc =>
      'साथियों के साथ चैट करें, योजना बनाएं और खेलने के लिए तैयार हो जाएं।';

  @override
  String get onboardingReadyHeading => 'तैयार, भाई? चलो खेलते हैं!';

  @override
  String get completedMatches => 'पूर्ण मैच';

  @override
  String get verifiedEmail => 'सत्यापित';
}
