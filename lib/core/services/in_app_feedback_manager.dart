import 'package:flutter/material.dart';
import 'package:lastspot_app/core/l10n/app_localizations.dart';

class InAppFeedbackManager extends NavigatorObserver {
  InAppFeedbackManager({GlobalKey<ScaffoldMessengerState>? messengerKey})
    : messengerKey = messengerKey ?? GlobalKey<ScaffoldMessengerState>();

  static const _transientDuration = Duration(seconds: 3);
  static const _notificationDuration = Duration(seconds: 5);
  static const _persistentDuration = Duration(minutes: 10);
  static const _eventRetention = Duration(minutes: 1);

  final GlobalKey<ScaffoldMessengerState> messengerKey;
  final Map<String, DateTime> _seenEvents = {};

  int _messageGeneration = 0;
  int? _activeMessageGeneration;
  bool _activeMessageIsPersistent = false;
  String? _activeConversationId;
  String? _activeRequestId;
  String? _activeMessageConversationId;
  String? _activeMessageRequestId;
  bool _sessionActive = false;

  bool get hasVisibleMessage => _activeMessageGeneration != null;
  String get newMessageLabel => _localizations?.newMessage ?? 'New message';

  void setSessionActive(bool active) {
    _sessionActive = active;
    if (!active) endSession();
  }

  void endSession() {
    _sessionActive = false;
    _activeConversationId = null;
    _activeRequestId = null;
    _seenEvents.clear();
    _removeCurrentMessage();
  }

  void openConversation(String conversationId, {String? requestId}) {
    _activeConversationId = conversationId;
    _activeRequestId = requestId;
    if (_activeMessageConversationId == conversationId ||
        (requestId != null && _activeMessageRequestId == requestId)) {
      _removeCurrentMessage();
    }
  }

  void openConversationRequest(String requestId) {
    _activeConversationId = null;
    _activeRequestId = requestId;
    if (_activeMessageRequestId == requestId) _removeCurrentMessage();
  }

  void closeConversation(String conversationId, {String? requestId}) {
    if (_activeConversationId == conversationId) {
      _activeConversationId = null;
      _activeRequestId = null;
    }
    if (requestId != null && _activeRequestId == requestId) {
      _activeRequestId = null;
    }
  }

  void dismissConversation(String conversationId) {
    if (_activeMessageConversationId == conversationId ||
        _activeMessageRequestId == conversationId) {
      _removeCurrentMessage();
    }
  }

  bool showFeedback(
    SnackBar snackBar, {
    bool isPersistent = false,
    bool preserveOnNavigation = false,
    Iterable<String> eventKeys = const [],
    String? conversationId,
    String? requestId,
    Duration? duration,
  }) {
    final messenger = messengerKey.currentState;
    if (messenger == null || !messenger.mounted) return false;

    final keys = eventKeys.where((key) => key.trim().isNotEmpty).toSet();
    if (_activeMessageIsPersistent && !isPersistent) return false;
    if (_wasRecentlyShown(keys)) return false;

    final generation = ++_messageGeneration;
    _activeMessageGeneration = generation;
    final preserve = isPersistent || preserveOnNavigation;
    _activeMessageIsPersistent = preserve;
    _activeMessageConversationId = conversationId;
    _activeMessageRequestId = requestId;

    messenger.removeCurrentSnackBar();
    messenger.clearSnackBars();
    final action = snackBar.action ?? (preserve ? _dismissAction() : null);
    final selectedDuration =
        duration ?? (preserve ? _persistentDuration : _transientDuration);
    final controller = messenger.showSnackBar(
      SnackBar(
        key: snackBar.key,
        content: snackBar.content,
        backgroundColor: snackBar.backgroundColor,
        elevation: snackBar.elevation,
        margin: snackBar.margin,
        padding: snackBar.padding,
        width: snackBar.width,
        shape: snackBar.shape,
        behavior: snackBar.behavior,
        action: action,
        actionOverflowThreshold: snackBar.actionOverflowThreshold,
        duration: selectedDuration,
        onVisible: snackBar.onVisible,
        dismissDirection: snackBar.dismissDirection,
        clipBehavior: snackBar.clipBehavior,
        showCloseIcon: snackBar.showCloseIcon,
        closeIconColor: snackBar.closeIconColor,
      ),
    );
    controller.closed.then((_) {
      if (_activeMessageGeneration == generation) {
        _activeMessageGeneration = null;
        _activeMessageIsPersistent = false;
        _activeMessageConversationId = null;
        _activeMessageRequestId = null;
      }
    });
    return true;
  }

  bool showNotification({
    required String title,
    String? subtitle,
    required Map<String, dynamic> data,
    required Iterable<String> eventKeys,
    required VoidCallback onTap,
    String? conversationId,
  }) {
    if (!_sessionActive) return false;
    if (_isConversationOpen(conversationId, data)) {
      dismissConversation(
        conversationId ??
            conversationIdFrom(data) ??
            _stringValue(data, const ['request_id', 'requestId'])!,
      );
      return false;
    }

    final generation = _messageGeneration + 1;
    final localizations = _localizations;
    final content = Builder(
      builder: (context) {
        final foreground = Theme.of(context).colorScheme.onInverseSurface;
        return InkWell(
          onTap: () => _tapNotification(generation, onTap),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Icon(Icons.notifications_outlined, color: foreground),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: foreground),
                      ),
                      if (subtitle?.trim().isNotEmpty == true)
                        Text(
                          subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12, color: foreground),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    return showFeedback(
      SnackBar(
        content: content,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: localizations?.dismiss ?? 'Dismiss',
          onPressed: () => _removeMessage(generation),
        ),
      ),
      eventKeys: _notificationEventKeys(data, eventKeys),
      conversationId: conversationId,
      requestId: _stringValue(data, const ['request_id', 'requestId']),
      duration: _notificationDuration,
    );
  }

