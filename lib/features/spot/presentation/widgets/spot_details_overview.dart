import 'package:lastspot_app/core/base_import.dart';
import '../../domain/entities/request_entity.dart';
import 'spot_host_avatar.dart';

class SpotDetailsOverview extends StatelessWidget {
  final RequestEntity post;

  const SpotDetailsOverview({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final colors = context.colorScheme;
    final status = switch (post.status) {
      RequestStatus.open => loc.detailsOpen,
      RequestStatus.full => loc.statusFull,
      RequestStatus.completed => loc.statusCompleted,
      RequestStatus.cancelled => loc.statusCancelled,
      RequestStatus.expired => loc.statusExpired,
      RequestStatus.draft => loc.detailsDraft,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.r10.dynamicW,
                vertical: Dimensions.r6.dynamicH,
              ),
              decoration: BoxDecoration(
                color: context.isDarkMode
                    ? context.surfaceContainer
                    : context.surfaceContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
                border: Border.all(
                  color: context.borderColor.withValues(alpha: 0.6),
                  width: Dimensions.w1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Category3DIcon(
                    category: post.categoryId,
                    size: Dimensions.r18.dynamicH,
                  ),
                  SizedBox(width: Dimensions.r6.dynamicW),
                  Text(
                    AppAssets.resolveCategoryName(
                      post.categoryId,
                    ).capitalizeFirst(),
                    style: TextStyle(
                      fontSize: Dimensions.r11.dynamicSP,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                      color: context.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: Dimensions.r8.dynamicW),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.r12.dynamicW,
                vertical: Dimensions.r6.dynamicH,
              ),
              decoration: BoxDecoration(
                color: post.status == RequestStatus.open
                    ? context.primaryColor.withValues(alpha: 0.12)
                    : colors.secondaryContainer,
                borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: Dimensions.r11.dynamicSP,
                  fontWeight: FontWeight.w700,
                  color: post.status == RequestStatus.open
                      ? context.primaryColor
                      : colors.onSecondaryContainer,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          post.title.trim().isEmpty ? post.locationName : post.title.trim(),
          style: context.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            SpotHostAvatar(
              name: post.hostProfile?.fullName ?? loc.activityHost,
              photoUrl: post.hostProfile?.avatarUrl,
            ),
            const SizedBox(width: AppSpacing.smLg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.detailsHostedBy,
                    style: context.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    post.hostProfile?.fullName ?? loc.activityHost,
                    style: context.titleSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
