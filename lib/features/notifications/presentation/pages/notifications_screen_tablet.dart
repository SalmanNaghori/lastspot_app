import 'package:lastspot_app/core/base_import.dart';
import 'notifications_screen_mobile.dart';

class NotificationsScreenTablet extends StatelessWidget {
  const NotificationsScreenTablet({super.key});

  @override
  Widget build(BuildContext context) {
    // For now, tablet uses mobile layout centered
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: Center(
        child: Container(
          width: 600, // max width for tablet view
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: context.borderColor),
              right: BorderSide(color: context.borderColor),
            ),
          ),
          child: const NotificationsScreenMobile(),
        ),
      ),
    );
  }
}
