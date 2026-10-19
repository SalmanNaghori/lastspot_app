import 'package:flutter/widgets.dart';

/// Central tracker for chat screen visibility, active conversation, tab,
/// and application lifecycle state across the app.
class ChatVisibilityTracker extends NavigatorObserver
    with WidgetsBindingObserver {
  ChatVisibilityTracker() {
    WidgetsBinding.instance.addObserver(this);
    _appLifecycleState =
        WidgetsBinding.instance.lifecycleState ?? AppLifecycleState.resumed;
  }

  String? _activeConversationId;
  String? _activeChatType;
  String? _activeRequestId;
  int _activeTabIndex = 0; // 0: Home, 1: Explore, 2: Activities, 3: Chats
  bool _isConversationRouteActive = false;
  bool _isRouteCoveringShell = false;
  AppLifecycleState _appLifecycleState = AppLifecycleState.resumed;

  String? get activeConversationId => _activeConversationId;
  String? get activeChatType => _activeChatType;
  String? get activeRequestId => _activeRequestId;
  int get activeTabIndex => _activeTabIndex;
  AppLifecycleState get appLifecycleState => _appLifecycleState;
  bool get isRouteCoveringShell => _isRouteCoveringShell;

  bool get isAppForeground =>
      _appLifecycleState == AppLifecycleState.resumed ||
      _appLifecycleState == AppLifecycleState.inactive;

  /// True ONLY when the chat conversation screen is actively mounted, visible,
  /// and the application is in the foreground.
  bool get isConversationVisible =>
      _isConversationRouteActive &&
      _activeConversationId != null &&
      isAppForeground;

  /// True ONLY when the user is on the Chats tab with no full-screen route covering it.
  bool get isChatsListVisible =>
      !_isConversationRouteActive &&
      !_isRouteCoveringShell &&
      _activeTabIndex == 3 &&
      isAppForeground;

  void setActiveTab(int tabIndex) {
    _activeTabIndex = tabIndex;
  }

  void enterConversation({
    required String conversationId,
    String? chatType,
    String? requestId,
  }) {
    _activeConversationId = conversationId;
    _activeChatType = chatType;
    _activeRequestId = requestId;
    _isConversationRouteActive = true;
  }

  void leaveConversation(String conversationId) {
    if (_activeConversationId == conversationId) {
      _activeConversationId = null;
      _activeChatType = null;
      _activeRequestId = null;
      _isConversationRouteActive = false;
    }
  }

  bool isConversationCurrentlyVisible(String conversationId) {
    if (!isAppForeground) return false;
    if (!_isConversationRouteActive) return false;
    return _activeConversationId == conversationId;
  }

  bool isUserOnChatsList() => isChatsListVisible;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appLifecycleState = state;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _onRouteChanged(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      _onRouteChanged(previousRoute);
    } else {
      _isConversationRouteActive = false;
      _activeConversationId = null;
      _isRouteCoveringShell = false;
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) _onRouteChanged(newRoute);
  }

  void _onRouteChanged(Route<dynamic> route) {
    final name = route.settings.name;
    if (name != null) {
      if (name.contains('/chat/')) {
        _isConversationRouteActive = true;
        _isRouteCoveringShell = true;
      } else if (name == '/home' ||
          name == '/explore' ||
          name == '/activities' ||
          name == '/chats' ||
          name == '/') {
        _isConversationRouteActive = false;
        _activeConversationId = null;
        _isRouteCoveringShell = false;
      } else {
        _isConversationRouteActive = false;
        _activeConversationId = null;
        _isRouteCoveringShell = true;
      }
    }
  }

  void setRouteCoveringShell(bool isCovering) {
    _isRouteCoveringShell = isCovering;
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}
