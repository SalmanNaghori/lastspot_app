import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import '../../features/notifications/presentation/bloc/notifications_cubit.dart';
import '../base_import.dart';
import '../di/service_locator.dart';
import '../theme/app_motion.dart';
import '../utils/notification_permission_dialog.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_event.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';

class AuthenticatedAppShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AuthenticatedAppShell({super.key, required this.navigationShell});

  @override
  State<AuthenticatedAppShell> createState() => _AuthenticatedAppShellState();
}

class _AuthenticatedAppShellState extends State<AuthenticatedAppShell>
    with WidgetsBindingObserver {
  late NotificationsCubit _notificationsCubit;
  StreamSubscription? _newNotifSub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      context.read<AuthBloc>().add(AuthSessionValidationRequested());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
          body: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) => Stack(
              children: [
                widget.navigationShell,
                if (state is AuthSessionValidationInProgress)
                  Positioned.fill(
                    child: ColoredBox(
                      color: context.backgroundColor.withValues(alpha: 0.78),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: context.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                if (state is AuthSessionCheckUnavailable)
                  Positioned.fill(
                    child: ColoredBox(
                      color: context.backgroundColor.withValues(alpha: 0.96),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.cloud_off_outlined,
                                size: 36,
                                color: context.colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Text(
                                'Could not verify your session. Check your connection and try again.',
                                textAlign: TextAlign.center,
                                style: context.bodyLarge,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              FilledButton.icon(
                                onPressed: () => context.read<AuthBloc>().add(
                                  AuthSessionValidationRequested(),
                                ),
                                icon: const Icon(Icons.refresh),
                                label: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
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
