import '../../../../core/base_import.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/notifications/presentation/bloc/notifications_cubit.dart';
import '../../../../features/notifications/presentation/bloc/notifications_state.dart';

/// Pinned application bar displaying the LastSpot brand logo and notification action.
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onNotificationTap;

  const HomeAppBar({super.key, this.onNotificationTap});

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
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: Dimensions.r28.dynamicW,
            height: Dimensions.r28.dynamicH,
            decoration: BoxDecoration(
              color: context.primaryColor,
              borderRadius: BorderRadius.circular(Dimensions.r8.dynamicR),
            ),
            child: Icon(
              Icons.location_on,
              color: AppColor.whiteColor,
              size: Dimensions.r16.dynamicH,
            ),
          ),
          SizedBox(width: Dimensions.r8.dynamicW),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: Dimensions.r20.dynamicSP,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
              children: [
                TextSpan(
                  text: AppString.appNamePrefix,
                  style: TextStyle(color: context.textPrimary),
                ),
                TextSpan(
                  text: AppString.appNameSuffix,
                  style: TextStyle(color: context.primaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: Dimensions.r8.dynamicW),
          child: Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.notifications_outlined,
                  size: Dimensions.r24.dynamicH,
                  color: context.textPrimary,
                ),
                onPressed: onNotificationTap,
              ),
              BlocBuilder<NotificationsCubit, NotificationsState>(
                builder: (context, state) {
                  int unreadCount = 0;
                  if (state is NotificationsLoaded) {
                    unreadCount = state.unreadCount;
                  }
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
          ),
        ),
      ],
    );
  }
}
