import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import '../../features/notifications/presentation/bloc/notifications_cubit.dart';
import '../../features/auth/presentation/bloc/profile_cubit.dart';
import '../../features/chat/presentation/bloc/conversations_cubit.dart';
import '../../features/chat/presentation/bloc/conversations_state.dart';
import '../base_import.dart';
import '../utils/notification_permission_dialog.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_event.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../services/in_app_feedback_manager.dart';
import '../services/chat_visibility_tracker.dart';
import '../services/foreground_chat_notification_coordinator.dart';

class AuthenticatedAppShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AuthenticatedAppShell({super.key, required this.navigationShell});

  @override
  State<AuthenticatedAppShell> createState() => _AuthenticatedAppShellState();
}

class _AuthenticatedAppShellState extends State<AuthenticatedAppShell>
    with WidgetsBindingObserver {
  late NotificationsCubit _notificationsCubit;
  late ProfileCubit _profileCubit;
  late ConversationsCubit _conversationsCubit;
  StreamSubscription? _newNotifSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _notificationsCubit = sl<NotificationsCubit>();
    _profileCubit = sl<ProfileCubit>();
    _conversationsCubit = sl<ConversationsCubit>();
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (sl.isRegistered<ChatVisibilityTracker>()) {
      sl<ChatVisibilityTracker>().setActiveTab(
        widget.navigationShell.currentIndex,
      );
    }
    if (userId != null) {
      appFeedbackManager.setSessionActive(true);
      _notificationsCubit.initialize(userId);
      _profileCubit.fetchProfile(userId);
      _conversationsCubit.loadConversations();
    }

    _newNotifSub = _notificationsCubit.onNewNotification.listen((notif) {
      if (!mounted) return;
      final feedback = context.read<InAppFeedbackManager>();
      final data = Map<String, dynamic>.from(notif.data)
        ..putIfAbsent('type', () => notif.type);
      if (InAppFeedbackManager.isChatMessage(data, type: notif.type)) {
        _conversationsCubit.loadConversations(isRefresh: true);
        if (sl.isRegistered<ForegroundChatNotificationCoordinator>()) {
          final resolvedMsgId = data['message_id']?.toString() ?? notif.id;
          sl<ForegroundChatNotificationCoordinator>()
              .handleIncomingChatNotification(
                data: data,
                messageId: resolvedMsgId,
                title: notif.title,
                body: notif.body,
              );
        }
        return;
      }

      feedback.showNotification(
        title: notif.title,
        subtitle: notif.body,
        data: data,
        eventKeys: [
          'notification:${notif.id}',
          ..._notificationEventKeys(data),
        ],
        onTap: () {
          if (mounted) context.push(AppRoutes.notifications);
        },
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        NotificationPermissionDialog.requestPermissionWithDialog(context);
      }
    });
  }

  bool _precachedNavAssets = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_precachedNavAssets) {
      _precachedNavAssets = true;
      precacheImage(Assets.navigation.home3d.provider(), context);
      precacheImage(Assets.navigation.explore3d.provider(), context);
      precacheImage(Assets.navigation.create3d.provider(), context);
      precacheImage(Assets.navigation.activities3d.provider(), context);
      precacheImage(Assets.navigation.chats3d.provider(), context);
    }
  }

  List<String> _notificationEventKeys(Map<String, dynamic> data) => [
    for (final key in const ['event_id', 'notification_id', 'message_id', 'id'])
      if (data[key]?.toString().trim().isNotEmpty == true) 'event:${data[key]}',
  ];

  DateTime? _pausedAt;
  DateTime? _lastVerifiedAt;
  Timer? _resumeDebounceTimer;
  static const _sessionValidationFreshness = Duration(seconds: 30);
  static const _briefInactivityThreshold = Duration(seconds: 3);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _pausedAt ??= DateTime.now();
    } else if (state == AppLifecycleState.resumed && mounted) {
      _onAppResumed();
    }
  }

  void _onAppResumed() {
    final pausedDuration = _pausedAt != null
        ? DateTime.now().difference(_pausedAt!)
        : null;
    _pausedAt = null;

    // Avoid repeated checks if the app only briefly became inactive (e.g. notification shade)
    if (pausedDuration != null && pausedDuration < _briefInactivityThreshold) {
      return;
    }

    // Freshness policy: if verified within 30 seconds, avoid redundant verification
    if (_lastVerifiedAt != null &&
        DateTime.now().difference(_lastVerifiedAt!) <
            _sessionValidationFreshness) {
      return;
    }

    _resumeDebounceTimer?.cancel();
    _resumeDebounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      final authBloc = context.read<AuthBloc>();
      if (authBloc.state is Authenticated) {
        _lastVerifiedAt = DateTime.now();
        authBloc.add(AuthSessionValidationRequested());
      }
    });
  }

  @override
  void dispose() {
    _resumeDebounceTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _newNotifSub?.cancel();
    _profileCubit.close();
    if (sl.isRegistered<ConversationsCubit>()) {
      sl.resetLazySingleton<ConversationsCubit>();
    } else {
      _conversationsCubit.close();
    }
    super.dispose();
  }

  void _goBranch(int index) {
    FocusManager.instance.primaryFocus?.unfocus();
    appFeedbackManager.clearTransient();
    if (index == 2) {
      context.push(AppRoutes.create);
      return;
    }
    final branchIndex = index > 2 ? index - 1 : index;
    if (sl.isRegistered<ChatVisibilityTracker>()) {
      sl<ChatVisibilityTracker>().setActiveTab(branchIndex);
    }
    widget.navigationShell.goBranch(
      branchIndex,
      initialLocation: branchIndex == widget.navigationShell.currentIndex,
    );
  }

  int _getSelectedIndex() {
    final branchIndex = widget.navigationShell.currentIndex;
    return branchIndex >= 2 ? branchIndex + 1 : branchIndex;
  }

  @override
  Widget build(BuildContext context) {
    final overlayStyle = AppTheme.systemUiOverlayStyle(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _notificationsCubit),
          BlocProvider.value(value: _profileCubit),
          BlocProvider.value(value: _conversationsCubit),
        ],
        child: BlocBuilder<ConversationsCubit, ConversationsState>(
          builder: (context, convState) {
            int unreadChats = 0;
            if (convState is ConversationsLoaded) {
              unreadChats = convState.conversations.fold<int>(
                0,
                (sum, c) => sum + c.unreadCount,
              );
            }

            return Scaffold(
              backgroundColor: Colors.transparent,
              extendBody: true,
              body: widget.navigationShell,
              bottomNavigationBar: LastSpotBottomNavigationBar(
                selectedIndex: _getSelectedIndex(),
                onDestinationSelected: _goBranch,
                chatsUnreadCount: unreadChats,
              ),
            );
          },
        ),
      ),
    );
  }
}
