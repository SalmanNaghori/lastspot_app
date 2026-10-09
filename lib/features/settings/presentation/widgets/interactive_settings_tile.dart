import 'package:lastspot_app/core/base_import.dart';

class InteractiveSettingsTile<T> extends StatelessWidget {
  final String title;
  final IconData icon;
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;

  const InteractiveSettingsTile({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;

    return InkWell(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.r16,
          vertical: Dimensions.r16,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? context.primaryColor.withValues(alpha: 0.08)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? context.primaryColor : context.textSecondary,
              size: Dimensions.r20.dynamicH,
            ),
            SizedBox(width: Dimensions.r12.dynamicW),
            Expanded(
              child: Text(
                title,
                style: context.bodyLarge?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? context.primaryColor
                      : context.textPrimary,
                ),
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: isSelected ? 1.0 : 0.0,
              child: AnimatedScale(
                scale: isSelected ? 1.0 : 0.5,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutBack,
                child: Icon(
                  Icons.check_circle,
                  color: context.primaryColor,
                  size: Dimensions.r20.dynamicH,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
