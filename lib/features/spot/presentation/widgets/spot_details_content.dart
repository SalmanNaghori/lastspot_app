import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/core/widgets/animation/widget_animation.dart';
import '../bloc/spot_details_bloc.dart';
import 'spot_details_gallery.dart';
import 'spot_details_overview.dart';
import 'spot_details_info_card.dart';
import 'spot_details_player_tile.dart';

class SpotDetailsContent extends StatelessWidget {
  final SpotDetailsLoaded state;
  final String? heroTag;
  final VoidCallback onMap;

  const SpotDetailsContent({
    super.key,
    required this.state,
    this.heroTag,
    required this.onMap,
  });

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final post = state.post;
    final colors = context.colorScheme;
    final location = post.locationName.trim();
    final isSharedMapLink =
        location.startsWith('https://') || location.startsWith('http://');
    return CustomScrollView(
      key: PageStorageKey('details_${post.id}'),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.md),
          sliver: SliverList.list(
            children: [
              SpotDetailsGallery(post: post, heroTag: heroTag),
              const SizedBox(height: AppSpacing.lg),
              AnimationWrapper(child: SpotDetailsOverview(post: post)),
              const SizedBox(height: AppSpacing.lg),
              SpotDetailsInfoCard(
                icon: Icons.calendar_month_outlined,
                title: loc.detailsWhen,
                value: AppUtils.formatDate(post.eventDateTime.toLocal()),
                subtitle: AppUtils.formatTime(post.eventDateTime.toLocal()),
              ),
              const SizedBox(height: AppSpacing.smLg),
              SpotDetailsInfoCard(
                icon: Icons.location_on_outlined,
                title: loc.detailsWhere,
                value: isSharedMapLink
                    ? loc.detailsSharedMapLink
                    : AppUtils.getDisplayLocation(
                        context,
                        post.locationName,
                        cityId: post.cityId,
                      ),
                subtitle: isSharedMapLink
                    ? loc.detailsMapLinkHint
                    : loc.detailsMapSearchHint,
                actionLabel: isSharedMapLink
                    ? loc.detailsOpenMapLink
                    : loc.detailsSearchMaps,
                onAction: location.isEmpty ? null : onMap,
              ),
              if (post.description?.trim().isNotEmpty ?? false) ...[
                const SizedBox(height: AppSpacing.lg),
                Text(loc.detailsAbout, style: context.titleLarge),
                const SizedBox(height: AppSpacing.smLg),
                Text(
                  post.description!.trim(),
                  style: context.bodyMedium?.copyWith(height: 1.6),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              Text(loc.detailsPlayers, style: context.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              Text(
                loc.confirmedPlayers(
                  state.confirmedPlayers.length,
                  post.maxParticipants,
                ),
                style: context.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.smLg),
              if (state.confirmedPlayers.isEmpty)
                AppCard(
                  padding: const EdgeInsets.all(AppSpacing.mdLg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.groups_outlined,
                        color: colors.primary,
                        size: AppSpacing.xl,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(loc.detailsNoPlayers, style: context.titleSmall),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        loc.detailsNoPlayersHint,
                        style: context.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          sliver: SliverList.builder(
            itemCount: state.confirmedPlayers.length,
            itemBuilder: (context, index) => SpotDetailsPlayerTile(
              key: ValueKey(state.confirmedPlayers[index].id),
              player: state.confirmedPlayers[index],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.md),
          sliver: SliverToBoxAdapter(
            child: AppCard(
              padding: const EdgeInsets.all(AppSpacing.mdLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.shield_outlined, color: colors.primary),
                  const SizedBox(height: AppSpacing.smLg),
                  Text(loc.detailsSafety, style: context.titleMedium),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    loc.detailsSafetyNote,
                    style: context.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
      ],
    );
  }
}
