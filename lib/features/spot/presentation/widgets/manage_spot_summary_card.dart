import '../../../../core/base_import.dart';
import '../../domain/entities/request_entity.dart';
import '../../domain/policies/spot_participation_policy.dart';

/// Summary header card displaying spot progress and open spots in Manage Requests.
class ManageSpotSummaryCard extends StatelessWidget {
  final RequestEntity post;

  const ManageSpotSummaryCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final title = post.title.trim().isNotEmpty
        ? post.title.trim()
        : AppUtils.getDisplayLocation(
            context,
            post.locationName,
            cityId: post.cityId,
          );
    final remaining = SpotParticipationPolicy.remainingSpots(post);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.mdLg),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: AppRadius.xxlBorderRadius,
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: AppRadius.mdBorderRadius,
                ),
                child: Center(
                  child: Category3DIcon(
                    category: post.categoryId,
                    size: Dimensions.r28.dynamicH,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      AppUtils.formatDateTime(post.eventDateTime),
                      style: context.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              ActivityMetadataIcon.participants(
                size: Dimensions.r18.dynamicH,
                fallbackColor: colors.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  context.loc.openSpotsRemaining(
                    remaining,
                    post.maxParticipants,
                  ),
                  style: context.bodyMedium?.copyWith(
                    color: remaining == 0 ? colors.error : colors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: AppRadius.pillBorderRadius,
            child: LinearProgressIndicator(
              value: SpotParticipationPolicy.occupancy(post),
              minHeight: 7,
              backgroundColor: colors.surfaceContainerHighest,
            ),
          ),
        ],
      ),
    );
  }
}
