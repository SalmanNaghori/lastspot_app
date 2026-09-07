import 'package:lastspot_app/core/base_import.dart';
import '../../../categories/domain/entities/category.dart';

class ExploreFilterBar extends StatelessWidget {
  final List<CategoryEntity> categories;
  final String? selectedCategoryId;
  final ValueChanged<String?> onCategorySelected;

  const ExploreFilterBar({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.r16.dynamicW),
      child: Row(
        children: [
          _buildChip(
            context,
            label: 'All',
            isSelected: selectedCategoryId == null,
            onTap: () => onCategorySelected(null),
          ),
          ...categories.map(
            (category) => Padding(
              padding: EdgeInsets.only(left: Dimensions.r8.dynamicW),
              child: _buildChip(
                context,
                label: category.name,
                isSelected: selectedCategoryId == category.id,
                onTap: () => onCategorySelected(category.id),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.r16.dynamicW,
          vertical: Dimensions.r8.dynamicH,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primaryColor : context.surfaceColor,
          borderRadius: BorderRadius.circular(Dimensions.r20.dynamicR),
          border: Border.all(
            color: isSelected ? AppColor.primaryColor : context.borderColor,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColor.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
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
