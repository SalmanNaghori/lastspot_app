import 'package:lastspot_app/core/base_import.dart';

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
               Positioned(
                 right: 8,
                 top: 8,
                 child: Container(
                   width: 10,
                   height: 10,
                   decoration: BoxDecoration(
                     color: context.accentColor,
                     shape: BoxShape.circle,
                     border: Border.all(color: context.surfaceColor, width: 2),
                   ),
                 ),
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
