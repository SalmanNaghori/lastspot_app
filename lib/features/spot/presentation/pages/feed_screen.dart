import 'package:lastspot_app/core/base_import.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../bloc/feed_bloc.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_greeting_banner.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/home_section_header.dart';
import '../widgets/home_spot_card.dart';
import '../widgets/popular_sports_grid.dart';
import '../widgets/sport_filter_chips.dart';
import '../widgets/feed_skeleton_loading.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    context.read<FeedBloc>().add(LoadFeedEvent());
  }

  void _onCategorySelected(String? category) {
    setState(() => _selectedCategory = category);
    context.read<FeedBloc>().add(LoadFeedEvent(category: category));
  }

  void _onSpotTap(String postId) => context.push(AppRoutes.spotDetailsPath(postId));

  void _onNotificationTap() => context.push(AppRoutes.notifications);

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final currentUser = Supabase.instance.client.auth.currentUser;
    final userName = currentUser?.userMetadata?['full_name'] as String?;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.systemUiOverlayStyle(context),
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        appBar: HomeAppBar(onNotificationTap: _onNotificationTap),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: _HomeHeader(
                userName: userName,
                selectedCategory: _selectedCategory,
                onCategorySelected: _onCategorySelected,
              ),
            ),
          ],
          body: BlocBuilder<FeedBloc, FeedState>(
            builder: (context, state) {
              if (state is FeedLoading) {
                return const FeedSkeletonLoading();
              }

              if (state is FeedError) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(Dimensions.r24.dynamicW),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.wifi_off_outlined,
                          size: Dimensions.r32.dynamicH * 1.75,
                          color: context.textSecondary,
                        ),
                        SizedBox(height: Dimensions.r16.dynamicH),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: Dimensions.r14.dynamicSP, color: context.textSecondary),
                        ),
                        SizedBox(height: Dimensions.r24.dynamicH),
                        FilledButton.icon(
                          onPressed: () => context.read<FeedBloc>().add(LoadFeedEvent(category: _selectedCategory)),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Try again'),
                          style: FilledButton.styleFrom(backgroundColor: AppColor.primaryColor),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is FeedLoaded) {
                if (state.posts.isEmpty) {
                  return _EmptyFeed(loc: loc);
                }

                final urgentPosts = state.posts
                    .where((p) => p.eventDateTime.difference(DateTime.now()).inHours < 24)
                    .toList();
                final recentPosts = state.posts.where((p) => !urgentPosts.contains(p)).toList();

                return CustomScrollView(
                  slivers: [
                    // ── Urgent Matches ──────────────────────────
                    if (urgentPosts.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: Dimensions.r20.dynamicH),
                            HomeSectionHeader(
                              title: 'Urgent Matches',
                              subtitle: loc.urgentMatchesSubtitle,
                              viewAllLabel: loc.viewAll,
                              onViewAll: () {},
                              leadingIcon: const Text('🔥', style: TextStyle(fontSize: 20)),
                            ),
                            SizedBox(height: Dimensions.r16.dynamicH),
                          ],
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.r16.dynamicW),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) =>
                                HomeSpotCard(spot: urgentPosts[index], onTap: () => _onSpotTap(urgentPosts[index].id)),
                            childCount: urgentPosts.length,
                          ),
                        ),
                      ),
                    ],

                    // ── Popular Sports ──────────────────────────
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: Dimensions.r8.dynamicH),
                          HomeSectionHeader(
                            title: loc.popularSports,
                            subtitle: loc.popularSportsSubtitle,
                            leadingIcon: const Text('🏆', style: TextStyle(fontSize: 20)),
                          ),
                          SizedBox(height: Dimensions.r14.dynamicH),
                          PopularSportsGrid(onSportTap: _onCategorySelected),
                          SizedBox(height: Dimensions.r24.dynamicH),
                        ],
                      ),
                    ),

                    // ── Nearby / Recent Activities ───────────────
                    if (recentPosts.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HomeSectionHeader(
                              title: loc.nearbyActivities,
                              viewAllLabel: loc.viewAll,
                              onViewAll: () {},
                              leadingIcon: Icon(
                                Icons.location_on,
                                color: AppColor.primaryColor,
                                size: Dimensions.r20.dynamicH,
                              ),
                            ),
                            SizedBox(height: Dimensions.r16.dynamicH),
                          ],
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.r16.dynamicW),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) =>
                                HomeSpotCard(spot: recentPosts[index], onTap: () => _onSpotTap(recentPosts[index].id)),
                            childCount: recentPosts.length,
                          ),
                        ),
                      ),
                    ],

                    // Bottom padding
                    SliverToBoxAdapter(child: SizedBox(height: Dimensions.r32.dynamicH)),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header widget
// ─────────────────────────────────────────────────────────────────────────────

class _HomeHeader extends StatelessWidget {
  final String? userName;
  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelected;

  const _HomeHeader({required this.userName, required this.selectedCategory, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Dimensions.r8.dynamicH),

        // ── Greeting banner ──────────────────────────
        HomeGreetingBanner(userName: userName),

        SizedBox(height: Dimensions.r16.dynamicH),

        // ── Search bar ───────────────────────────────
        const HomeSearchBar(),

        SizedBox(height: Dimensions.r14.dynamicH),

        // ── Sport filter chips ───────────────────────
        SportFilterChips(selectedCategory: selectedCategory, onCategorySelected: onCategorySelected),

        SizedBox(height: Dimensions.r8.dynamicH),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyFeed extends StatelessWidget {
  final AppLocalizations loc;

  const _EmptyFeed({required this.loc});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(Dimensions.r32.dynamicW),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: Dimensions.r48.dynamicW * 1.67,
              height: Dimensions.r48.dynamicH * 1.67,
              decoration: BoxDecoration(color: AppColor.primaryColor.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(Icons.sports_soccer, size: Dimensions.r24.dynamicH * 1.67, color: AppColor.primaryColor),
            ),
            SizedBox(height: Dimensions.r20.dynamicH),
            Text(
              loc.noSpotsFound,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: Dimensions.r15.dynamicSP, color: context.textSecondary, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}
