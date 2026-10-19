import '../../../../core/base_import.dart';
import '../widgets/onboarding_slide_data.dart';
import 'onboarding_screen_mobile.dart';
import 'onboarding_screen_tablet.dart';

/// Screen coordinating the premium 4-slide KhelBhai onboarding experience.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isFinishing = false;

  List<OnboardingSlideData> _slides(BuildContext context) {
    final loc = context.loc;
    return [
      OnboardingSlideData(
        title: loc.onboardingSlide1Title,
        tagline: loc.onboardingSlide1Tagline,
        description: loc.onboardingSlide1Desc,
        image: Assets.images.onboarding.onboardingWelcome,
        fallbackIcon: Icons.sports_soccer_rounded,
      ),
      OnboardingSlideData(
        title: loc.onboardingSlide2Title,
        description: loc.onboardingSlide2Desc,
        image: Assets.images.onboarding.onboardingFindPlayers,
        fallbackIcon: Icons.groups_2_rounded,
      ),
      OnboardingSlideData(
        title: loc.onboardingSlide3Title,
        description: loc.onboardingSlide3Desc,
        image: Assets.images.onboarding.onboardingCreateJoin,
        fallbackIcon: Icons.stadium_rounded,
      ),
      OnboardingSlideData(
        title: loc.onboardingSlide4Title,
        description: loc.onboardingSlide4Desc,
        image: Assets.images.onboarding.onboardingTeamChat,
        fallbackIcon: Icons.forum_rounded,
        readyHeading: loc.onboardingReadyHeading,
      ),
    ];
  }

  Future<void> _finishOnboarding({bool toSignup = false}) async {
    if (_isFinishing) return;
    _isFinishing = true;
    try {
      await sl<SharedPrefsUtil>().setBool(
        SharedPrefsKeys.onboardingCompleted,
        true,
      );
    } catch (_) {
      // Continue navigation even if preference persistence throws.
    } finally {
      if (mounted) {
        context.go(toSignup ? AppRoutes.signup : AppRoutes.login);
      }
    }
  }

  void _onSkipPressed() {
    _finishOnboarding(toSignup: false);
  }

  void _onBackPressed() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _onAdvancePressed() {
    final slides = _slides(context);
    if (_currentPage == slides.length - 1) {
      _finishOnboarding(toSignup: true);
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  void _onSignInPressed() {
    _finishOnboarding(toSignup: false);
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final slides = _slides(context);

    return ResponsiveLayout(
      mobile: OnboardingScreenMobile(
        pageController: _pageController,
        slides: slides,
        currentPage: _currentPage,
        onPageChanged: _onPageChanged,
        onSkip: _onSkipPressed,
        onBack: _onBackPressed,
        onAdvance: _onAdvancePressed,
        onSignIn: _onSignInPressed,
      ),
      tablet: OnboardingScreenTablet(
        pageController: _pageController,
        slides: slides,
        currentPage: _currentPage,
        onPageChanged: _onPageChanged,
        onSkip: _onSkipPressed,
        onBack: _onBackPressed,
        onAdvance: _onAdvancePressed,
        onSignIn: _onSignInPressed,
      ),
    );
  }
}
