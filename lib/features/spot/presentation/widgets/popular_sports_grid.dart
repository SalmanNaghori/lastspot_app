import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/core/widgets/sports_category_perspective_carousel.dart';
import '../../../categories/domain/entities/category.dart';

/// 3D perspective-stack sports category section for Home screen.
class PopularSportsGrid extends StatefulWidget {
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
  State<PopularSportsGrid> createState() => _PopularSportsGridState();
}

class _PopularSportsGridState extends State<PopularSportsGrid> {
  final ValueNotifier<bool> _showHint = ValueNotifier<bool>(true);

  @override
  void dispose() {
    _showHint.dispose();
    super.dispose();
  }

  void _onCarouselInteraction() {
    if (_showHint.value) {
      _showHint.value = false;
    }
  }

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
              if (widget.onViewAll != null)
                GestureDetector(
                  onTap: widget.onViewAll,
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
        SizedBox(height: Dimensions.r10.dynamicH),
        Builder(
          builder: (context) {
            final displayCategories = widget.categories.length > 12
                ? widget.categories.sublist(0, 12)
                : widget.categories;

            if (displayCategories.isEmpty) {
              return SizedBox(
                height: Dimensions.r140.dynamicH + Dimensions.r20.dynamicH,
                child: Center(
                  child: Container(
                    width: Dimensions.r120.dynamicW,
                    height: Dimensions.r140.dynamicH,
                    decoration: BoxDecoration(
                      color: context.isDarkMode
                          ? context.surfaceContainer
                          : AppColor.surfaceContainerLight,
                      borderRadius: BorderRadius.circular(
                        Dimensions.r20.dynamicR,
                      ),
                      border: Border.all(
                        color: context.borderColor.withValues(alpha: 0.6),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              );
            }

            return SportsCategoryPerspectiveCarousel(
              key: const ValueKey('home_sports_perspective_carousel'),
              categories: displayCategories,
              mode: SportsCarouselMode.home,
              onCategoryTap: widget.onCategoryTap,
              onInteraction: _onCarouselInteraction,
            );
          },
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _showHint,
          builder: (context, showHint, _) {
            return AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: showHint
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Padding(
                padding: EdgeInsets.only(top: Dimensions.r8.dynamicH),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.swipe_outlined,
                      size: Dimensions.r14.dynamicH,
                      color: context.textSecondary.withValues(alpha: 0.8),
                    ),
                    SizedBox(width: Dimensions.r6.dynamicW),
                    Text(
                      loc.sportsCarouselHint,
                      style: TextStyle(
                        fontSize: Dimensions.r11.dynamicSP,
                        fontWeight: FontWeight.w500,
                        color: context.textSecondary,
                        letterSpacing: -0.1,
                      ),
                    ),
                  ],
                ),
              ),
              secondChild: const SizedBox.shrink(),
            );
          },
        ),
      ],
    );
  }
}
