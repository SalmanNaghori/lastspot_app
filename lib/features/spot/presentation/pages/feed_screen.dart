import 'package:lastspot_app/core/base_import.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../auth/presentation/bloc/profile_cubit.dart';
import '../bloc/feed_bloc.dart';
import '../widgets/feed_skeleton_loading.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_greeting_banner.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/home_section_header.dart';
import '../widgets/home_spot_card.dart';
import '../widgets/sport_filter_chips.dart';

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

  void _onRefresh() => context.read<FeedBloc>().add(LoadFeedEvent(category: _selectedCategory));

  void _onViewAllTap() => context.go(AppRoutes.explore);

  void _onCityTap() {
    // TODO: Show city picker
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final currentUser = Supabase.instance.client.auth.currentUser;
    final userName = currentUser?.userMetadata?['full_name'] as String?;
    final profileState = context.watch<ProfileCubit>().state;
    final userCity = (profileState is ProfileLoaded) ? profileState.profile.city : loc.loading;

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
                city: userCity,
                selectedCategory: _selectedCategory,
                onCategorySelected: _onCategorySelected,
                onCityTap: _onCityTap,
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
                          Icons.wifi_off,
                          size: Dimensions.r48.dynamicH * 1.5,
                          color: context.textSecondary,
                        ),
                        SizedBox(height: Dimensions.r16.dynamicH),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: Dimensions.r16.dynamicSP, color: context.textPrimary),
                        ),
                        SizedBox(height: Dimensions.r32.dynamicH),
                        SizedBox(
                          width: double.infinity,
                          height: Dimensions.r48.dynamicH,
                          child: FilledButton.icon(
                            onPressed: _onRefresh,
                            icon: Icon(Icons.refresh, size: Dimensions.r20.dynamicH),
                            label: Text(
                              loc.tryAgain,
                              style: TextStyle(fontSize: Dimensions.r16.dynamicSP, fontWeight: FontWeight.w600),
                            ),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColor.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is FeedLoaded) {
                final now = DateTime.now();
                final todayPosts = state.posts
                    .where(
                      (p) =>
                          p.eventDateTime.year == now.year &&
                          p.eventDateTime.month == now.month &&
                          p.eventDateTime.day == now.day,
                    )
                    .toList();

                final urgentPosts = state.posts
                    .where((p) {
                      final diff = p.eventDateTime.difference(now);
                      return diff.inHours >= 0 && diff.inHours < 24 && !todayPosts.contains(p);
                    })
                    .toList();

                if (todayPosts.isEmpty && urgentPosts.isEmpty) {
                  return _EmptyFeed(loc: loc);
                }

                return CustomScrollView(
                  slivers: [
                    // ── Today's Matches ──────────────────────────
                    if (todayPosts.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: Dimensions.r20.dynamicH),
                            HomeSectionHeader(
                              title: loc.todaysMatches,
                              viewAllLabel: loc.viewAll,
                              onViewAll: _onViewAllTap,
                              leadingIcon: Text('📅', style: TextStyle(fontSize: Dimensions.r20.dynamicSP)),
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
                                HomeSpotCard(spot: todayPosts[index], onTap: () => _onSpotTap(todayPosts[index].id)),
                            childCount: todayPosts.length,
                          ),
                        ),
                      ),
                    ],

                    // ── Urgent Matches ──────────────────────────
                    if (urgentPosts.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: Dimensions.r20.dynamicH),
                            HomeSectionHeader(
                              title: loc.urgentMatchesTitle,
                              subtitle: loc.urgentMatchesSubtitle,
                              viewAllLabel: loc.viewAll,
                              onViewAll: _onViewAllTap,
                              leadingIcon: Text('🔥', style: TextStyle(fontSize: Dimensions.r20.dynamicSP)),
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
  final String? city;
  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelected;
  final VoidCallback? onCityTap;

  const _HomeHeader({
    required this.userName,
    this.city,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.onCityTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Dimensions.r8.dynamicH),

        // ── Greeting banner ──────────────────────────
        HomeGreetingBanner(userName: userName, city: city, onCityTap: onCityTap),

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
