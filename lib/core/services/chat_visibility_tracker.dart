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
  String? _activeRecipientUserId;
  int _activeTabIndex = 0; // 0: Home, 1: Explore, 2: Activities, 3: Chats
  bool _isConversationRouteActive = false;
  bool _isRouteCoveringShell = false;
  AppLifecycleState _appLifecycleState = AppLifecycleState.resumed;

  String? get activeConversationId => _activeConversationId;
  String? get activeChatType => _activeChatType;
  String? get activeRequestId => _activeRequestId;
  String? get activeRecipientUserId => _activeRecipientUserId;
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
    String? recipientUserId,
  }) {
    _activeConversationId = conversationId;
    _activeChatType = chatType;
    _activeRequestId = requestId;
    _activeRecipientUserId = recipientUserId;
    _isConversationRouteActive = true;
  }

  void leaveConversation({String? conversationId, String? requestId}) {
    if (conversationId != null && _activeConversationId == conversationId) {
      _activeConversationId = null;
      _activeChatType = null;
      _activeRequestId = null;
      _activeRecipientUserId = null;
      _isConversationRouteActive = false;
    } else if (requestId != null && _activeRequestId == requestId) {
      _activeConversationId = null;
      _activeChatType = null;
      _activeRequestId = null;
      _activeRecipientUserId = null;
      _isConversationRouteActive = false;
    } else if (conversationId == null && requestId == null) {
      _activeConversationId = null;
      _activeChatType = null;
      _activeRequestId = null;
      _activeRecipientUserId = null;
      _isConversationRouteActive = false;
    }
  }

  /// Checks if the user is currently looking at this exact chat.
  /// Matches by conversationId, requestId (for group/activity chats),
  /// or recipientUserId (for direct 1-on-1 chats).
  bool isConversationCurrentlyVisible({
    String? conversationId,
    String? requestId,
    String? senderId,
  }) {
    if (!isAppForeground) return false;
    if (!_isConversationRouteActive) return false;

    // 1. Match by conversation ID
    if (conversationId != null &&
        _activeConversationId != null &&
        _activeConversationId == conversationId) {
      return true;
    }

    // 2. Match by request / activity ID
    if (requestId != null &&
        _activeRequestId != null &&
        _activeRequestId == requestId) {
      return true;
    }

    // 3. Match direct chat: User A is chatting with User B (_activeRecipientUserId),
    // and incoming message is from User B (senderId == _activeRecipientUserId)
    if (_activeChatType == 'direct' &&
        _activeRecipientUserId != null &&
        senderId != null &&
        _activeRecipientUserId == senderId) {
      return true;
    }

    return false;
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
          name == '/profile' ||
          name == '/') {
        _isConversationRouteActive = false;
        _activeConversationId = null;
        _activeRequestId = null;
        _activeRecipientUserId = null;
        _isRouteCoveringShell = false;
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

final chatVisibilityTracker = ChatVisibilityTracker();
