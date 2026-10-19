import '../../../../core/base_import.dart';
import '../widgets/onboarding_action_buttons.dart';
import '../widgets/onboarding_page_indicator.dart';
import '../widgets/onboarding_slide_data.dart';
import '../widgets/onboarding_slide_item.dart';
import '../widgets/onboarding_top_bar.dart';

/// Tablet layout for the KhelBhai onboarding screen.
class OnboardingScreenTablet extends StatelessWidget {
  final PageController pageController;
  final List<OnboardingSlideData> slides;
  final int currentPage;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onSkip;
  final VoidCallback onBack;
  final VoidCallback onAdvance;
  final VoidCallback onSignIn;

  const OnboardingScreenTablet({
    super.key,
    required this.pageController,
    required this.slides,
    required this.currentPage,
    required this.onPageChanged,
    required this.onSkip,
    required this.onBack,
    required this.onAdvance,
    required this.onSignIn,
  });

  @override
  Widget build(BuildContext context) {
    final isLastPage = currentPage == slides.length - 1;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: OnboardingTopBar(
        canGoBack: currentPage > 0,
        showSkip: !isLastPage,
        onBack: onBack,
        onSkip: onSkip,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: slides.length,
                    onPageChanged: onPageChanged,
                    itemBuilder: (context, index) {
                      return OnboardingSlideItem(slide: slides[index]);
                    },
                  ),
                ),
                OnboardingPageIndicator(
                  count: slides.length,
                  currentIndex: currentPage,
                ),
                SizedBox(height: Dimensions.r16.dynamicH),
                OnboardingActionButtons(
                  isFirstPage: currentPage == 0,
                  isLastPage: isLastPage,
                  onPrimaryPressed: onAdvance,
                  onSignInPressed: onSignIn,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
