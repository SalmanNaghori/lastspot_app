import '../../../../core/base_import.dart';

/// Animated page indicator dots for the onboarding carousel.
class OnboardingPageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const OnboardingPageIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (dotIndex) {
        final selected = dotIndex == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          margin: EdgeInsets.symmetric(horizontal: Dimensions.r4.dynamicW),
          height: Dimensions.r6.dynamicH,
          width: selected ? Dimensions.r24.dynamicW : Dimensions.r8.dynamicW,
          decoration: BoxDecoration(
            color: selected ? context.primaryColor : context.borderColor,
            borderRadius: BorderRadius.circular(Dimensions.r999.dynamicR),
          ),
        );
      }),
    );
  }
}
