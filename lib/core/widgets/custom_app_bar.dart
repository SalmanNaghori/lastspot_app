import 'package:lastspot_app/core/base_import.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? titleWidget;
  final String? titleText;
  final List<Widget>? actions;
  final VoidCallback? onNotificationTap;
  final bool isDashboard;
  final bool showProfileAvatar;

  const CustomAppBar.dashboard({
    super.key,
    required BuildContext context,
    String? title,
    this.onNotificationTap,
    this.showProfileAvatar = true,
  }) : titleText = title,
       titleWidget = null,
       actions = null,
       isDashboard = true;

  const CustomAppBar.defaultAppBar({
    super.key,
    required BuildContext context,
    required String title,
    this.actions,
  }) : titleText = title,
       titleWidget = null,
       onNotificationTap = null,
       isDashboard = false,
       showProfileAvatar = false;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    if (isDashboard) {
      return AppBar(
        title: const KhelBhaiLogo(),
        backgroundColor: context.backgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: AppTheme.systemUiOverlayStyle(context),
        centerTitle: false,
        titleSpacing: Dimensions.r16.dynamicW,
        actions: [
          if (showProfileAvatar) const UserProfileAvatar(),
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

    return AppBar(
      title: Text(
        titleText ?? '',
        style: TextStyle(
          color: context.textPrimary,
          fontSize: Dimensions.r18.dynamicSP,
          fontWeight: FontWeight.w700,
        ),
      ),
      backgroundColor: context.backgroundColor,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: AppTheme.systemUiOverlayStyle(context),
      actions: actions,
    );
  }
}
