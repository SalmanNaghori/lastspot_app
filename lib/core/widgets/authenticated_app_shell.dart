import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/notifications/presentation/bloc/notifications_cubit.dart';
import '../base_import.dart';
import '../di/service_locator.dart';
import '../utils/notification_permission_dialog.dart';

class AuthenticatedAppShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AuthenticatedAppShell({super.key, required this.navigationShell});

  @override
  State<AuthenticatedAppShell> createState() => _AuthenticatedAppShellState();
}

class _AuthenticatedAppShellState extends State<AuthenticatedAppShell> {
  late NotificationsCubit _notificationsCubit;
  StreamSubscription? _newNotifSub;

  @override
  void initState() {
    super.initState();
    _notificationsCubit = sl<NotificationsCubit>();
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      _notificationsCubit.initialize(userId);
    }

    _newNotifSub = _notificationsCubit.onNewNotification.listen((notif) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(notif.title),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'View',
              onPressed: () {
                context.push(AppRoutes.notifications);
              },
            ),
          ),
        );
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        NotificationPermissionDialog.requestPermissionWithDialog(context);
      }
    });
  }

  @override
  void dispose() {
    _newNotifSub?.cancel();
    super.dispose();
  }

  void _goBranch(int index) {
    widget.navigationShell.goBranch(index, initialLocation: index == widget.navigationShell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final overlayStyle = AppTheme.systemUiOverlayStyle(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: BlocProvider.value(
        value: _notificationsCubit,
        child: Scaffold(
          backgroundColor: context.backgroundColor,
          body: widget.navigationShell,
          bottomNavigationBar: NavigationBar(
            selectedIndex: widget.navigationShell.currentIndex,
            onDestinationSelected: _goBranch,
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home),
                label: loc.navHome,
              ),
              NavigationDestination(
                icon: const Icon(Icons.search_outlined),
                selectedIcon: const Icon(Icons.search),
                label: loc.navExplore,
              ),
              NavigationDestination(
                icon: const Icon(Icons.add_circle_outline),
                selectedIcon: const Icon(Icons.add_circle),
                label: loc.navCreate,
              ),
              NavigationDestination(
                icon: const Icon(Icons.calendar_today_outlined),
                selectedIcon: const Icon(Icons.calendar_today),
                label: loc.navActivities,
              ),
              NavigationDestination(
                icon: const Icon(Icons.person_outline),
                selectedIcon: const Icon(Icons.person),
                label: loc.navProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
