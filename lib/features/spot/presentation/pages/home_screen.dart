import 'package:lastspot_app/core/base_import.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../bloc/home_cubit.dart';
import '../bloc/home_state.dart';
import '../../../auth/presentation/bloc/profile_cubit.dart';
import '../widgets/feed_skeleton_loading.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_greeting_banner.dart';
import '../widgets/home_section_header.dart';
import '../widgets/activity_card.dart';
import '../widgets/sport_filter_chips.dart';
import '../../../cities/domain/entities/city_entity.dart';
import '../../../categories/domain/entities/category.dart';
import '../../domain/entities/request_entity.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileState = context.read<ProfileCubit>().state;
      String? cityId;
      if (profileState is ProfileLoaded) {
        cityId = profileState.profile.cityId;
      }
      context.read<HomeCubit>().loadHomeData(cityId: cityId);
    });
  }

  void _onSpotTap(RequestEntity spot, [String? prefix]) {
    final extra = {
      if (prefix != null) 'heroTag': '${prefix}_activity_image_${spot.id}',
      'spot': spot,
    };
    context.push(AppRoutes.spotDetailsPath(spot.id), extra: extra);
  }

  void _onNotificationTap() => context.push(AppRoutes.notifications);

  void _onViewAllTap() => context.go(AppRoutes.explore);

  void _onCreateActivityTap() => context.push(AppRoutes.create);

  void _onRefresh() {
    final state = context.read<HomeCubit>().state;
    String? cityId;
    if (state is HomeSuccess) {
      cityId = state.selectedCityId;
    }
    context.read<HomeCubit>().loadHomeData(cityId: cityId);
  }

  void _onCitySelected(String cityId, String cityName) {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      context.read<HomeCubit>().updateSelectedCity(userId, cityId, cityName);
    }
  }

  void _showCityPicker(
    BuildContext context,
    List<CityEntity> cities,
    String? selectedCityId,
  ) {
    AppBottomSheet.show(
      context: context,
      isScrollControlled: false,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(Dimensions.r16.dynamicW),
                child: Text(
                  context.loc.selectCity,
                  style: TextStyle(
                    fontSize: Dimensions.r18.dynamicSP,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: cities.length,
                  itemBuilder: (context, index) {
                    final city = cities[index];
                    final isSelected = city.id == selectedCityId;
                    return ListTile(
                      title: Text(
                        city.name,
                        style: TextStyle(
                          color: isSelected
                              ? context.primaryColor
                              : context.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check, color: context.primaryColor)
                          : null,
                      onTap: () {
                        Navigator.pop(context);
                        _onCitySelected(city.id, city.name);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeedError(BuildContext context, String message, IconData icon) {
    return Padding(
      padding: EdgeInsets.all(Dimensions.r32.dynamicW),
      child: Column(
        children: [
          Icon(
            icon,
            size: Dimensions.r48.dynamicH,
            color: context.textSecondary,
          ),
          SizedBox(height: Dimensions.r16.dynamicH),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: context.textSecondary),
          ),
          SizedBox(height: Dimensions.r16.dynamicH),
          FilledButton(onPressed: _onRefresh, child: const Text("Try Again")),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.r32.dynamicW,
          vertical: Dimensions.r48.dynamicH,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(Dimensions.r20.dynamicW),
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.explore_outlined,
                size: Dimensions.r48.dynamicH,
                color: context.primaryColor,
              ),
            ),
            SizedBox(height: Dimensions.r24.dynamicH),
            Text(
              "Your next activity starts here",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Dimensions.r18.dynamicSP,
                fontWeight: FontWeight.w700,
                color: context.textPrimary,
              ),
            ),
            SizedBox(height: Dimensions.r12.dynamicH),
            Text(
              "No activities nearby yet.\nCreate one and find people to join you.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Dimensions.r14.dynamicSP,
                color: context.textSecondary,
                height: 1.5,
              ),
            ),
            SizedBox(height: Dimensions.r32.dynamicH),
            SizedBox(
              height: Dimensions.r48.dynamicH,
              width: double.infinity,
              child: FilledButton(
                onPressed: _onCreateActivityTap,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      Dimensions.r12.dynamicR,
                    ),
                  ),
                ),
                child: Text(
                  "+ Create Activity",
                  style: TextStyle(
                    fontSize: Dimensions.r16.dynamicSP,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: Dimensions.r16.dynamicH),
            SizedBox(
              height: Dimensions.r48.dynamicH,
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _onViewAllTap,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: context.borderColor, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      Dimensions.r12.dynamicR,
                    ),
                  ),
                ),
                child: Text(
                  "Explore Activities",
                  style: TextStyle(
                    fontSize: Dimensions.r16.dynamicSP,
                    fontWeight: FontWeight.w600,
                    color: context.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final bool isLoading = state is HomeLoading || state is HomeInitial;
            final bool isNetworkError = state is HomeNetworkError;
            final bool isServerError = state is HomeServerError;
            final HomeSuccess? successState = state is HomeSuccess
                ? state
                : null;

            final List<CategoryEntity> categories =
                successState?.categories ?? [];
            final List<CityEntity> cities = successState?.cities ?? [];
            final String? selectedCityId = successState?.selectedCityId;
            final bool hasCitiesError = successState?.hasCitiesError ?? false;
            final bool hasCategoriesError =
                successState?.hasCategoriesError ?? false;
            final bool hasFeedError = successState?.hasFeedError ?? false;
            final bool isFeedNetworkError =
                successState?.isFeedNetworkError ?? false;

            final userCityName = hasCitiesError
                ? "Failed to load cities"
                : cities
                          .where((c) => c.id == selectedCityId)
                          .map((c) => c.name)
                          .firstOrNull ??
                      loc.selectCity;

            // Debug logs
            if (isLoading) {
              debugPrint("FeedState: Loading");
            } else if (isNetworkError ||
                isServerError ||
                (successState != null && hasFeedError)) {
              debugPrint("FeedState: Error");
            } else if (successState != null && successState.isEmpty) {
              debugPrint("FeedState: Success Empty");
            } else if (successState != null) {
              debugPrint("FeedState: Success");
            }

            return RefreshIndicator(
              onRefresh: () async => _onRefresh(),
              color: AppColor.primaryColor,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // --- PERMANENT STRUCTURE ---
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: Dimensions.r8.dynamicH),
                        HomeGreetingBanner(
                          userName: userName,
                          city: userCityName,
                          onCityTap: (isLoading || hasCitiesError)
                              ? () => _onRefresh()
                              : () => _showCityPicker(
                                  context,
                                  cities,
                                  selectedCityId,
                                ),
                        ),
                        SizedBox(height: Dimensions.r20.dynamicH),
                        if (hasCategoriesError)
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.r16.dynamicW,
                            ),
                            child: TextButton(
                              onPressed: _onRefresh,
                              child: const Text("Retry Categories"),
                            ),
                          )
                        else
                          SportFilterChips(
                            categories: categories,
                            selectedCategoryId: null,
                            onCategorySelected: (categoryId) {
                              if (categoryId != null) {
                                _onViewAllTap();
                              }
                            },
                          ),
                        SizedBox(height: Dimensions.r16.dynamicH),
                      ],
                    ),
                  ),

                  // --- ACTIVITY FEED SECTION ---
                  if (isLoading)
                    const SliverToBoxAdapter(child: FeedSkeletonLoading())
                  else if (isNetworkError ||
                      (successState != null &&
                          hasFeedError &&
                          isFeedNetworkError))
                    SliverToBoxAdapter(
                      child: _buildFeedError(
                        context,
                        "Couldn't load activities\nCheck your connection and try again.",
                        Icons.wifi_off,
                      ),
                    )
                  else if (isServerError ||
                      (successState != null && hasFeedError))
                    SliverToBoxAdapter(
                      child: _buildFeedError(
                        context,
                        "Something went wrong",
                        Icons.error_outline,
                      ),
                    )
                  else if (successState != null && successState.isEmpty)
                    SliverToBoxAdapter(child: _buildEmptyState(context))
                  else if (successState != null) ...[
                    // Urgent Matches
                    if (successState.urgentMatches.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: Dimensions.r20.dynamicH),
                            HomeSectionHeader(
                              title: loc.urgentMatchesTitle,
                              viewAllLabel: loc.viewAll,
                              onViewAll: _onViewAllTap,
                            ),
                            SizedBox(height: Dimensions.r16.dynamicH),
                          ],
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.r16.dynamicW,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final spot = successState.urgentMatches[index];
                            final category = categories
                                .where((c) => c.id == spot.categoryId)
                                .firstOrNull;
                            return ActivityCard(
                              spot: spot,
                              categoryName: category?.name ?? 'Sport',
                              categoryIcon: category?.icon ?? '🎯',
                              heroTagPrefix: 'urgent',
                              onTap: () => _onSpotTap(spot, 'urgent'),
                            );
                          }, childCount: successState.urgentMatches.length),
                        ),
                      ),
                    ],
                    // Nearby Activities
                    if (successState.nearbyActivities.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: Dimensions.r24.dynamicH),
                            HomeSectionHeader(
                              title: loc.nearbyActivities,
                              viewAllLabel: loc.viewAll,
                              onViewAll: _onViewAllTap,
                            ),
                            SizedBox(height: Dimensions.r16.dynamicH),
                            SizedBox(
                              height: 450.0.dynamicH,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.r16.dynamicW,
                                ),
                                itemCount: successState.nearbyActivities.length,
                                separatorBuilder: (context, index) => SizedBox(
                                  width: Dimensions.r12.dynamicW,
                                ),
                                itemBuilder: (context, index) {
                                  final spot = successState.nearbyActivities[index];
                                  final category = categories
                                      .where((c) => c.id == spot.categoryId)
                                      .firstOrNull;
                                  return ActivityCard(
                                    width: MediaQuery.of(context).size.width * 0.88,
                                    spot: spot,
                                    categoryName: category?.name ?? 'Sport',
                                    categoryIcon: category?.icon ?? '🎯',
                                    heroTagPrefix: 'nearby',
                                    onTap: () => _onSpotTap(spot, 'nearby'),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    // Coming Up
                    if (successState.comingUp.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: Dimensions.r24.dynamicH),
                            HomeSectionHeader(
                              title: loc.comingUp,
                              viewAllLabel: loc.viewAll,
                              onViewAll: _onViewAllTap,
                            ),
                            SizedBox(height: Dimensions.r16.dynamicH),
                          ],
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.r16.dynamicW,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final spot = successState.comingUp[index];
                            final category = categories
                                .where((c) => c.id == spot.categoryId)
                                .firstOrNull;
                            return ActivityCard(
                              spot: spot,
                              categoryName: category?.name ?? 'Sport',
                              categoryIcon: category?.icon ?? '🎯',
                              heroTagPrefix: 'coming',
                              onTap: () => _onSpotTap(spot, 'coming'),
                            );
                          }, childCount: successState.comingUp.length),
                        ),
                      ),
                    ],
                  ],
                  SliverToBoxAdapter(
                    child: SizedBox(height: Dimensions.r32.dynamicH),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
