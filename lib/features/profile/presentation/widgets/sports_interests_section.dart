import '../../../../core/base_import.dart';

/// Interactive sports interests section displaying 3D category icons.
///
/// Features:
/// - Real user-selected sports interests from [UserProfile.sportsInterests].
/// - High quality 3D artwork for each sport via [Category3DIcon].
/// - Quick "Edit" action navigating to the profile editor.
/// - Friendly empty state when no interests have been set.
class SportsInterestsSection extends StatelessWidget {
  final List<String> interests;
  final VoidCallback onEditInterests;

  const SportsInterestsSection({
    super.key,
    required this.interests,
    required this.onEditInterests,
  });

  String _formatCategoryLabel(String category) {
    if (category.isEmpty) return category;
    final words = category.replaceAll('-', ' ').replaceAll('_', ' ').split(' ');
    return words
        .map(
          (w) => w.isNotEmpty
              ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}'
              : '',
        )
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final hasInterests = interests.isNotEmpty;

    return Container(
      padding: EdgeInsets.all(Dimensions.r16.dynamicW),
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(Dimensions.r20.dynamicR),
        border: Border.all(
          color: context.colorScheme.outlineVariant.withValues(alpha: 0.35),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.sports_soccer_rounded,
                      size: Dimensions.r18.dynamicH,
                      color: context.primaryColor,
                    ),
                    SizedBox(width: Dimensions.r8.dynamicW),
                    Flexible(
                      child: Text(
                        loc.sportsInterests,
                        style: TextStyle(
                          fontSize: Dimensions.r15.dynamicSP,
                          fontWeight: FontWeight.w800,
                          color: context.textPrimary,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: Dimensions.r8.dynamicW),
              TextButton(
                onPressed: onEditInterests,
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  loc.editInterests,
                  style: TextStyle(
                    fontSize: Dimensions.r12.dynamicSP,
                    fontWeight: FontWeight.w700,
                    color: context.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Dimensions.r12.dynamicH),

          // Content
          if (!hasInterests)
            Padding(
              padding: EdgeInsets.symmetric(vertical: Dimensions.r8.dynamicH),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      loc.noSportsInterests,
                      style: TextStyle(
                        fontSize: Dimensions.r12.dynamicSP,
                        color: context.textSecondary,
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: onEditInterests,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: context.primaryColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.r12.dynamicW,
                        vertical: Dimensions.r6.dynamicH,
                      ),
                      side: BorderSide(color: context.primaryColor, width: 1.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          Dimensions.r8.dynamicR,
                        ),
                      ),
                    ),
                    child: Text(
                      loc.editInterests,
                      style: TextStyle(
                        fontSize: Dimensions.r11.dynamicSP,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Wrap(
              spacing: Dimensions.r8.dynamicW,
              runSpacing: Dimensions.r8.dynamicH,
              children: interests.map((sport) {
                final label = _formatCategoryLabel(sport);
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.r10.dynamicW,
                    vertical: Dimensions.r6.dynamicH,
                  ),
                  decoration: BoxDecoration(
                    color: context.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(
                      Dimensions.r16.dynamicR,
                    ),
                    border: Border.all(
                      color: context.colorScheme.outlineVariant.withValues(
                        alpha: 0.35,
                      ),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Category3DIcon(
                        category: sport,
                        size: Dimensions.r22.dynamicH,
                      ),
                      SizedBox(width: Dimensions.r6.dynamicW),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: Dimensions.r12.dynamicSP,
                          fontWeight: FontWeight.w600,
                          color: context.textPrimary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
