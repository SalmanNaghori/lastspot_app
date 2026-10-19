/// Centralized route definitions for LastSpot application navigation.
/// Defines route paths and helper methods to avoid hardcoding strings.
class AppRoutes {
  AppRoutes._();

  // Root & Startup Routes
  static const String splash = '/';
  static const String maintenance = '/maintenance';
  static const String forceUpdate = '/force-update';
  static const String onboarding = '/onboarding';

  // Authentication Routes
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String profileSetup = '/profile-setup';
  static const String accountStatus = '/account-status';

  // Authenticated App Shell Tabs (Bottom Navigation)
  static const String home = '/home';
  static const String explore = '/explore';
  static String exploreCategoryPath(String categoryId) => Uri(
    path: explore,
    queryParameters: {'category_id': categoryId},
  ).toString();
  static const String create = '/create';
  static const String createSuccess = '/create-success';
  static const String activities = '/activities';
  static const String chats = '/chats';
  static const String profile = '/profile';

  // Spot Feature Routes
  static const String spotDetails = '/spot/:id';
  static String spotDetailsPath(String id) => '/spot/$id';

  static const String editSpot = '/edit-spot';
  static const String previewSpot = '/preview-spot';

  static const String manageRequests = '/manage-requests/:id';
  static String manageRequestsPath(String id) => '/manage-requests/$id';

  static const String chat = '/chat/:id';
  static String chatPath(String id) => '/chat/$id';
  static String conversationChatPath(
    String conversationId, {
    bool isDirect = false,
    String? name,
    String? activityTitle,
    String? requestId,
    String? avatarUrl,
    String? category,
  }) => Uri(
    path: chatPath(conversationId),
    queryParameters: {
      'is_conversation': 'true',
      'is_direct': isDirect.toString(),
      if (name?.trim().isNotEmpty == true) 'name': name!.trim(),
      if (activityTitle?.trim().isNotEmpty == true)
        'activity_title': activityTitle!.trim(),
      if (requestId?.trim().isNotEmpty == true) 'request_id': requestId!.trim(),
      if (avatarUrl?.trim().isNotEmpty == true) 'avatar_url': avatarUrl!.trim(),
      if (category?.trim().isNotEmpty == true) 'category': category!.trim(),
    },
  ).toString();

  static String activityGroupChatPath(String requestId, {String? title}) => Uri(
    path: chatPath(requestId),
    queryParameters: {
      'is_direct': 'false',
      if (title?.trim().isNotEmpty == true) 'activity_title': title!.trim(),
    },
  ).toString();

  static const String groupInfo = '/chat/:id/info';
  static String groupInfoPath(String id) => '/chat/$id/info';

  // Profile & Settings
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';
  static const String helpSupport = '/help-support';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsConditions = '/terms-conditions';

  // Notifications & Reports
  static const String notifications = '/notifications';

  static const String reportUser = '/report/user/:id';
  static String reportUserPath(String id) => '/report/user/$id';

  static const String reportActivity = '/report/activity/:id';
  static String reportActivityPath(String id) => '/report/activity/$id';
}