  bool showIncomingChatMessage({
    required Map<String, dynamic> data,
    required String senderName,
    String? activityName,
    String? preview,
    required Iterable<String> eventKeys,
    required VoidCallback onTap,
  }) {
    final conversationId = _stringValue(data, const [
      'conversation_id',
      'conversationId',
    ]);
    if (conversationId == null ||
        !isSafeRouteIdentifier(conversationId) ||
        !_sessionActive) {
      return false;
    }
    if (_isConversationOpen(conversationId, data)) {
      dismissConversation(conversationId);
      return false;
    }

    final generation = _messageGeneration + 1;
    final localizations = _localizations;
    final details = activityName?.trim();
    final content = Builder(
      builder: (context) {
        final foreground = Theme.of(context).colorScheme.onInverseSurface;
        return InkWell(
          onTap: () => _tapNotification(generation, onTap),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Icon(Icons.chat_bubble_outline, color: foreground),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        senderName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: foreground),
                      ),
                      if (details?.isNotEmpty == true)
                        Text(
                          details!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12, color: foreground),
                        )
                      else if (preview?.trim().isNotEmpty == true)
                        Text(
                          preview!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12, color: foreground),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    return showFeedback(
      SnackBar(
        content: content,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: localizations?.dismiss ?? 'Dismiss',
          onPressed: () => _removeMessage(generation),
        ),
      ),
      eventKeys: _notificationEventKeys(data, eventKeys),
      conversationId: conversationId,
      requestId: _stringValue(data, const ['request_id', 'requestId']),
      duration: _notificationDuration,
    );
  }

  static bool isChatMessage(Map<String, dynamic> data, {String? type}) {
    final normalized = (type ?? data['type'] ?? data['notification_type'])
        ?.toString()
        .toLowerCase()
        .replaceAll('-', '_');
    return const {
          'chat',
          'chat_message',
          'new_chat_message',
          'new_message',
          'message',
        }.contains(normalized) ||
        (conversationIdFrom(data) != null &&
            _stringValue(data, const ['message_id', 'messageId']) != null);
  }

  static String? conversationIdFrom(Map<String, dynamic> data) =>
      _stringValue(data, const ['conversation_id', 'conversationId']);

  static bool isSafeRouteIdentifier(String value) =>
      RegExp(r'^[A-Za-z0-9_-]{1,128}$').hasMatch(value);

  static String? senderNameFrom(Map<String, dynamic> data) => _stringValue(
    data,
    const ['sender_name', 'senderName', 'sender', 'title'],
  );

  static String? activityNameFrom(Map<String, dynamic> data) => _stringValue(
    data,
    const ['activity_title', 'activity_name', 'request_title'],
  );

  bool _isConversationOpen(String? conversationId, Map<String, dynamic> data) {
    final requestId = _stringValue(data, const ['request_id', 'requestId']);
    return (conversationId != null &&
            _activeConversationId == conversationId) ||
        (requestId != null && _activeRequestId == requestId);
  }

  static List<String> _notificationEventKeys(
    Map<String, dynamic> data,
    Iterable<String> eventKeys,
  ) => [
    ...eventKeys,
    for (final key in const ['event_id', 'notification_id', 'message_id', 'id'])
      ...[
        _stringValue(data, [key]),
      ].whereType<String>(),
  ];

  static String? _stringValue(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      final value = data[key]?.toString().trim();
      if (value != null && value.isNotEmpty) return value;
    }
    return null;
  }

  bool _wasRecentlyShown(Set<String> eventKeys) {
    if (eventKeys.isEmpty) return false;
    final now = DateTime.now();
    _seenEvents.removeWhere(
      (_, seenAt) => now.difference(seenAt) > _eventRetention,
    );
    if (eventKeys.any(_seenEvents.containsKey)) return true;
    for (final key in eventKeys) {
      _seenEvents[key] = now;
    }
    return false;
  }

  SnackBarAction _dismissAction() => SnackBarAction(
    label: _localizations?.dismiss ?? 'Dismiss',
    onPressed: _removeCurrentMessage,
  );

  void _tapNotification(int generation, VoidCallback onTap) {
    if (_activeMessageGeneration != generation || !_sessionActive) return;
    _removeMessage(generation);
    onTap();
  }

  void _removeMessage(int generation) {
    if (_activeMessageGeneration == generation) _removeCurrentMessage();
  }

  AppLocalizations? get _localizations {
    final context = messengerKey.currentContext;
    return context == null ? null : AppLocalizations.of(context);
  }

  void clearTransient() {
    if (!_activeMessageIsPersistent) _removeCurrentMessage();
  }

  void clearAll() => _removeCurrentMessage();

  void _removeCurrentMessage() {
    final messenger = messengerKey.currentState;
    if (messenger != null && messenger.mounted) {
      messenger.removeCurrentSnackBar();
      messenger.clearSnackBars();
    }
    _activeMessageGeneration = null;
    _activeMessageIsPersistent = false;
    _activeMessageConversationId = null;
    _activeMessageRequestId = null;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    clearTransient();
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    clearTransient();
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    clearTransient();
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    clearTransient();
    super.didRemove(route, previousRoute);
  }
}

final appFeedbackManager = InAppFeedbackManager();
