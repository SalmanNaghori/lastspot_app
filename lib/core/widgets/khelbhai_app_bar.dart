import '../base_import.dart';
import '../../features/notifications/presentation/bloc/notifications_cubit.dart';
import '../../features/notifications/presentation/bloc/notifications_state.dart';

/// The branded app bar used by authenticated dashboard screens.
///
/// Keeps the approved theme-aware logo, current-user avatar and live unread
/// notification count aligned in one reusable component.
class KhelBhaiAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onNotificationTap;

  const KhelBhaiAppBar({super.key, this.onNotificationTap});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: context.backgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: AppTheme.systemUiOverlayStyle(context),
      centerTitle: false,
      titleSpacing: Dimensions.r16.dynamicW,
      title: const KhelBhaiLogo(),
      actions: [
        const UserProfileAvatar(),
        Padding(
          padding: EdgeInsets.only(right: Dimensions.r8.dynamicW),
          child: NotificationActionButton(
            onPressed:
                onNotificationTap ??
                () => context.push(AppRoutes.notifications),
          ),
        ),
      ],
    );
  }
}

/// Notification action with the unread count supplied by [NotificationsCubit].
class NotificationActionButton extends StatelessWidget {
  final VoidCallback onPressed;

  const NotificationActionButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          tooltip: context.loc.notifications,
          icon: Icon(
            Icons.notifications_outlined,
            size: Dimensions.r24.dynamicH,
            color: context.textPrimary,
          ),
          onPressed: onPressed,
        ),
        BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            final unreadCount = state is NotificationsLoaded
                ? state.unreadCount
                : 0;
            if (unreadCount == 0) return const SizedBox.shrink();

            return Positioned(
              top: Dimensions.r6.dynamicH,
              right: Dimensions.r6.dynamicW,
              child: Container(
                padding: EdgeInsets.all(Dimensions.r2.dynamicW),
                decoration: BoxDecoration(
                  color: AppColor.errorColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: context.backgroundColor,
                    width: 1.5,
                  ),
                ),
                constraints: BoxConstraints(
                  minWidth: Dimensions.r14.dynamicW,
                  minHeight: Dimensions.r14.dynamicH,
                ),
                child: Center(
                  child: Text(
                    unreadCount > 9 ? '9+' : unreadCount.toString(),
                    style: TextStyle(
                      color: AppColor.whiteColor,
                      fontSize: Dimensions.r8.dynamicSP,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
