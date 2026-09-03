import '../../../../core/base_import.dart';

/// Pinned application bar displaying the LastSpot brand logo and notification action.
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onNotificationTap;

  const HomeAppBar({
    super.key,
    this.onNotificationTap,
  });

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
              color: AppColor.primaryColor,
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
                const TextSpan(
                  text: AppString.appNameSuffix,
                  style: TextStyle(color: AppColor.primaryColor),
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
              Positioned(
                top: Dimensions.r10.dynamicH,
                right: Dimensions.r10.dynamicW,
                child: Container(
                  width: Dimensions.r8.dynamicW,
                  height: Dimensions.r8.dynamicH,
                  decoration: const BoxDecoration(
                    color: AppColor.errorColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
