import 'package:lastspot_app/core/base_import.dart';
import '../../../categories/domain/entities/category.dart';

/// Horizontal 3D sports category carousel matching the Fareeq design.
class PopularSportsGrid extends StatelessWidget {
  final List<CategoryEntity> categories;
  final ValueChanged<CategoryEntity> onCategoryTap;
  final VoidCallback? onViewAll;

  const PopularSportsGrid({
    super.key,
    required this.categories,
    required this.onCategoryTap,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.r16.dynamicW),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                loc.popularSports,
                style: TextStyle(
                  fontSize: Dimensions.r18.dynamicSP,
                  fontWeight: FontWeight.w800,
                  color: context.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              if (onViewAll != null)
                GestureDetector(
                  onTap: onViewAll,
                  child: Text(
                    loc.viewAll,
                    style: TextStyle(
                      fontSize: Dimensions.r13.dynamicSP,
                      fontWeight: FontWeight.w700,
                      color: context.primaryColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: Dimensions.r12.dynamicH),
        Builder(
          builder: (context) {
            final displayCategories = categories.length > 10
                ? categories.sublist(0, 10)
                : categories;

            return SizedBox(
              height: Dimensions.r96.dynamicH * 1.15,
              child: displayCategories.isEmpty
                  ? ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.r16.dynamicW,
                      ),
                      itemCount: 4,
                      separatorBuilder: (_, _) =>
                          SizedBox(width: Dimensions.r12.dynamicW),
                      itemBuilder: (context, index) {
                        return Container(
                          width: Dimensions.r80.dynamicW * 1.1,
                          height: Dimensions.r96.dynamicH * 1.05,
                          decoration: BoxDecoration(
                            color: context.isDarkMode
                                ? context.surfaceContainer
                                : AppColor.surfaceContainerLight,
                            borderRadius: BorderRadius.circular(
                              Dimensions.r18.dynamicR,
                            ),
                            border: Border.all(
                              color: context.borderColor.withValues(alpha: 0.6),
                              width: 1,
                            ),
                          ),
                        );
                      },
                    )
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.r16.dynamicW,
                      ),
                      itemCount: displayCategories.length,
                      separatorBuilder: (_, _) =>
                          SizedBox(width: Dimensions.r12.dynamicW),
                      itemBuilder: (context, index) {
                        final category = displayCategories[index];
                        return SportCategoryTile(
                          key: ValueKey('sport_tile_${category.id}'),
                          category: category,
                          onTap: () => onCategoryTap(category),
                        );
                      },
                    ),
            );
          },
        ),
      ],
    );
  }
}
