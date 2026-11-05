import 'package:lastspot_app/core/base_import.dart';

/// Standard app bar for secondary screens with back navigation.
/// For authenticated dashboard screens, delegates to [KhelBhaiAppBar].
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? titleWidget;
  final String? titleText;
  final List<Widget>? actions;
  final VoidCallback? onNotificationTap;
  final bool isDashboard;
  final bool showProfileAvatar;

  const CustomAppBar({
    super.key,
    this.titleText,
    this.titleWidget,
    this.actions,
  }) : isDashboard = false,
       showProfileAvatar = false,
       onNotificationTap = null;

  const CustomAppBar.defaultAppBar({
    Key? key,
    BuildContext? context,
    required String title,
    List<Widget>? actions,
  }) : this(key: key, titleText: title, actions: actions);

  const CustomAppBar.dashboard({
    super.key,
    BuildContext? context,
    String? title,
    this.onNotificationTap,
    this.showProfileAvatar = true,
  }) : titleText = title,
       titleWidget = null,
       actions = null,
       isDashboard = true;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    if (isDashboard) {
      return KhelBhaiAppBar(onNotificationTap: onNotificationTap);
    }

    return AppBar(
      automaticallyImplyLeading: false,
      leading: KhelBhaiBackButton.leading(context),
      title:
          titleWidget ??
          Text(
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
