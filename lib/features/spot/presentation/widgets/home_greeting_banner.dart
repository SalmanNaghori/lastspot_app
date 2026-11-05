import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/core/widgets/animation/widget_animation.dart';

class HomeGreetingBanner extends StatelessWidget {
  final String? userName;
  final String? city;
  final bool isCityError;
  final VoidCallback? onCityTap;

  const HomeGreetingBanner({
    super.key,
    this.userName,
    this.city,
    this.isCityError = false,
    this.onCityTap,
  });

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final colors = context.colorScheme;
    final type = Theme.of(context).textTheme;
    final name = userName?.trim().split(RegExp(r'\s+')).firstOrNull;
    final firstName = name == null || name.isEmpty ? loc.player : name;
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? loc.goodMorning
        : hour < 17
        ? loc.goodAfternoon
        : loc.goodEvening;

    final cleanGreeting = greeting.endsWith(',')
        ? greeting.substring(0, greeting.length - 1).trim()
        : greeting;

    return AnimationWrapper(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.r16.dynamicW),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$cleanGreeting, $firstName',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: type.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: Dimensions.r20.dynamicSP,
              ),
            ),
            SizedBox(height: Dimensions.r2.dynamicH),
            Text(
              loc.homeHeroTagline,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: type.bodyMedium?.copyWith(
                color: context.textSecondary,
                fontSize: Dimensions.r13.dynamicSP,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: Dimensions.r4.dynamicH),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onCityTap,
                  borderRadius: BorderRadius.circular(Dimensions.r8.dynamicR),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: Dimensions.r4.dynamicH,
                      horizontal: Dimensions.r2.dynamicW,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ActivityMetadataIcon.location(
                          width: Dimensions.r18.dynamicW,
                          height: Dimensions.r18.dynamicH,
                          fallbackColor: isCityError
                              ? colors.error
                              : colors.onSurfaceVariant,
                        ),
                        SizedBox(width: Dimensions.r6.dynamicW),
                        Flexible(
                          child: Text(
                            city ?? loc.selectCity,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: Dimensions.r13.dynamicSP,
                              fontWeight: FontWeight.w600,
                              color: isCityError
                                  ? colors.error
                                  : context.textPrimary,
                            ),
                          ),
                        ),
                        if (isCityError) ...[
                          SizedBox(width: Dimensions.r6.dynamicW),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.r6.dynamicW,
                              vertical: Dimensions.r2.dynamicH,
                            ),
                            decoration: BoxDecoration(
                              color: colors.errorContainer,
                              borderRadius: BorderRadius.circular(
                                Dimensions.r4.dynamicR,
                              ),
                            ),
                            child: Text(
                              loc.homeCityRetryHint,
                              style: TextStyle(
                                fontSize: Dimensions.r10.dynamicSP,
                                fontWeight: FontWeight.w700,
                                color: colors.onErrorContainer,
                              ),
                            ),
                          ),
                        ],
                        SizedBox(width: Dimensions.r4.dynamicW),
                        Icon(
                          isCityError
                              ? Icons.refresh_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          size: Dimensions.r18.dynamicH,
                          color: isCityError
                              ? colors.error
                              : context.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
