import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/notifications/presentation/bloc/notifications_cubit.dart';
import '../base_import.dart';
import '../di/service_locator.dart';
import '../theme/app_motion.dart';
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
    if (index == 2) {
      context.push(AppRoutes.create);
      return;
    }
    final branchIndex = index > 2 ? index - 1 : index;
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
    final loc = context.loc;
    final overlayStyle = AppTheme.systemUiOverlayStyle(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: BlocProvider.value(
        value: _notificationsCubit,
        child: Scaffold(
          backgroundColor: context.backgroundColor,
          body: widget.navigationShell,
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.sm,
              0,
              AppSpacing.sm,
              AppSpacing.sm,
            ),
            child: ClipRRect(
              borderRadius: AppRadius.xxlBorderRadius,
              child: NavigationBar(
                animationDuration: AppMotion.duration(
                  context,
                  AppMotion.standard,
                ),
                selectedIndex: _getSelectedIndex(),
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
                    icon: Container(
                      padding: const EdgeInsets.all(AppSpacing.smLg),
                      decoration: BoxDecoration(
                        color: context.colorScheme.secondaryContainer,
                        borderRadius: AppRadius.lgBorderRadius,
                      ),
                      child: Icon(
                        Icons.add_rounded,
                        color: context.colorScheme.onSecondaryContainer,
                      ),
                    ),
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
        ),
      ),
    );
  }
}
