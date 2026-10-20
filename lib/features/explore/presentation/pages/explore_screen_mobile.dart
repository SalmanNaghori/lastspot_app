import 'dart:async';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/features/spot/domain/entities/request_entity.dart';
import '../../../../core/services/explore_navigation_service.dart';
import '../../../cities/domain/entities/city_entity.dart';
import '../../../cities/domain/usecases/get_active_cities_usecase.dart';
import '../../../cities/presentation/widgets/city_selection_bottom_sheet.dart';
import '../../../auth/domain/usecases/update_user_city_usecase.dart';
import '../../../auth/domain/repositories/auth_repository.dart';

import '../../../auth/presentation/bloc/profile_cubit.dart';
import '../../../categories/presentation/bloc/category_bloc.dart';
import '../../../categories/presentation/bloc/category_state.dart';

import '../bloc/explore_bloc.dart';
import '../bloc/explore_event.dart';
import '../../../../core/widgets/sports_category_perspective_carousel.dart';
import '../bloc/explore_state.dart';
import '../widgets/explore_filter_bottom_sheet.dart';

class ExploreScreenMobile extends StatefulWidget {
  final String? initialCategoryId;

  const ExploreScreenMobile({super.key, this.initialCategoryId});

  @override
  State<ExploreScreenMobile> createState() => _ExploreScreenMobileState();
}

