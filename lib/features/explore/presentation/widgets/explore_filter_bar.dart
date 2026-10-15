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
          ExploreFilterChip(
            label: context.loc.allFilter,
            isSelected: selectedCategoryId == null,
            onTap: () => onCategorySelected(null),
          ),
          ...categories.map(
            (category) => Padding(
              padding: EdgeInsets.only(left: Dimensions.r8.dynamicW),
              child: ExploreFilterChip(
                label: category.name,
                categorySlug: category.slug,
                isSelected: selectedCategoryId == category.id,
                onTap: () => onCategorySelected(category.id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExploreFilterChip extends StatelessWidget {
  final String label;
  final String? categorySlug;
  final bool isSelected;
  final VoidCallback onTap;

  const ExploreFilterChip({
    super.key,
    required this.label,
    this.categorySlug,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final slug = categorySlug;
    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.r14.dynamicW,
            vertical: Dimensions.r8.dynamicH,
          ),
          decoration: BoxDecoration(
            color: isSelected ? context.primaryColor : context.surfaceColor,
            borderRadius: BorderRadius.circular(Dimensions.r20.dynamicR),
            border: Border.all(
              color: isSelected
                  ? context.primaryColor
                  : context.borderColor.withValues(alpha: 0.8),
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: context.primaryColor.withValues(alpha: 0.25),
                      blurRadius: Dimensions.r6.dynamicR,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (slug != null) ...[
                Image.asset(
                  AppAssets.getCategoryAsset(slug),
                  width: Dimensions.r18.dynamicW,
                  height: Dimensions.r18.dynamicH,
                  cacheWidth: 64,
                  cacheHeight: 64,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      AppAssets.getCategoryFallbackIcon(slug),
                      size: Dimensions.r16.dynamicH,
                      color: isSelected
                          ? AppColor.whiteColor
                          : context.primaryColor,
                    );
                  },
                ),
                SizedBox(width: Dimensions.r6.dynamicW),
              ],
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColor.whiteColor : context.textPrimary,
                  fontSize: Dimensions.r13.dynamicSP,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
