/// Centralized route definitions for LastSpot application navigation.
/// Defines route paths and helper methods to avoid hardcoding strings.
class AppRoutes {
  AppRoutes._();

  // Root & Startup Routes
  static const String splash = '/';
  static const String maintenance = '/maintenance';
  static const String forceUpdate = '/force-update';
  static const String authCheck = '/auth-check';

  // Authentication Routes
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String profileSetup = '/profile-setup';
  static const String accountStatus = '/account-status';

  // Authenticated App Shell Tabs (Bottom Navigation)
  static const String home = '/home';
  static const String explore = '/explore';
  static const String create = '/create';
  static const String activities = '/activities';
  static const String profile = '/profile';

  // Spot Feature Routes
  static const String spotDetails = '/spot/:id';
  static String spotDetailsPath(String id) => '/spot/$id';

  static const String manageRequests = '/manage-requests/:id';
  static String manageRequestsPath(String id) => '/manage-requests/$id';

  static const String chat = '/chat/:id';
  static String chatPath(String id) => '/chat/$id';

  // Profile & Settings
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';

  // Notifications & Reports
  static const String notifications = '/notifications';

  static const String reportUser = '/report/user/:id';
  static String reportUserPath(String id) => '/report/user/$id';

  static const String reportActivity = '/report/activity/:id';
  static String reportActivityPath(String id) => '/report/activity/$id';
}
