import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/core/di/service_locator.dart';
import 'package:lastspot_app/core/utils/shared_prefs_util.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _slides = [
    (
      title: 'Find your game',
      description: 'Discover sports and activities happening around you.',
      icon: Icons.sports_soccer_rounded,
      color: Color(0xFF5B46E8),
    ),
    (
      title: 'Meet your team',
      description: 'Connect with people who love playing as much as you do.',
      icon: Icons.groups_2_rounded,
      color: Color(0xFF3C28A4),
    ),
    (
      title: 'Play together',
      description: 'Join a game or host your own in just a few taps.',
      icon: Icons.sports_tennis_rounded,
      color: Color(0xFF752A21),
    ),
  ];

  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isFinishing = false;

  Future<void> _finishOnboarding() async {
    if (_isFinishing) return;
    _isFinishing = true;
    try {
      await sl<SharedPrefsUtil>().setBool(
        SharedPrefsKeys.onboardingCompleted,
        true,
      );
    } catch (_) {
      // Continue to authentication even if onboarding state could not persist.
    } finally {
      if (mounted) context.go(AppRoutes.login);
    }
  }

  void _advance() {
    if (_currentPage == _slides.length - 1) {
      _finishOnboarding();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
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
      body: PageView.builder(
        controller: _pageController,
        itemCount: _slides.length,
        onPageChanged: (page) => setState(() => _currentPage = page),
        itemBuilder: (context, index) {
          final slide = _slides[index];
          final onBackground = Colors.white;

          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
              systemNavigationBarColor: Colors.transparent,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    slide.color,
                    Color.lerp(slide.color, Colors.black, 0.14)!,
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimensions.w(28)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: Dimensions.h(52),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _finishOnboarding,
                            style: TextButton.styleFrom(
                              foregroundColor: onBackground.withValues(
                                alpha: 0.88,
                              ),
                            ),
                            child: const Text('Skip'),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Center(
                          child: Container(
                            width: Dimensions.w(248),
                            height: Dimensions.w(248),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: onBackground.withValues(alpha: 0.12),
                              border: Border.all(
                                color: onBackground.withValues(alpha: 0.22),
                                width: 1.5,
                              ),
                            ),
                            child: Icon(
                              slide.icon,
                              size: Dimensions.w(112),
                              color: onBackground,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              slide.title,
                              textAlign: TextAlign.center,
                              style: context.headlineSmall?.copyWith(
                                color: onBackground,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.4,
                              ),
                            ),
                            SizedBox(height: Dimensions.h(12)),
                            Text(
                              slide.description,
                              textAlign: TextAlign.center,
                              style: context.bodyLarge?.copyWith(
                                color: onBackground.withValues(alpha: 0.84),
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(_slides.length, (dotIndex) {
                          final selected = dotIndex == _currentPage;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 260),
                            curve: Curves.easeInOut,
                            margin: EdgeInsets.symmetric(
                              horizontal: Dimensions.w(4),
                            ),
                            height: Dimensions.h(8),
                            width: Dimensions.w(selected ? 24 : 8),
                            decoration: BoxDecoration(
                              color: selected
                                  ? onBackground
                                  : onBackground.withValues(alpha: 0.38),
                              borderRadius: BorderRadius.circular(
                                Dimensions.r999,
                              ),
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: Dimensions.h(24)),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _advance,
                          style: FilledButton.styleFrom(
                            backgroundColor: onBackground,
                            foregroundColor: slide.color,
                            minimumSize: Size.fromHeight(Dimensions.h(56)),
                          ),
                          child: Text(
                            _currentPage == _slides.length - 1
                                ? 'Get Started'
                                : 'Continue',
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.h(16)),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
