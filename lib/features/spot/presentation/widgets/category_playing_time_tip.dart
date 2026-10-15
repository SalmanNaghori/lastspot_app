import 'package:lastspot_app/core/base_import.dart';
import '../../../categories/domain/entities/category.dart';

/// Informational tip banner showing recommended playing hours for a selected sport category.
/// Matches the Fareeq sports theme with a soft tinted surface, subtle border, and schedule icon.
class CategoryPlayingTimeTip extends StatelessWidget {
  final CategoryEntity? category;

  const CategoryPlayingTimeTip({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final cat = category;
    if (cat == null) return const SizedBox.shrink();

    final window = AppAssets.getSuggestedPlayingTimes(cat.slug);

    return Container(
      margin: EdgeInsets.only(top: Dimensions.r12.dynamicH),
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.r12.dynamicW,
        vertical: Dimensions.r10.dynamicH,
      ),
      decoration: BoxDecoration(
        color: context.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
        border: Border.all(
          color: context.primaryColor.withValues(alpha: 0.22),
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(Dimensions.r6.dynamicH),
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.schedule_rounded,
              size: Dimensions.r16.dynamicH,
              color: context.primaryColor,
            ),
          ),
          SizedBox(width: Dimensions.r10.dynamicW),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.loc.suggestedPlayingHours,
                  style: TextStyle(
                    fontSize: Dimensions.r12.dynamicSP,
                    fontWeight: FontWeight.w700,
                    color: context.primaryColor,
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(height: Dimensions.r2.dynamicH),
                Text(
                  window,
                  style: TextStyle(
                    fontSize: Dimensions.r12.dynamicSP,
                    fontWeight: FontWeight.w500,
                    color: context.textPrimary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
