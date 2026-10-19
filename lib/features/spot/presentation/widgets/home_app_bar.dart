import '../../../../core/base_import.dart';

/// Home's branded app bar, backed by the shared KhelBhai header.
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onNotificationTap;

  const HomeAppBar({super.key, this.onNotificationTap});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) =>
      KhelBhaiAppBar(onNotificationTap: onNotificationTap);
}
