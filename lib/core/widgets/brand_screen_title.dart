import '../base_import.dart';

/// The same centralized KhelBhai logo in Home and other screen headers.
class KhelBhaiLogo extends StatelessWidget {
  final double? width;
  final double? height;

  const KhelBhaiLogo({super.key, this.width, this.height});

  @override
  Widget build(BuildContext context) => Tooltip(
    message: AppString.appName,
    child:
        (context.isDarkMode
                ? AppAssets.khelbhaiLogoWhiteGen
                : AppAssets.khelbhaiLogoGen)
            .image(
              width: width ?? Dimensions.r120.dynamicW,
              height: height ?? Dimensions.r48.dynamicH,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.high,
              semanticLabel: AppString.appName,
            ),
  );
}

/// Keeps the shared logo beside a localized screen title without overflow.
class BrandedScreenTitle extends StatelessWidget {
  final String title;
  final TextStyle? style;

  const BrandedScreenTitle({super.key, required this.title, this.style});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      KhelBhaiLogo(
        width: Dimensions.r64.dynamicW,
        height: Dimensions.r28.dynamicH,
      ),
      SizedBox(width: Dimensions.r8.dynamicW),
      Flexible(
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: style,
        ),
      ),
    ],
  );
}
