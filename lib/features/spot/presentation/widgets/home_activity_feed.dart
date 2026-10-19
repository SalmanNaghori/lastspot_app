import 'package:lastspot_app/core/base_import.dart';

import '../../../categories/domain/entities/category.dart';
import '../../domain/entities/request_entity.dart';
import '../bloc/home_state.dart';
import 'compact_spot_card.dart';
import 'home_section_header.dart';

class HomeActivityFeed extends StatelessWidget {
  final HomeState state;
  final List<CategoryEntity> categories;
  final VoidCallback onRetry;
  final VoidCallback onViewAll;
  final VoidCallback onCreateActivity;
  final void Function(RequestEntity activity, String prefix) onActivityTap;

  const HomeActivityFeed({
    super.key,
    required this.state,
    required this.categories,
    required this.onRetry,
    required this.onViewAll,
    required this.onCreateActivity,
    required this.onActivityTap,
  });

  @override
  Widget build(BuildContext context) {
    if (state is HomeInitial || state is HomeLoading) {
      return SliverToBoxAdapter(child: AppLoading.shimmerFeed());
    }
    if (state is HomeNetworkError || state is HomeServerError) {
      final isNetworkError = state is HomeNetworkError;
      return SliverToBoxAdapter(
        child: AppErrorState(
          message: isNetworkError
              ? context.loc.homeFeedNetworkError
              : context.loc.homeFeedLoadError,
          isNetwork: isNetworkError,
          onRetry: onRetry,
        ),
      );
    }
    if (state is! HomeSuccess) return const SliverToBoxAdapter();

    final home = state as HomeSuccess;
    if (home.hasFeedError) {
      return SliverToBoxAdapter(
        child: AppErrorState(
          message: home.isFeedNetworkError
              ? context.loc.homeFeedNetworkError
              : context.loc.homeFeedLoadError,
          isNetwork: home.isFeedNetworkError,
          onRetry: onRetry,
        ),
      );
    }
    if (home.isEmpty) {
      return SliverToBoxAdapter(
        child: AppEmptyState.activities(
          title: context.loc.noActivitiesFound,
          message: context.loc.noActivitiesInArea,
          actionLabel: context.loc.homeCreateActivity,
          onActionPressed: onCreateActivity,
          secondaryActionLabel: context.loc.navExplore,
          onSecondaryActionPressed: onViewAll,
        ),
      );
    }

    final sections = [
      if (home.urgentMatches.isNotEmpty)
        HomeActivityFeedSection(
          items: home.urgentMatches,
          prefix: 'urgent',
          showViewAll: true,
        ),
      if (home.comingUp.isNotEmpty)
        HomeActivityFeedSection(
          title: context.loc.comingUp,
          subtitle: context.loc.homeComingUpSubtitle,
          items: home.comingUp,
          prefix: 'coming',
          compact: true,
        ),
      if (home.laterActivities.isNotEmpty)
        HomeActivityFeedSection(
          title: context.loc.homeLaterOn,
          subtitle: context.loc.homeLaterSubtitle,
          items: home.laterActivities,
          prefix: 'later',
        ),
    ];
    final childCount = sections.fold<int>(0, (count, section) {
      final hasHeader = section.title != null || section.showViewAll;
      return count + section.items.length + (hasHeader ? 1 : 0);
    });

    return SliverList.builder(
      itemCount: childCount,
      itemBuilder: (context, index) {
        var sectionOffset = 0;
        for (final section in sections) {
          final hasHeader = section.title != null || section.showViewAll;
          final sectionLength = section.items.length + (hasHeader ? 1 : 0);
          if (index < sectionOffset + sectionLength) {
            final localIndex = index - sectionOffset;
            if (hasHeader && localIndex == 0) {
              return HomeActivityFeedSectionHeader(
                section: section,
                onViewAll: onViewAll,
              );
            }
            final itemIndex = localIndex - (hasHeader ? 1 : 0);
            return HomeActivityFeedItem(
              key: ValueKey('${section.prefix}_${section.items[itemIndex].id}'),
              activity: section.items[itemIndex],
              categories: categories,
              compact: section.compact,
              prefix: section.prefix,
              onTap: onActivityTap,
            );
          }
          sectionOffset += sectionLength;
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class HomeActivityFeedSection {
  final String? title;
  final String? subtitle;
  final List<RequestEntity> items;
  final String prefix;
  final bool compact;
  final bool showViewAll;

  const HomeActivityFeedSection({
    this.title,
    this.subtitle,
    required this.items,
    required this.prefix,
    this.compact = false,
    this.showViewAll = false,
  });
}

class HomeActivityFeedSectionHeader extends StatelessWidget {
  final HomeActivityFeedSection section;
  final VoidCallback onViewAll;

  const HomeActivityFeedSectionHeader({
    super.key,
    required this.section,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final header = HomeSectionHeader(
      title: section.title ?? context.loc.urgentMatchesTitle,
      subtitle: section.subtitle,
      viewAllLabel: section.showViewAll ? context.loc.viewAll : null,
      onViewAll: section.showViewAll ? onViewAll : null,
    );
    return Padding(
      padding: const EdgeInsets.only(
        top: AppSpacing.lg,
        bottom: AppSpacing.md,
        left: AppSpacing.md,
        right: AppSpacing.md,
      ),
      child: header,
    );
  }
}

class HomeActivityFeedItem extends StatelessWidget {
  final RequestEntity activity;
  final List<CategoryEntity> categories;
  final bool compact;
  final String prefix;
  final void Function(RequestEntity activity, String prefix) onTap;

  const HomeActivityFeedItem({
    super.key,
    required this.activity,
    required this.categories,
    required this.compact,
    required this.prefix,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final category = categories
        .where((item) => item.id == activity.categoryId)
        .firstOrNull;
    final child = compact
        ? CompactSpotCard(
            spot: activity,
            categoryName: category?.name ?? context.loc.navActivities,
            categoryIcon: category?.icon ?? '🎯',
            heroTagPrefix: prefix,
            onTap: () => onTap(activity, prefix),
          )
        : ActivityCard(
            spot: activity,
            categoryName: category?.name ?? context.loc.navActivities,
            categoryIcon: category?.icon ?? '🎯',
            heroTagPrefix: prefix,
            onTap: () => onTap(activity, prefix),
          );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: child,
    );
  }
}
