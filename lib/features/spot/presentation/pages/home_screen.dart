import 'package:lastspot_app/core/base_import.dart';
import '../../../../core/services/explore_navigation_service.dart';
import '../bloc/home_cubit.dart';
import '../bloc/home_state.dart';
import '../../../auth/presentation/bloc/profile_cubit.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_greeting_banner.dart';
import '../widgets/popular_sports_grid.dart';
import '../../../cities/domain/entities/city_entity.dart';
import '../../../cities/presentation/widgets/city_selection_bottom_sheet.dart';
import '../../../categories/domain/entities/category.dart';
import '../../domain/entities/request_entity.dart';
import '../widgets/home_activity_hub.dart';
import '../widgets/home_activity_feed.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _loadedProfileCityId;
  List<String> _loadedCategoryPreferences = const [];
  bool _hasLoadedProfile = false;
  late final ExploreNavigationService _exploreNavService;

  @override
  void initState() {
    super.initState();
    _exploreNavService = sl<ExploreNavigationService>();
    _exploreNavService.addListener(_onExploreNavChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final profileState = context.read<ProfileCubit>().state;
      if (profileState is ProfileLoaded) {
        _loadHomeForProfile(profileState);
      } else if (profileState is ProfileError) {
        _loadHomeWithoutProfile();
      }
    });
  }

  @override
  void dispose() {
    _exploreNavService.removeListener(_onExploreNavChanged);
    super.dispose();
  }

  void _onExploreNavChanged() {
    if (!mounted) return;
    final cityId = _exploreNavService.selectedCityId;
    if (cityId != null && cityId != _loadedProfileCityId) {
      _loadedProfileCityId = cityId;
      final profileState = context.read<ProfileCubit>().state;
      final preferences = profileState is ProfileLoaded
          ? profileState.profile.sportsInterests
          : _loadedCategoryPreferences;
      context.read<HomeCubit>().loadHomeData(
        cityId: cityId,
        categoryPreferences: preferences,
      );
    }
  }

  void _loadHomeForProfile(ProfileLoaded state) {
    final profile = state.profile;
    final categoryIds = profile.sportsInterests;
    if (_hasLoadedProfile &&
        _loadedProfileCityId == profile.cityId &&
        _loadedCategoryPreferences.join(',') == categoryIds.join(',')) {
      return;
    }
    _hasLoadedProfile = true;
    _loadedProfileCityId = profile.cityId;
    _loadedCategoryPreferences = List.of(categoryIds);
    context.read<HomeCubit>().loadHomeData(
      cityId: profile.cityId,
      categoryPreferences: categoryIds,
    );
  }

  void _loadHomeWithoutProfile() {
    if (_hasLoadedProfile) return;
    _hasLoadedProfile = true;
    _loadedProfileCityId = null;
    _loadedCategoryPreferences = const [];
    context.read<HomeCubit>().loadHomeData();
  }

  void _onSpotTap(RequestEntity spot, [String? prefix]) {
    final extra = {
      if (prefix != null) 'heroTag': '${prefix}_activity_image_${spot.id}',
      'spot': spot,
    };
    context.push(AppRoutes.spotDetailsPath(spot.id), extra: extra);
  }

  void _onNotificationTap() => context.push(AppRoutes.notifications);

  void _onCategoryTap(CategoryEntity category) {
    _exploreNavService.navigateToCategory(category.id);
    context.go(AppRoutes.explore);
  }

  void _onViewAllTap() {
    _exploreNavService.navigateToCategory(null);
    context.go(AppRoutes.explore);
  }

  void _onCreateActivityTap() => context.push(AppRoutes.create);

  Future<void> _onRefresh() async {
    final state = context.read<HomeCubit>().state;
    final profileState = context.read<ProfileCubit>().state;
    final cityId = state is HomeSuccess
        ? state.selectedCityId
        : profileState is ProfileLoaded
        ? profileState.profile.cityId
        : null;
    final preferences = profileState is ProfileLoaded
        ? profileState.profile.sportsInterests
        : _loadedCategoryPreferences;
    await context.read<HomeCubit>().loadHomeData(
      cityId: cityId,
      categoryPreferences: preferences,
    );
  }

  void _onCitySelected(String cityId, String cityName) {
    _loadedProfileCityId = cityId;
    final profileState = context.read<ProfileCubit>().state;
    final preferences = profileState is ProfileLoaded
        ? profileState.profile.sportsInterests
        : _loadedCategoryPreferences;
    context.read<HomeCubit>().updateSelectedCity(cityId, cityName, preferences);
    _exploreNavService.updateSelectedCity(cityId: cityId, cityName: cityName);
  }

  void _showCityPicker(
    BuildContext context,
    List<CityEntity> cities,
    String? selectedCityId,
  ) {
    CitySelectionBottomSheet.show(
      context: context,
      cities: cities,
      selectedCityId: selectedCityId,
      onCitySelected: (city) => _onCitySelected(city.id, city.name),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;

    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) =>
          current is ProfileLoaded || current is ProfileError,
      listener: (context, state) {
        if (state is ProfileLoaded) _loadHomeForProfile(state);
        if (state is ProfileError) _loadHomeWithoutProfile();
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: AppTheme.systemUiOverlayStyle(context),
        child: Scaffold(
          backgroundColor: context.backgroundColor,
          appBar: HomeAppBar(onNotificationTap: _onNotificationTap),
          body: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              final bool isLoading =
                  state is HomeLoading || state is HomeInitial;
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

              final userCityName = hasCitiesError
                  ? loc.homeCityLoadError
                  : cities
                            .where((c) => c.id == selectedCityId)
                            .map((c) => c.name)
                            .firstOrNull ??
                        loc.selectCity;

              return RefreshIndicator(
                onRefresh: _onRefresh,
                color: context.primaryColor,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    // --- PERMANENT STRUCTURE ---
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: Dimensions.r8.dynamicH),
                          BlocBuilder<ProfileCubit, ProfileState>(
                            builder: (context, profileState) {
                              final userName = profileState is ProfileLoaded
                                  ? profileState.profile.fullName
                                  : null;
                              return HomeGreetingBanner(
                                userName: userName,
                                city: userCityName,
                                onCityTap: (isLoading || hasCitiesError)
                                    ? () => _onRefresh()
                                    : () => _showCityPicker(
                                        context,
                                        cities,
                                        selectedCityId,
                                      ),
                              );
                            },
                          ),
                          SizedBox(height: Dimensions.r20.dynamicH),
                          if (hasCategoriesError)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.r16.dynamicW,
                              ),
                              child: TextButton(
                                onPressed: _onRefresh,
                                child: Text(loc.homeRetryCategories),
                              ),
                            )
                          else
                            PopularSportsGrid(
                              categories: categories,
                              onCategoryTap: _onCategoryTap,
                              onViewAll: _onViewAllTap,
                            ),
                          if (successState != null) ...[
                            SizedBox(height: Dimensions.r12.dynamicH),
                            HomeActivityHub(
                              state: successState,
                              onReviewRequests: (requestId) => context.push(
                                AppRoutes.manageRequestsPath(requestId),
                              ),
                              onViewActivity: (activity) =>
                                  _onSpotTap(activity, 'hub'),
                              onManageActivity: (activity) =>
                                  _onSpotTap(activity, 'hub'),
                              onOpenGroupChat: (activity) => context.push(
                                AppRoutes.activityGroupChatPath(
                                  activity.id,
                                  title: activity.title,
                                ),
                              ),
                              onCreateActivity: _onCreateActivityTap,
                              onRetry: _onRefresh,
                            ),
                          ],
                          SizedBox(height: Dimensions.r16.dynamicH),
                        ],
                      ),
                    ),

                    HomeActivityFeed(
                      state: state,
                      categories: categories,
                      onRetry: _onRefresh,
                      onViewAll: _onViewAllTap,
                      onCreateActivity: _onCreateActivityTap,
                      onActivityTap: _onSpotTap,
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(height: Dimensions.r32.dynamicH),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
