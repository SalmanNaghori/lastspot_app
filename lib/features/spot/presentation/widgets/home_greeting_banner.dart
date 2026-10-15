import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/core/widgets/animation/widget_animation.dart';

class HomeGreetingBanner extends StatelessWidget {
  final String? userName;
  final String? city;
  final VoidCallback? onCityTap;

  const HomeGreetingBanner({
    super.key,
    this.userName,
    this.city,
    this.onCityTap,
  });

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
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
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                onPressed: onCityTap,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: Icon(
                  Icons.location_on_outlined,
                  size: Dimensions.r16.dynamicH,
                  color: context.primaryColor,
                ),
                label: Text(
                  city ?? loc.selectCity,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: Dimensions.r13.dynamicSP,
                    fontWeight: FontWeight.w500,
                    color: context.textSecondary,
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
