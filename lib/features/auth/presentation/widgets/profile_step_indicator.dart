import 'package:lastspot_app/core/base_import.dart';

/// Progress step indicator for guided profile onboarding.
class ProfileStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ProfileStepIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 4,
  });

  static const _stepLabels = ['Details', 'City', 'Sports', 'Ready'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(totalSteps, (index) {
            final isCompleted = index < currentStep;
            final isCurrent = index == currentStep;

            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: Dimensions.r4.dynamicH,
                      margin: EdgeInsets.symmetric(
                        horizontal: Dimensions.r2.dynamicW,
                      ),
                      decoration: BoxDecoration(
                        color: isCompleted || isCurrent
                            ? context.primaryColor
                            : context.borderColor.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(
                          Dimensions.r999.dynamicR,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
        SizedBox(height: Dimensions.r8.dynamicH),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(totalSteps, (index) {
            final isCurrent = index == currentStep;
            final isCompleted = index < currentStep;

            return Text(
              _stepLabels[index],
              style: TextStyle(
                fontSize: Dimensions.r11.dynamicSP,
                fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                color: isCurrent
                    ? context.primaryColor
                    : (isCompleted
                          ? context.textPrimary
                          : context.textSecondary),
              ),
            );
          }),
        ),
      ],
    );
  }
}
