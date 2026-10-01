import 'package:lastspot_app/core/base_import.dart';

class CreateSpotSelectionField extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const CreateSpotSelectionField({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Dimensions.r16.dynamicW),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
          border: Border.all(color: context.borderColor),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? context.textPrimary : context.textSecondary,
            ),
            SizedBox(width: Dimensions.r12.dynamicW),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: Dimensions.r16.dynamicSP,
                  color: isSelected
                      ? context.textPrimary
                      : context.textSecondary,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: context.textSecondary),
          ],
        ),
      ),
    );
  }
}
