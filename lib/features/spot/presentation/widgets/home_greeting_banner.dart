import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/core/widgets/animation/widget_animation.dart';

class HomeGreetingBanner extends StatelessWidget {
  final String? userName;
  final String? city;
  final VoidCallback? onCityTap;
  final VoidCallback? onExploreTap;
  final VoidCallback? onCreateTap;

  const HomeGreetingBanner({
    super.key,
    this.userName,
    this.city,
    this.onCityTap,
    this.onExploreTap,
    this.onCreateTap,
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppSpacing.sm,
              children: [
                Text('$greeting $firstName', style: type.titleMedium),
                TextButton.icon(
                  onPressed: onCityTap,
                  icon: const Icon(Icons.location_on_outlined),
                  label: Text(city ?? loc.selectCity),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              decoration: BoxDecoration(
                color: context.colorScheme.onPrimaryContainer,
                borderRadius: AppRadius.xxlBorderRadius,
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  PositionedDirectional(
                    end: -AppSpacing.xxl,
                    top: AppSpacing.xl,
                    child: ExcludeSemantics(
                      child: Transform.rotate(
                        angle: -0.3,
                        child: Icon(
                          Icons.sports_basketball_outlined,
                          size: Dimensions.r64 * 3,
                          color: context.primaryContainer.withValues(
                            alpha: 0.12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.smLg,
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: AppColor.whiteColor.withValues(alpha: 0.12),
                            borderRadius: AppRadius.pillBorderRadius,
                          ),
                          child: Text(
                            loc.discoveryEyebrow,
                            style: type.labelSmall?.copyWith(
                              color: context.primaryContainer,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          loc.discoveryHeadline,
                          style: type.displaySmall?.copyWith(
                            color: AppColor.whiteColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.smLg),
                        Text(
                          loc.discoverySubtitle,
                          style: type.bodyMedium?.copyWith(
                            color: context.primaryContainer,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Wrap(
                          spacing: AppSpacing.smLg,
                          runSpacing: AppSpacing.sm,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            if (onExploreTap != null)
                              FilledButton.icon(
                                onPressed: onExploreTap,
                                style: FilledButton.styleFrom(
                                  minimumSize: const Size(0, AppSpacing.xxxl),
                                  backgroundColor:
                                      context.colorScheme.secondaryContainer,
                                  foregroundColor: AppColor.secondaryColor,
                                ),
                                icon: const Icon(Icons.arrow_outward_rounded),
                                label: Text(loc.browseActivities),
                              ),
                            if (onCreateTap != null)
                              TextButton.icon(
                                onPressed: onCreateTap,
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColor.whiteColor,
                                  minimumSize: const Size(0, AppSpacing.xxxl),
                                ),
                                icon: const Icon(Icons.add_rounded),
                                label: Text(loc.discoveryHost),
                              ),
                          ],
                        ),
                      ],
                    ),
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
