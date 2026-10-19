import '../../../../core/base_import.dart';

/// Bottom action buttons for the KhelBhai onboarding screen.
class OnboardingActionButtons extends StatelessWidget {
  final bool isFirstPage;
  final bool isLastPage;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onSignInPressed;

  const OnboardingActionButtons({
    super.key,
    required this.isFirstPage,
    required this.isLastPage,
    required this.onPrimaryPressed,
    required this.onSignInPressed,
  });

  String _getButtonText(BuildContext context) {
    if (isFirstPage) {
      return context.loc.onboardingGetStarted;
    }
    if (isLastPage) {
      return context.loc.onboardingLetsPlay;
    }
    return context.loc.onboardingContinue;
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.r24.dynamicW,
        vertical: Dimensions.r16.dynamicH,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Primary CTA Button
          SizedBox(
            width: double.infinity,
            height: Dimensions.r48.dynamicH * 1.15,
            child: FilledButton(
              onPressed: onPrimaryPressed,
              style: FilledButton.styleFrom(
                backgroundColor: context.primaryColor,
                foregroundColor: AppColor.whiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
                ),
                elevation: 2,
                shadowColor: context.primaryColor.withValues(alpha: 0.35),
              ),
              child: Text(
                _getButtonText(context),
                style: TextStyle(
                  fontSize: Dimensions.r16.dynamicSP,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
          SizedBox(height: Dimensions.r8.dynamicH),

          // Secondary Action (Sign in)
          TextButton(
            onPressed: onSignInPressed,
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: Dimensions.r14.dynamicSP),
                children: [
                  TextSpan(
                    text: loc.onboardingAlreadyHaveAccount,
                    style: TextStyle(color: context.textSecondary),
                  ),
                  TextSpan(
                    text: loc.onboardingSignIn,
                    style: TextStyle(
                      color: context.primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
