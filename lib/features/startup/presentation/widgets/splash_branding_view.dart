import 'package:lastspot_app/core/base_import.dart';

/// Renders the signature Sunset Orange full-screen KhelBhai splash identity.
/// Features the approved full-bleed 3D stadium artwork with the mascot, sports equipment,
/// official 3D embossed KhelBhai brand logo, and the clean white animated progress indicator.
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
    return FadeTransition(
      opacity: fadeAnimation,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Full-bleed edge-to-edge 3D artwork (fills entire screen seamlessly)
          ScaleTransition(
            scale: scaleAnimation,
            child: Assets.branding.khelbhaiSplashRestored.image(
              fit: BoxFit.cover,
              alignment: Alignment.center,
              filterQuality: FilterQuality.high,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColor.primaryColor,
                  alignment: Alignment.center,
                  child: Assets.branding.khelbhaiLogoWhite.image(
                    width: Dimensions.r240.dynamicW,
                    fit: BoxFit.contain,
                  ),
                );
              },
            ),
          ),

          // 2. Animated White Capsule Progress Indicator (positioned matching approved IM2 design)
          Positioned(
            left: 0,
            right: 0,
            bottom: Dimensions.r72.dynamicH,
            child: Center(
              child: SizedBox(
                width: Dimensions.r160.dynamicW,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.r999),
                  child: LinearProgressIndicator(
                    minHeight: Dimensions.r4.dynamicH + 1,
                    backgroundColor: AppColor.whiteColor.withValues(
                      alpha: 0.28,
                    ),
                    color: AppColor.whiteColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