class _ExploreScreenMobileState extends State<ExploreScreenMobile> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _debounce;
  final ScrollController _scrollController = ScrollController();
  late final ExploreNavigationService _exploreNavService;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _exploreNavService = sl<ExploreNavigationService>();
    _exploreNavService.addListener(_onExploreNavChanged);

    // Initial fetch triggers if we have profile or pending navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _checkPendingCategoryNavigation();
      _checkPendingCityChange();
      final profileState = context.read<ProfileCubit>().state;
      if (profileState is ProfileLoaded) {
        _onProfileLoaded(profileState);
      }
    });
  }

  void _onExploreNavChanged() {
    if (!mounted) return;
    _checkPendingCategoryNavigation();
    _checkPendingCityChange();
  }

  void _checkPendingCategoryNavigation() {
    if (_exploreNavService.hasPendingNavigation) {
      final pendingCat = _exploreNavService.pendingCategoryId;
      _exploreNavService.consumePendingNavigation();
      if (pendingCat == ExploreNavigationService.kSelectAll) {
        context.read<ExploreBloc>().add(const CategorySelected(null));
      } else if (pendingCat != null) {
        context.read<ExploreBloc>().add(CategorySelected(pendingCat));
      }
    }
  }

  void _checkPendingCityChange() {
    final newCityId = _exploreNavService.selectedCityId;
    if (newCityId != null && newCityId.isNotEmpty) {
      final exploreState = context.read<ExploreBloc>().state;
      if (exploreState is! ExploreLoaded || exploreState.cityId != newCityId) {
        context.read<ExploreBloc>().add(CitySelected(newCityId));
      }
    }
  }

  @override
  void didUpdateWidget(ExploreScreenMobile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialCategoryId != oldWidget.initialCategoryId) {
      context.read<ExploreBloc>().add(
        CategorySelected(widget.initialCategoryId),
      );
    }
  }

  void _onProfileLoaded(ProfileLoaded profileState) {
    final cityId =
        _exploreNavService.selectedCityId ?? profileState.profile.cityId ?? '';
    final exploreState = context.read<ExploreBloc>().state;
    if (exploreState is! ExploreLoaded || exploreState.cityId != cityId) {
      context.read<ExploreBloc>().add(CitySelected(cityId));
    }
    _checkPendingCategoryNavigation();
  }

  @override
  void dispose() {
    _exploreNavService.removeListener(_onExploreNavChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ExploreBloc>().add(const LoadExplorePosts());
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<ExploreBloc>().add(SearchQueryChanged(query));
    });
  }

  void _onRefresh() {
    context.read<ExploreBloc>().add(const LoadExplorePosts(refresh: true));
  }

  void _onNotificationsTap() {
    context.push(AppRoutes.notifications);
  }

  void _onClearSearchTap() {
    _searchController.clear();
    _onSearchChanged('');
  }

  void _onFilterTap(
    ExploreDateFilter dateF,
    ExplorePriceFilter priceF,
    ExploreParticipantsFilter partF,
  ) {
    AppBottomSheet.show(
      context: context,
      builder: (_) => ExploreFilterBottomSheet(
        initialDateFilter: dateF,
        initialPriceFilter: priceF,
        initialParticipantsFilter: partF,
        onApply: (date, price, participants) {
          context.read<ExploreBloc>().add(
            ApplyFilters(
              dateFilter: date,
              priceFilter: price,
              participantsFilter: participants,
            ),
          );
        },
      ),
    );
  }

  void _onCategorySelected(String? id) {
    context.read<ExploreBloc>().add(CategorySelected(id));
  }

  Future<void> _onExploreCityHeaderTap() async {
    final result = await sl<GetActiveCitiesUseCase>()();
    if (!mounted) return;
    if (result is Success<List<CityEntity>, Exception>) {
      final cities = result.value;
      final exploreState = context.read<ExploreBloc>().state;
      final currentCityId = exploreState is ExploreLoaded
          ? exploreState.cityId
          : null;

      if (!mounted) return;
      CitySelectionBottomSheet.show(
        context: context,
        cities: cities,
        selectedCityId: currentCityId,
        onCitySelected: (city) {
          context.read<ExploreBloc>().add(CitySelected(city.id));
          _exploreNavService.updateSelectedCity(
            cityId: city.id,
            cityName: city.name,
          );
          final userId = sl<AuthRepository>().getCurrentUserId();
          if (userId != null) {
            sl<UpdateUserCityUseCase>()(
              userId: userId,
              cityId: city.id,
              cityName: city.name,
            );
            context.read<ProfileCubit>().fetchProfile(userId);
          }
        },
      );
    }
  }

  void _onRetryTap() {
    context.read<ExploreBloc>().add(const LoadExplorePosts(refresh: true));
  }

  void _onSpotTap(RequestEntity spot) {
    final extra = {
      'heroTag': 'explore_activity_image_${spot.id}',
      'spot': spot,
    };
    context.push(AppRoutes.spotDetailsPath(spot.id), extra: extra);
  }

  List<RequestEntity> _getDisplayedRequests(ExploreLoaded state) {
    Iterable<RequestEntity> filtered = state.requests;

    // Local Category Filtering
    if (state.categoryId != null && state.categoryId!.isNotEmpty) {
      filtered = filtered.where((post) => post.categoryId == state.categoryId);
    }

    // Local Search Filtering
    if (state.searchQuery != null && state.searchQuery!.trim().isNotEmpty) {
      final query = state.searchQuery!.trim().toLowerCase();

      final categoryState = context.read<CategoryBloc>().state;
      List<dynamic> categories = [];
      if (categoryState is CategoryLoaded) {
        categories = categoryState.categories;
      }

      filtered = filtered.where((post) {
        final titleMatch = post.title.toLowerCase().contains(query);
        final descMatch =
            post.description?.toLowerCase().contains(query) ?? false;
        final locMatch = post.locationName.toLowerCase().contains(query);

        bool catMatch = false;
        for (var cat in categories) {
          if (cat.id == post.categoryId) {
            catMatch = cat.name.toLowerCase().contains(query);
            break;
          }
        }

        return titleMatch || descMatch || locMatch || catMatch;
      });
    }

    // Local Date Filtering
    if (state.dateFilter != ExploreDateFilter.any) {
      final now = DateTime.now();
      filtered = filtered.where((post) {
        final start = post.eventDateTime;
        if (state.dateFilter == ExploreDateFilter.today) {
          return start.year == now.year &&
              start.month == now.month &&
              start.day == now.day;
        } else if (state.dateFilter == ExploreDateFilter.tomorrow) {
          final tmrw = now.add(const Duration(days: 1));
          return start.year == tmrw.year &&
              start.month == tmrw.month &&
              start.day == tmrw.day;
        } else if (state.dateFilter == ExploreDateFilter.thisWeekend) {
          final isWeekend =
              start.weekday >= DateTime.friday &&
              start.weekday <= DateTime.sunday;
          final diff = start.difference(now).inDays;
          return isWeekend && diff >= 0 && diff <= 7;
        }
        return true;
      });
    }

    // Local Price Filtering
    if (state.priceFilter != ExplorePriceFilter.any) {
      filtered = filtered.where((post) {
        if (state.priceFilter == ExplorePriceFilter.free) {
          return post.pricePerPerson == 0;
        } else if (state.priceFilter == ExplorePriceFilter.paid) {
          return post.pricePerPerson > 0;
        }
        return true;
      });
    }

    // Local Participants Filtering
    if (state.participantsFilter != ExploreParticipantsFilter.any) {
      filtered = filtered.where((post) {
        final total = post.maxParticipants;
        if (state.participantsFilter == ExploreParticipantsFilter.spots1to2) {
          return total >= 1 && total <= 2;
        } else if (state.participantsFilter ==
            ExploreParticipantsFilter.spots3to5) {
          return total >= 3 && total <= 5;
        } else if (state.participantsFilter ==
            ExploreParticipantsFilter.spots5plus) {
          return total > 5;
        }
        return true;
      });
    }

    return filtered.toList();
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;

    // Watch ProfileCubit for city changes
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded) {
          _onProfileLoaded(state);
        }
      },
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        body: RefreshIndicator(
          color: context.primaryColor,
          onRefresh: () async => _onRefresh(),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: AnimationLimiter(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // Animated App Bar
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    pinned: true,
                    floating: false,
                    backgroundColor: context.backgroundColor,
                    surfaceTintColor: Colors.transparent,
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    systemOverlayStyle: AppTheme.systemUiOverlayStyle(context),
                    centerTitle: false,
                    titleSpacing: Dimensions.r16.dynamicW,
                    toolbarHeight: kToolbarHeight,
                    title: const KhelBhaiLogo(),
                    actions: [
                      const UserProfileAvatar(),
                      Padding(
                        padding: EdgeInsets.only(right: Dimensions.r8.dynamicW),
                        child: NotificationActionButton(
                          onPressed: _onNotificationsTap,
                        ),
                      ),
                    ],
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(120.0),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.r16.dynamicW,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: Dimensions.r12.dynamicH),
                            // Search Bar
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 48,
                                    child: TextField(
                                      controller: _searchController,
                                      focusNode: _searchFocusNode,
                                      onChanged: _onSearchChanged,
                                      decoration: InputDecoration(
                                        hintText: loc.searchActivitiesHint,
                                        prefixIcon: const Icon(Icons.search),
                                        suffixIcon:
                                            ValueListenableBuilder<
                                              TextEditingValue
                                            >(
                                              valueListenable:
                                                  _searchController,
                                              builder: (context, value, child) {
                                                return value.text.isNotEmpty
                                                    ? IconButton(
                                                        icon: const Icon(
                                                          Icons.close,
                                                        ),
                                                        onPressed:
                                                            _onClearSearchTap,
                                                      )
                                                    : const SizedBox.shrink();
                                              },
                                            ),
                                        filled: true,
                                        fillColor: context.surfaceColor,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              vertical: 0,
                                              horizontal: 16,
                                            ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            Dimensions.r12.dynamicR,
                                          ),
                                          borderSide: BorderSide(
                                            color: context.borderColor,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            Dimensions.r12.dynamicR,
                                          ),
                                          borderSide: BorderSide(
                                            color: context.borderColor,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            Dimensions.r12.dynamicR,
                                          ),
                                          borderSide: BorderSide(
                                            color: context.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: Dimensions.r12.dynamicW),
                                Container(
                                  height: 48,
                                  width: 48,
                                  decoration: BoxDecoration(
                                    color: context.surfaceColor,
                                    borderRadius: BorderRadius.circular(
                                      Dimensions.r12.dynamicR,
                                    ),
                                    border: Border.all(
                                      color: context.borderColor,
                                    ),
                                  ),
                                  child: BlocBuilder<ExploreBloc, ExploreState>(
                                    builder: (context, state) {
                                      bool hasActiveFilters = false;
                                      ExploreDateFilter dateF =
                                          ExploreDateFilter.any;
                                      ExplorePriceFilter priceF =
                                          ExplorePriceFilter.any;
                                      ExploreParticipantsFilter partF =
                                          ExploreParticipantsFilter.any;

                                      if (state is ExploreLoaded) {
                                        hasActiveFilters =
                                            state.hasActiveFilters;
                                        dateF = state.dateFilter;
                                        priceF = state.priceFilter;
                                        partF = state.participantsFilter;
                                      }

                                      return Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          IconButton(
                                            onPressed: () => _onFilterTap(
                                              dateF,
                                              priceF,
                                              partF,
                                            ),
                                            icon: Icon(
                                              Icons.tune,
                                              color: hasActiveFilters
                                                  ? context.primaryColor
                                                  : context.textSecondary,
                                            ),
                                          ),
                                          if (hasActiveFilters)
                                            Positioned(
                                              top: 12,
                                              right: 12,
                                              child: Container(
                                                width: 8,
                                                height: 8,
                                                decoration: BoxDecoration(
                                                  color: context.primaryColor,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: Dimensions.r16.dynamicH),
                            // City Header
                            BlocBuilder<ProfileCubit, ProfileState>(
                              builder: (context, state) {
                                String cityName =
                                    _exploreNavService.selectedCityName ??
                                    loc.selectYourCity;
                                if (state is ProfileLoaded &&
                                    state.profile.city != null &&
                                    _exploreNavService.selectedCityName ==
                                        null) {
                                  cityName = state.profile.city!;
                                }
                                return Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: _onExploreCityHeaderTap,
                                    borderRadius: BorderRadius.circular(
                                      Dimensions.r8.dynamicR,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: Dimensions.r4.dynamicH,
                                        horizontal: Dimensions.r2.dynamicW,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ActivityMetadataIcon.location(
                                            width: Dimensions.r18.dynamicW,
                                            height: Dimensions.r18.dynamicH,
                                          ),
                                          SizedBox(
                                            width: Dimensions.r6.dynamicW,
                                          ),
                                          Text(
                                            cityName,
                                            style: TextStyle(
                                              fontSize:
                                                  Dimensions.r14.dynamicSP,
                                              color: context.textPrimary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(
                                            width: Dimensions.r4.dynamicW,
                                          ),
                                          Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            size: Dimensions.r18.dynamicH,
                                            color: context.textSecondary,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: Dimensions.r16.dynamicH),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 3D Perspective Sports Category Carousel
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Dimensions.r6.dynamicH,
                      ),
                      child: BlocBuilder<CategoryBloc, CategoryState>(
                        builder: (context, categoryState) {
                          if (categoryState is CategoryLoaded) {
                            final activeCategories =
                                categoryState.categories
                                    .where((c) => c.isActive)
                                    .toList()
                                  ..sort((a, b) {
                                    int cmp = a.sortOrder.compareTo(
                                      b.sortOrder,
                                    );
                                    if (cmp != 0) return cmp;
                                    return a.name.compareTo(b.name);
                                  });
                            return BlocBuilder<ExploreBloc, ExploreState>(
                              builder: (context, exploreState) {
                                String? selectedCategoryId;
                                if (exploreState is ExploreLoaded) {
                                  selectedCategoryId = exploreState.categoryId;
                                }
                                return SportsCategoryPerspectiveCarousel(
                                  key: const ValueKey(
                                    'explore_sports_perspective_carousel',
                                  ),
                                  categories: activeCategories,
                                  selectedCategoryId: selectedCategoryId,
                                  includeAllOption: true,
                                  mode: SportsCarouselMode.explore,
                                  onCategorySelected: _onCategorySelected,
                                );
                              },
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),

                  // Results Count Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        Dimensions.r16.dynamicW,
                        Dimensions.r16.dynamicH,
                        Dimensions.r16.dynamicW,
                        Dimensions.r12.dynamicH,
                      ),
                      child: BlocBuilder<ExploreBloc, ExploreState>(
                        builder: (context, state) {
                          if (state is ExploreLoaded) {
                            final displayedPosts = _getDisplayedRequests(state);
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  loc.activitiesNearYou,
                                  style: TextStyle(
                                    fontSize: Dimensions.r16.dynamicSP,
                                    fontWeight: FontWeight.w700,
                                    color: context.textPrimary,
                                  ),
                                ),
                                Text(
                                  loc.activitiesCount(displayedPosts.length),
                                  style: TextStyle(
                                    fontSize: Dimensions.r13.dynamicSP,
                                    color: context.textSecondary,
                                  ),
                                ),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),

                  // Results List (Vertical Scrollable Cards)
                  BlocBuilder<ExploreBloc, ExploreState>(
                    builder: (context, state) {
                      if (state is ExploreLoading || state is ExploreInitial) {
                        return SliverPadding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.r16.dynamicW,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => Padding(
                                padding: EdgeInsets.only(
                                  bottom: Dimensions.r16.dynamicH,
                                ),
                                child: const AppShimmerCardItem(),
                              ),
                              childCount: 4,
                            ),
                          ),
                        );
                      }

                      if (state is ExploreError) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: AppErrorState(
                              message: loc.couldNotLoadActivities,
                              onRetry: _onRetryTap,
                            ),
                          ),
                        );
                      }

                      if (state is ExploreLoaded) {
                        final displayedPosts = _getDisplayedRequests(state);

                        if (displayedPosts.isEmpty) {
                          final isSearch =
                              state.searchQuery != null &&
                              state.searchQuery!.isNotEmpty;
                          final emptyTitle = isSearch
                              ? loc.noActivitiesMatchSearch
                              : (state.categoryId != null
                                    ? loc.noActivitiesInCategory
                                    : loc.noActivitiesFound);
                          final emptyMessage = isSearch
                              ? loc.tryDifferentKeyword
                              : (state.categoryId != null
                                    ? loc.tryDifferentCategory
                                    : loc.noActivitiesInArea);

                          return SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: isSearch
                                  ? AppEmptyState.search(
                                      title: emptyTitle,
                                      message: emptyMessage,
                                    )
                                  : AppEmptyState.activities(
                                      title: emptyTitle,
                                      message: emptyMessage,
                                    ),
                            ),
                          );
                        }

                        return SliverPadding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.r16.dynamicW,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                if (index >= displayedPosts.length) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: Dimensions.r16.dynamicH,
                                    ),
                                    child: const Center(
                                      child: AppLoading(size: 24),
                                    ),
                                  );
                                }
                                final spot = displayedPosts[index];
                                final categoryState = context
                                    .read<CategoryBloc>()
                                    .state;
                                final category = categoryState is CategoryLoaded
                                    ? categoryState.categories
                                          .where((c) => c.id == spot.categoryId)
                                          .firstOrNull
                                    : null;
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 300),
                                  child: SlideAnimation(
                                    verticalOffset: 30.0,
                                    child: FadeInAnimation(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          bottom: Dimensions.r16.dynamicH,
                                        ),
                                        child: ActivityCard(
                                          spot: spot,
                                          categoryName:
                                              category?.name ?? 'Sport',
                                          categoryIcon: category?.icon ?? '🎯',
                                          heroTagPrefix: 'explore',
                                          onTap: () => _onSpotTap(spot),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              childCount:
                                  (state.hasReachedMax ||
                                      (state.searchQuery != null &&
                                          state.searchQuery!.isNotEmpty))
                                  ? displayedPosts.length
                                  : displayedPosts.length + 1,
                            ),
                          ),
                        );
                      }

                      return const SliverToBoxAdapter(child: SizedBox.shrink());
                    },
                  ),

                  SliverToBoxAdapter(
                    child: SizedBox(height: Dimensions.r32.dynamicH),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
