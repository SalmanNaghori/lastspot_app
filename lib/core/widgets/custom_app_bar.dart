import 'package:lastspot_app/core/base_import.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/notifications/presentation/bloc/notifications_cubit.dart';
import '../../features/notifications/presentation/bloc/notifications_state.dart';

class CustomAppBar extends AppBar {
  CustomAppBar.dashboard({
    super.key,
    required BuildContext context,
    required String title,
    VoidCallback? onNotificationTap,
  }) : super(
         title: Text(title),
         backgroundColor: context.backgroundColor,
         actions: [
           Stack(
             alignment: Alignment.center,
             children: [
               IconButton(
                 icon: Icon(
                   Icons.notifications_none,
                   size: Dimensions.r24.dynamicH,
                   color: context.textPrimary,
                 ),
                 onPressed: onNotificationTap ?? () {},
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
                         border: Border.all(
                           color: context.backgroundColor,
                           width: 1.5,
                         ),
                       ),
                       constraints: const BoxConstraints(
                         minWidth: 14,
                         minHeight: 14,
                       ),
                       child: Center(
                         child: Text(
                           unreadCount > 9 ? '9+' : unreadCount.toString(),
                           style: const TextStyle(
                             color: AppColor.whiteColor,
                             fontSize: 8,
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
           ),
           SizedBox(width: Dimensions.r8.dynamicW),
         ],
       );

  CustomAppBar.defaultAppBar({
    super.key,
    required BuildContext context,
    required String title,
    super.actions,
  }) : super(title: Text(title), backgroundColor: context.backgroundColor);
}
