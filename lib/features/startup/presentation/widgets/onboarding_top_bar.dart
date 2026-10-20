import '../../../../core/base_import.dart';

/// Top bar for the KhelBhai onboarding screen with Back, KhelBhai logo, and Skip button.
class OnboardingTopBar extends StatelessWidget implements PreferredSizeWidget {
  final bool canGoBack;
  final bool showSkip;
  final VoidCallback onBack;
  final VoidCallback onSkip;

  const OnboardingTopBar({
    super.key,
    required this.canGoBack,
    required this.showSkip,
    required this.onBack,
    required this.onSkip,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: context.backgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: AppTheme.systemUiOverlayStyle(context),
      leading: canGoBack ? KhelBhaiBackButton(onPressed: onBack) : null,
      centerTitle: true,
      title: RichText(
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
      actions: [
        if (showSkip)
          TextButton(
            onPressed: onSkip,
            child: Text(
              context.loc.onboardingSkip,
              style: TextStyle(
                color: context.textSecondary,
                fontSize: Dimensions.r14.dynamicSP,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        else
          SizedBox(width: Dimensions.r48.dynamicW),
        SizedBox(width: Dimensions.r8.dynamicW),
      ],
    );
  }
}
