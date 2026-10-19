import '../../../../core/base_import.dart';
import 'onboarding_slide_data.dart';

/// Single slide content for the KhelBhai onboarding carousel.
class OnboardingSlideItem extends StatelessWidget {
  final OnboardingSlideData slide;

  const OnboardingSlideItem({super.key, required this.slide});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight;
        final imageSize = (availableHeight * 0.42).clamp(160.0, 260.0);

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.r24.dynamicW,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: Dimensions.r8.dynamicH),
                    // 3D Illustration Container
                    Container(
                      width: imageSize,
                      height: imageSize,
                      decoration: BoxDecoration(
                        color: isDark
                            ? context.surfaceContainer
                            : AppColor.surfaceContainerLight,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: context.borderColor.withValues(alpha: 0.7),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: context.primaryColor.withValues(alpha: 0.12),
                            blurRadius: Dimensions.r28.dynamicR,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(Dimensions.r16.dynamicH),
                          child: slide.image.image(
                            fit: BoxFit.contain,
                            cacheWidth: 600,
                            cacheHeight: 600,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                slide.fallbackIcon,
                                size: Dimensions.r48.dynamicH,
                                color: context.primaryColor,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.r20.dynamicH),

                    // Optional Tagline Pill Badge
                    if (slide.tagline != null) ...[
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.r14.dynamicW,
                          vertical: Dimensions.r6.dynamicH,
                        ),
                        decoration: BoxDecoration(
                          color: context.primaryColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(
                            Dimensions.r999.dynamicR,
                          ),
                          border: Border.all(
                            color: context.primaryColor.withValues(alpha: 0.25),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          slide.tagline!,
                          style: TextStyle(
                            fontSize: Dimensions.r12.dynamicSP,
                            fontWeight: FontWeight.w700,
                            color: context.primaryColor,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.r12.dynamicH),
                    ],

                    // Title
                    Text(
                      slide.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: Dimensions.r24.dynamicSP,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.6,
                        color: context.textPrimary,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: Dimensions.r10.dynamicH),

                    // Description
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.r16.dynamicW,
                      ),
                      child: Text(
                        slide.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: Dimensions.r14.dynamicSP,
                          color: context.textSecondary,
                          height: 1.45,
                        ),
                      ),
                    ),

                    // Optional Final Screen Ready Badge
                    if (slide.readyHeading != null) ...[
                      SizedBox(height: Dimensions.r14.dynamicH),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.r16.dynamicW,
                          vertical: Dimensions.r8.dynamicH,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              context.primaryColor.withValues(alpha: 0.15),
                              AppColor.accentHighlight.withValues(alpha: 0.15),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(
                            Dimensions.r12.dynamicR,
                          ),
                          border: Border.all(
                            color: context.primaryColor.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.sports_rounded,
                              size: Dimensions.r18.dynamicH,
                              color: context.primaryColor,
                            ),
                            SizedBox(width: Dimensions.r8.dynamicW),
                            Flexible(
                              child: Text(
                                slide.readyHeading!,
                                style: TextStyle(
                                  fontSize: Dimensions.r13.dynamicSP,
                                  fontWeight: FontWeight.w800,
                                  color: context.primaryColor,
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    SizedBox(height: Dimensions.r8.dynamicH),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
