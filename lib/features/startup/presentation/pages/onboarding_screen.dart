import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/gen/assets.gen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static final _slides = [
    (
      title: 'Find people. Fill the last spot.',
      description:
          'Discover local sports matches and active players right around you.',
      imageGen: Assets.images.onboarding.welcomeSportsCollection,
      fallbackIcon: Icons.sports_soccer_rounded,
    ),
    (
      title: 'Meet your team',
      description:
          'Connect with reliable people who love playing your favorite sports.',
      imageGen: Assets.images.categories.football,
      fallbackIcon: Icons.groups_2_rounded,
    ),
    (
      title: 'Play together',
      description:
          'Join a spot or host your own in seconds. Never let an empty slot cancel a match.',
      imageGen: Assets.images.categories.cricket,
      fallbackIcon: Icons.sports_cricket_rounded,
    ),
  ];

  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isFinishing = false;

  Future<void> _finishOnboarding({bool toSignup = false}) async {
    if (_isFinishing) return;
    _isFinishing = true;
    try {
      await sl<SharedPrefsUtil>().setBool(
        SharedPrefsKeys.onboardingCompleted,
        true,
      );
    } catch (_) {
      // Continue even if preference persistence fails.
    } finally {
      if (mounted) {
        context.go(toSignup ? AppRoutes.signup : AppRoutes.login);
      }
    }
  }

  void _onSignInPressed() {
    _finishOnboarding(toSignup: false);
  }

  void _advance() {
    if (_currentPage == _slides.length - 1) {
      _finishOnboarding(toSignup: true);
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: AppTheme.systemUiOverlayStyle(context),
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
          TextButton(
            onPressed: () => _finishOnboarding(toSignup: false),
            child: Text(
              'Skip',
              style: TextStyle(
                color: context.textSecondary,
                fontSize: Dimensions.r14.dynamicSP,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: Dimensions.r16.dynamicW),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (page) => setState(() => _currentPage = page),
                itemBuilder: (context, index) {
                  final slide = _slides[index];

                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.r24.dynamicW,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: Dimensions.r96.dynamicW * 2.2,
                          height: Dimensions.r96.dynamicH * 2.2,
                          decoration: BoxDecoration(
                            color: context.isDarkMode
                                ? context.surfaceContainer
                                : AppColor.surfaceContainerLight,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: context.borderColor.withValues(alpha: 0.6),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: context.primaryColor.withValues(
                                  alpha: 0.08,
                                ),
                                blurRadius: Dimensions.r24.dynamicR,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(Dimensions.r24.dynamicH),
                              child: slide.imageGen.image(
                                fit: BoxFit.contain,
                                cacheWidth: 512,
                                cacheHeight: 512,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    slide.fallbackIcon,
                                    size: Dimensions.r64.dynamicH * 1.5,
                                    color: context.primaryColor,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: Dimensions.r32.dynamicH),
                        Text(
                          slide.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: Dimensions.r28.dynamicSP,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.6,
                            color: context.textPrimary,
                          ),
                        ),
                        SizedBox(height: Dimensions.r12.dynamicH),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.r16.dynamicW,
                          ),
                          child: Text(
                            slide.description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: Dimensions.r15.dynamicSP,
                              color: context.textSecondary,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.r24.dynamicW,
                vertical: Dimensions.r16.dynamicH,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_slides.length, (dotIndex) {
                      final selected = dotIndex == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutCubic,
                        margin: EdgeInsets.symmetric(
                          horizontal: Dimensions.r4.dynamicW,
                        ),
                        height: Dimensions.r6.dynamicH,
                        width: selected
                            ? Dimensions.r24.dynamicW
                            : Dimensions.r8.dynamicW,
                        decoration: BoxDecoration(
                          color: selected
                              ? context.primaryColor
                              : context.borderColor,
                          borderRadius: BorderRadius.circular(
                            Dimensions.r999.dynamicR,
                          ),
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: Dimensions.r20.dynamicH),
                  SizedBox(
                    width: double.infinity,
                    height: Dimensions.r48.dynamicH * 1.15,
                    child: FilledButton(
                      onPressed: _advance,
                      style: FilledButton.styleFrom(
                        backgroundColor: context.primaryColor,
                        foregroundColor: AppColor.whiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            Dimensions.r16.dynamicR,
                          ),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _currentPage == _slides.length - 1
                            ? 'Get Started'
                            : 'Continue',
                        style: TextStyle(
                          fontSize: Dimensions.r16.dynamicSP,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.r8.dynamicH),
                  TextButton(
                    onPressed: _onSignInPressed,
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: Dimensions.r14.dynamicSP),
                        children: [
                          TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(color: context.textSecondary),
                          ),
                          TextSpan(
                            text: 'Sign In',
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
            ),
          ],
        ),
      ),
    );
  }
}
