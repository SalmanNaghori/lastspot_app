import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/core/widgets/animation/widget_animation.dart';

class HomeGreetingBanner extends StatelessWidget {
  final String? userName;
  final String? city;
  final VoidCallback? onCityTap;
  final VoidCallback? onExploreTap;

  const HomeGreetingBanner({
    super.key,
    this.userName,
    this.city,
    this.onCityTap,
    this.onExploreTap,
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

    return AnimationWrapper(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColor.primaryDarkColor,
          borderRadius: AppRadius.xxlBorderRadius,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            PositionedDirectional(
              end: -AppSpacing.xl,
              bottom: -AppSpacing.xl,
              child: ExcludeSemantics(
                child: Icon(
                  Icons.sports_basketball_outlined,
                  size: Dimensions.r64 * 3,
                  color: AppColor.primaryContainerLight.withValues(alpha: 0.08),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$greeting, $firstName',
                    style: type.labelLarge?.copyWith(
                      color: AppColor.primaryContainerLight,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    loc.discoveryHeadline,
                    style: type.headlineLarge?.copyWith(
                      color: AppColor.whiteColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.smLg),
                  Text(
                    loc.discoverySubtitle,
                    style: type.bodyMedium?.copyWith(
                      color: AppColor.primaryContainerLight,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (onExploreTap != null)
                        FilledButton.icon(
                          onPressed: onExploreTap,
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(0, AppSpacing.xxxl),
                            backgroundColor: AppColor.accentHighlight,
                            foregroundColor: AppColor.secondaryColor,
                          ),
                          icon: const Icon(Icons.arrow_outward_rounded),
                          label: Text(loc.browseActivities),
                        ),
                      TextButton.icon(
                        onPressed: onCityTap,
                        style: TextButton.styleFrom(
                          foregroundColor: AppColor.whiteColor,
                          minimumSize: const Size(0, AppSpacing.xxxl),
                        ),
                        icon: const Icon(Icons.location_on_outlined),
                        label: Text(city ?? loc.selectCity),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
