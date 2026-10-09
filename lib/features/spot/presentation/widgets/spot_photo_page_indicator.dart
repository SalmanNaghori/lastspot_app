import 'package:lastspot_app/core/base_import.dart';
import '../../../../core/theme/app_motion.dart';

class SpotPhotoPageIndicator extends StatelessWidget {
  final int page;
  final int count;

  const SpotPhotoPageIndicator({
    super.key,
    required this.page,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    if (count < 2) return const SizedBox.shrink();

    final dotCount = count > 5 ? 5 : count;
    final activeDot = page < dotCount ? page : dotCount - 1;

    return Semantics(
      liveRegion: true,
      label: context.loc.detailsPhotoLabel(page + 1, count),
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(dotCount, (index) {
            final active = index == activeDot;
            return AnimatedContainer(
              duration: AppMotion.duration(context, AppMotion.quick),
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs / 2),
              width: active ? AppSpacing.lg : AppSpacing.sm,
              height: AppSpacing.sm,
              decoration: BoxDecoration(
                color: active
                    ? context.colorScheme.primary
                    : context.colorScheme.outlineVariant,
                borderRadius: AppRadius.pillBorderRadius,
              ),
            );
          }),
        ),
      ),
    );
  }
}
