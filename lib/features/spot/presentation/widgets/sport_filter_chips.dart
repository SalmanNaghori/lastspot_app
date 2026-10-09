import 'package:lastspot_app/core/base_import.dart';
import '../../../categories/domain/entities/category.dart';

class SportFilterChips extends StatelessWidget {
  final List<CategoryEntity> categories;
  final String? selectedCategoryId;
  final ValueChanged<String?> onCategorySelected;

  const SportFilterChips({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  IconData _getIconForCategory(String iconString) {
    switch (iconString.toLowerCase()) {
      case 'cricket':
        return Icons.sports_cricket;
      case 'football':
        return Icons.sports_soccer;
      case 'badminton':
        return Icons.sports_tennis;
      case 'tennis':
        return Icons.sports_tennis;
      case 'basketball':
        return Icons.sports_basketball;
      case 'running':
        return Icons.directions_run;
      case 'travel':
        return Icons.flight_takeoff;
      case 'cycling':
        return Icons.directions_bike;
      case 'events':
        return Icons.event;
      case 'hiking':
        return Icons.landscape;
      default:
        return Icons.sports;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return SizedBox(
        height: Dimensions.r24.dynamicH * 1.67,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: Dimensions.r16.dynamicW),
          itemCount: 5,
          separatorBuilder: (_, _) => SizedBox(width: Dimensions.r8.dynamicW),
          itemBuilder: (context, index) {
            return Container(
              width: Dimensions.r48.dynamicW * 2,
              height: double.infinity,
              decoration: BoxDecoration(
                color: context.surfaceColor,
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(color: context.borderColor, width: 1.5),
              ),
            );
          },
        ),
      );
    }

    return SizedBox(
      height: Dimensions.r24.dynamicH * 1.67,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: Dimensions.r16.dynamicW),
        itemCount: categories.length,
        separatorBuilder: (_, _) => SizedBox(width: Dimensions.r8.dynamicW),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategoryId == category.id;
          return _SportChip(
            category: category,
            iconData: _getIconForCategory(category.icon),
            isSelected: isSelected,
            onTap: () => onCategorySelected(isSelected ? null : category.id),
          );
        },
      ),
    );
  }
}

class _SportChip extends StatelessWidget {
  final CategoryEntity category;
  final IconData iconData;
  final bool isSelected;
  final VoidCallback onTap;

  const _SportChip({
    required this.category,
    required this.iconData,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.r14.dynamicW,
          vertical: Dimensions.r8.dynamicH,
        ),
        decoration: BoxDecoration(
          color: isSelected ? context.primaryColor : context.surfaceColor,
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(
            color: isSelected ? context.primaryColor : context.borderColor,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: context.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconData,
              size: Dimensions.r16.dynamicH,
              color: isSelected ? AppColor.whiteColor : context.textSecondary,
            ),
            SizedBox(width: Dimensions.r6.dynamicW),
            Text(
              category.name,
              style: TextStyle(
                fontSize: Dimensions.r13.dynamicSP,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColor.whiteColor : context.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
