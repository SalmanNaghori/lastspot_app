import 'package:lastspot_app/core/base_import.dart';

/// Renders the restored, approved LastSpot Splash branding layout.
///
/// Restores the signature pitch green background identity, the approved premium 3D
/// sports artwork with soft dimensional depth and realistic equipment details, the
/// LastSpot brand typography, localized tagline, and the clean white progress indicator.
class SplashBrandingView extends StatelessWidget {
  const SplashBrandingView({
    super.key,
    required this.fadeAnimation,
    required this.scaleAnimation,
  });

  final Animation<double> fadeAnimation;
  final Animation<double> scaleAnimation;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.r24.dynamicW,
            vertical: Dimensions.r16.dynamicH,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Approved Premium 3D Sports Illustration
              FadeTransition(
                opacity: fadeAnimation,
                child: ScaleTransition(
                  scale: scaleAnimation,
                  child: AppAssets.welcomeSportsCollectionGen.image(
                    width: Dimensions.r200.dynamicW * 1.15,
                    height: Dimensions.r200.dynamicH * 1.15,
                    fit: BoxFit.contain,
                    cacheWidth: 512,
                    cacheHeight: 512,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.sports_soccer_rounded,
                        size: Dimensions.r64.dynamicH * 1.5,
                        color: AppColor.whiteColor,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: Dimensions.r24.dynamicH),

              // LastSpot Brand Title
              FadeTransition(
                opacity: fadeAnimation,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: Dimensions.r32.dynamicSP,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.6,
                    ),
                    children: [
                      const TextSpan(
                        text: AppString.appNamePrefix,
                        style: TextStyle(color: AppColor.whiteColor),
                      ),
                      const TextSpan(
                        text: AppString.appNameSuffix,
                        style: TextStyle(color: AppColor.accentHighlight),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: Dimensions.r8.dynamicH),

              // Localized Tagline
              FadeTransition(
                opacity: fadeAnimation,
                child: Text(
                  context.loc.appDescription,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Dimensions.r14.dynamicSP,
                    fontWeight: FontWeight.w500,
                    color: AppColor.whiteColor.withValues(alpha: 0.85),
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              SizedBox(height: Dimensions.r36.dynamicH),

              // Restored White Loading Indicator
              FadeTransition(
                opacity: fadeAnimation,
                child: SizedBox(
                  width: Dimensions.r140.dynamicW,
                  child: LinearProgressIndicator(
                    minHeight: Dimensions.r4.dynamicH,
                    borderRadius: BorderRadius.circular(Dimensions.r999),
                    backgroundColor: AppColor.whiteColor.withValues(
                      alpha: 0.22,
                    ),
                    color: AppColor.whiteColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
