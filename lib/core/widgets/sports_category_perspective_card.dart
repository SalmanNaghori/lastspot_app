import 'package:lastspot_app/core/base_import.dart';

/// Premium 3D perspective category card.
///
/// Features:
/// - Rounded soft neutral container with pastel tint from [AppAssets]
/// - Authentic 3D sports equipment illustration with fallback
/// - Distinct visual hierarchy between large center card and receding side cards
/// - Verified hit-testing bounds and Material ink/gesture feedback
class SportsCategoryPerspectiveCard extends StatelessWidget {
  final String name;
  final String? slug;
  final bool isAll;
  final bool isCenter;
  final bool isSelected;
  final double width;
  final double height;
  final double opticalDepth;
  final VoidCallback onTap;

  const SportsCategoryPerspectiveCard({
    super.key,
    required this.name,
    this.slug,
    this.isAll = false,
    this.isCenter = false,
    this.isSelected = false,
    required this.width,
    required this.height,
    this.opticalDepth = 0.0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = isAll ? context.loc.allFilter : name;

    final Color baseBgColor;
    if (isAll) {
      baseBgColor = context.isDarkMode
          ? context.surfaceContainer
          : const Color(0xFFF1F5F9);
    } else {
      final softTint = AppAssets.getCategorySoftTint(slug);
      baseBgColor = context.isDarkMode ? context.surfaceContainer : softTint;
    }

    final cardRadius = Dimensions.r20.dynamicR;
    final cardBorder = Border.all(
      color: isCenter
          ? context.primaryColor.withValues(alpha: 0.45)
          : context.borderColor.withValues(alpha: 0.5),
      width: isCenter ? 1.5 : 1.0,
    );

    final cardShadows = isCenter
        ? [
            BoxShadow(
              color: context.primaryColor.withValues(alpha: 0.10),
              blurRadius: Dimensions.r16.dynamicR,
              offset: Offset(0, Dimensions.r6.dynamicH),
            ),
            BoxShadow(
              color: AppColor.blackColor.withValues(alpha: 0.06),
              blurRadius: Dimensions.r8.dynamicR,
              offset: Offset(0, Dimensions.r2.dynamicH),
            ),
          ]
        : [
            BoxShadow(
              color: AppColor.blackColor.withValues(alpha: 0.04),
              blurRadius: Dimensions.r6.dynamicR,
              offset: Offset(0, Dimensions.r2.dynamicH),
            ),
          ];

    return Semantics(
      button: true,
      label: displayName,
      selected: isSelected,
      child: Tooltip(
        message: displayName,
        child: SizedBox(
          width: width,
          height: height,
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(cardRadius),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(cardRadius),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                width: width,
                height: height,
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.r8.dynamicW,
                  vertical: Dimensions.r10.dynamicH,
                ),
                decoration: BoxDecoration(
                  color: baseBgColor,
                  borderRadius: BorderRadius.circular(cardRadius),
                  border: cardBorder,
                  boxShadow: cardShadows,
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Center(child: _buildArtwork(context)),
                          ),
                          SizedBox(height: Dimensions.r6.dynamicH),
                          if (isCenter)
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                displayName,
                                maxLines: 1,
                                softWrap: false,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: Dimensions.r13.dynamicSP,
                                  fontWeight: FontWeight.w800,
                                  color: context.isDarkMode
                                      ? AppColor.whiteColor
                                      : context.textPrimary,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            )
                          else
                            Text(
                              displayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: Dimensions.r12.dynamicSP,
                                fontWeight: FontWeight.w700,
                                color: context.textSecondary,
                                letterSpacing: -0.2,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (isSelected && isCenter)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(Dimensions.r4.dynamicW),
                          decoration: BoxDecoration(
                            color: context.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            size: Dimensions.r10.dynamicH,
                            color: AppColor.whiteColor,
                          ),
                        ),
                      ),
                    if (opticalDepth > 0.02)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  (context.isDarkMode
                                          ? AppColor.blackColor
                                          : AppColor.whiteColor)
                                      .withValues(
                                        alpha: opticalDepth.clamp(0.0, 0.12),
                                      ),
                              borderRadius: BorderRadius.circular(cardRadius),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildArtwork(BuildContext context) {
    final imageWidth = Dimensions.r50.dynamicW;
    final imageHeight = Dimensions.r50.dynamicH;

    if (isAll) {
      return Assets.images.onboarding.welcomeSportsCollection.image(
        width: imageWidth,
        height: imageHeight,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.sports,
            size: Dimensions.r36.dynamicH,
            color: context.primaryColor,
          );
        },
      );
    }

    return AppAssets.getCategoryGen(slug).image(
      width: imageWidth,
      height: imageHeight,
      cacheWidth: 160,
      cacheHeight: 160,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          AppAssets.getCategoryFallbackIcon(slug),
          size: Dimensions.r36.dynamicH,
          color: context.primaryColor,
        );
      },
    );
  }
}
