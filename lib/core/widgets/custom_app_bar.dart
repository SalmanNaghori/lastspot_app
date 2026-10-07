import 'package:lastspot_app/core/base_import.dart';
import '../../features/notifications/presentation/bloc/notifications_cubit.dart';
import '../../features/notifications/presentation/bloc/notifications_state.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? titleWidget;
  final String? titleText;
  final List<Widget>? actions;
  final VoidCallback? onNotificationTap;
  final bool isDashboard;

  const CustomAppBar.dashboard({
    super.key,
    required BuildContext context,
    required String title,
    this.onNotificationTap,
  }) : titleText = title,
       titleWidget = null,
       actions = null,
       isDashboard = true;

  const CustomAppBar.defaultAppBar({super.key, required BuildContext context, required String title, this.actions})
    : titleText = title,
      titleWidget = null,
      onNotificationTap = null,
      isDashboard = false;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    if (isDashboard) {
      return AppBar(
        title: Text(
          titleText ?? '',
          style: TextStyle(fontSize: Dimensions.r24.dynamicSP, fontWeight: FontWeight.w800, color: context.textPrimary),
        ),
        backgroundColor: context.backgroundColor,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: AppTheme.systemUiOverlayStyle(context),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.notifications_none, size: Dimensions.r24.dynamicH, color: context.textPrimary),
                onPressed: onNotificationTap ?? () {
                  context.push(AppRoutes.notifications);
                },
              ),
              BlocBuilder<NotificationsCubit, NotificationsState>(
                builder: (context, state) {
                  int unreadCount = 0;
                  if (state is NotificationsLoaded) {
                    unreadCount = state.unreadCount;
                  }
                  if (unreadCount == 0) return const SizedBox.shrink();

                  return Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: AppColor.errorColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: context.backgroundColor, width: 1.5),
                      ),
                      constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                      child: Center(
                        child: Text(
                          unreadCount > 9 ? '9+' : unreadCount.toString(),
                          style: const TextStyle(color: AppColor.whiteColor, fontSize: 8, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(width: Dimensions.r8.dynamicW),
        ],
      );
    }

    return AppBar(
      title: Text(titleText ?? ''),
      backgroundColor: context.backgroundColor,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: AppTheme.systemUiOverlayStyle(context),
      actions: actions,
    );
  }
}
