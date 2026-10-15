import '../base_import.dart';
import '../../features/categories/domain/entities/category.dart';

/// Reusable rounded sports category tile featuring the 3D equipment illustration.
///
/// Designed per the Fareeq-inspired design system:
/// - Rounded soft neutral container (radius 18)
/// - High-performance cached asset decoding near displayed size (cacheWidth/Height 160)
/// - Graceful fallback to category icon on failure
/// - Clear dark typography and optional active state
class SportCategoryTile extends StatelessWidget {
  final CategoryEntity category;
  final bool isSelected;
  final VoidCallback onTap;
  final double? width;
  final double? height;

  const SportCategoryTile({
    super.key,
    required this.category,
    required this.onTap,
    this.isSelected = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final tileWidth = width ?? Dimensions.r80.dynamicW * 1.1;
    final tileHeight = height ?? Dimensions.r96.dynamicH * 1.05;
    final softTint = AppAssets.getCategorySoftTint(category.slug);

    return Semantics(
      button: true,
      label: category.name,
      selected: isSelected,
      child: Tooltip(
        message: category.name,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Dimensions.r18.dynamicR),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            width: tileWidth,
            height: tileHeight,
            padding: EdgeInsets.all(Dimensions.r8.dynamicW),
            decoration: BoxDecoration(
              color: isSelected
                  ? (context.isDarkMode
                        ? context.primaryColor.withValues(alpha: 0.2)
                        : const Color(0xFFF0FDF4))
                  : (context.isDarkMode ? context.surfaceContainer : softTint),
              borderRadius: BorderRadius.circular(Dimensions.r18.dynamicR),
              border: Border.all(
                color: isSelected
                    ? context.primaryColor
                    : context.borderColor.withValues(alpha: 0.6),
                width: isSelected ? 2.0 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? context.primaryColor.withValues(alpha: 0.18)
                      : AppColor.blackColor.withValues(alpha: 0.03),
                  blurRadius: isSelected
                      ? Dimensions.r8.dynamicR
                      : Dimensions.r6.dynamicR,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: AppAssets.getCategoryGen(category.slug).image(
                            width: Dimensions.r48.dynamicW,
                            height: Dimensions.r48.dynamicH,
                            cacheWidth: 160,
                            cacheHeight: 160,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                AppAssets.getCategoryFallbackIcon(
                                  category.slug,
                                ),
                                size: Dimensions.r32.dynamicH,
                                color: context.primaryColor,
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.r4.dynamicH),
                      Text(
                        category.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: Dimensions.r12.dynamicSP,
                          fontWeight: isSelected
                              ? FontWeight.w800
                              : FontWeight.w700,
                          color: isSelected
                              ? context.primaryColor
                              : context.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(Dimensions.r2.dynamicW),
                      decoration: BoxDecoration(
                        color: context.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        size: Dimensions.r12.dynamicH,
                        color: AppColor.whiteColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
