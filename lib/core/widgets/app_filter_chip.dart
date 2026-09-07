import 'package:lastspot_app/core/base_import.dart';

class AppFilterChip<T> extends StatelessWidget {
  final String label;
  final T value;
  final T groupValue;
  final ValueChanged<T> onSelected;

  const AppFilterChip({
    super.key,
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onSelected(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.r16.dynamicW,
          vertical: Dimensions.r10.dynamicH,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primaryColor : context.surfaceColor,
          borderRadius: BorderRadius.circular(Dimensions.r20.dynamicR),
          border: Border.all(
            color: isSelected ? AppColor.primaryColor : context.borderColor,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColor.whiteColor : context.textPrimary,
            fontSize: Dimensions.r13.dynamicSP,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
