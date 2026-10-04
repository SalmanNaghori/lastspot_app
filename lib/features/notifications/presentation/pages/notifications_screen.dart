import 'package:lastspot_app/core/base_import.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/notifications_list_cubit.dart';
import 'notifications_screen_mobile.dart';
import 'notifications_screen_tablet.dart';
import '../../../../core/di/service_locator.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<NotificationsListCubit>()..fetchNotifications(refresh: true),
      child: const ResponsiveLayout(
        mobile: NotificationsScreenMobile(),
        tablet: NotificationsScreenTablet(),
      ),
    );
  }
}
