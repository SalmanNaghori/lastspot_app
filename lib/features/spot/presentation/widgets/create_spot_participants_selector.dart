import 'package:lastspot_app/core/base_import.dart';

class CreateSpotParticipantsSelector extends StatelessWidget {
  final ValueNotifier<int> maxParticipantsNotifier;

  const CreateSpotParticipantsSelector({
    super.key,
    required this.maxParticipantsNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: maxParticipantsNotifier,
      builder: (context, maxParticipants, _) {
        final bool isMinusDisabled = maxParticipants <= 1;
        final bool isPlusDisabled = maxParticipants >= 50;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
            border: Border.all(color: context.borderColor, width: 1.0),
            boxShadow: [
              BoxShadow(
                color: context.colorScheme.shadow.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: EdgeInsets.all(Dimensions.r16.dynamicH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                context.loc.howManyPeopleCanJoin,
                style: context.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.textPrimary,
                ),
              ),
              SizedBox(height: Dimensions.r24.dynamicH),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _StepperButton(
                    icon: Icons.remove,
                    onTap: isMinusDisabled
                        ? null
                        : () => maxParticipantsNotifier.value =
                              maxParticipants - 1,
                    isDisabled: isMinusDisabled,
                  ),
                  SizedBox(width: Dimensions.r32.dynamicW),
                  SizedBox(
                    width: Dimensions.r48.dynamicW,
                    child: Text(
                      '$maxParticipants',
                      textAlign: TextAlign.center,
                      style: context.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: Dimensions.r32.dynamicW),
                  _StepperButton(
                    icon: Icons.add,
                    onTap: isPlusDisabled
                        ? null
                        : () => maxParticipantsNotifier.value =
                              maxParticipants + 1,
                    isDisabled: isPlusDisabled,
                  ),
                ],
              ),
              SizedBox(height: Dimensions.r24.dynamicH),
              Text(
                context.loc.youAreIncluded,
                style: context.bodyMedium?.copyWith(
                  color: context.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool isDisabled;

  const _StepperButton({
    required this.icon,
    required this.onTap,
    required this.isDisabled,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDisabled
          ? context.colorScheme.surfaceContainerHighest
          : context.primaryColor.withValues(alpha: 0.1),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: EdgeInsets.all(Dimensions.r12.dynamicR),
          child: Icon(
            icon,
            color: isDisabled
                ? context.textSecondary.withValues(alpha: 0.5)
                : context.primaryColor,
            size: Dimensions.r24.dynamicH,
          ),
        ),
      ),
    );
  }
}
