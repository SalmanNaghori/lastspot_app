class ApiEndpoints {
  // Auth Operations
  static const String authSignUp = 'Auth.signUp';
  static const String authSignIn = 'Auth.signIn';
  static const String authSignOut = 'Auth.signOut';
  static const String authVerifyOtp = 'Auth.verifyOtp';
  static const String authResendOtp = 'Auth.resendOtp';
  static const String authResetPassword = 'Auth.sendPasswordResetEmail';

  // Profile Operations
  static const String profileGet = 'Profile.getProfile';
  static const String profileUpdate = 'Profile.updateProfile';
  static const String profileUploadAvatar = 'Profile.uploadAvatar';

  // Device Operations
  static const String deviceRegister = 'Device.registerDevice';

  // Category Operations
  static const String categoryGetAll = 'Category.getCategories';

  // City Operations
  static const String cityGetActive = 'City.getActiveCities';

  // Spot / Activities Operations
  static const String spotGetFeed = 'Spot.getFeedPosts';
  static const String spotGetExplore = 'Spot.getExplorePosts';
  static const String spotGetDetails = 'Spot.getSpotDetails';
  static const String spotCreate = 'Spot.createRequest';
  static const String spotUpdate = 'Spot.updateRequest';
  static const String spotRequestJoin = 'Spot.requestToJoin';
  static const String spotUpdateJoinRequest = 'Spot.updateJoinRequestStatus';
  static const String spotGetConfirmedPlayers = 'Spot.getConfirmedPlayers';
  static const String spotStreamPendingRequests = 'Spot.streamPendingRequests';
  static const String spotGetUserActivities = 'Spot.getUserActivities';

  // Table Names
  static const String tableProfiles = 'profiles';
  static const String tableUserDevices = 'user_devices';
  static const String tableCategories = 'categories';
  static const String tableCities = 'cities';
  static const String tableRequests = 'requests';
  static const String tableJoinRequests = 'join_requests';
  static const String tableRequestParticipants = 'request_participants';

  // Storage Buckets
  static const String bucketProfiles = 'profiles';
  static const String bucketRequests = 'requests';
}
