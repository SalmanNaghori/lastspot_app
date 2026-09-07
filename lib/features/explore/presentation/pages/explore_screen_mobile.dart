import 'dart:async';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/features/spot/domain/entities/request_entity.dart';

import '../../../auth/presentation/bloc/profile_cubit.dart';
import '../../../categories/presentation/bloc/category_bloc.dart';
import '../../../categories/presentation/bloc/category_state.dart';

import '../../../spot/presentation/widgets/home_spot_card.dart';
import '../bloc/explore_bloc.dart';
import '../bloc/explore_event.dart';
import '../bloc/explore_state.dart';
import '../widgets/explore_filter_bar.dart';
import '../widgets/explore_filter_bottom_sheet.dart';

class ExploreScreenMobile extends StatefulWidget {
  const ExploreScreenMobile({super.key});

  @override
  State<ExploreScreenMobile> createState() => _ExploreScreenMobileState();
}

class _ExploreScreenMobileState extends State<ExploreScreenMobile> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _debounce;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Initial fetch triggers if we have profile
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileState = context.read<ProfileCubit>().state;
      if (profileState is ProfileLoaded) {
        final cityId = profileState.profile.cityId ?? '';
        context.read<ExploreBloc>().add(CitySelected(cityId));
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
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
    _searchFocusNode.unfocus();
  }

  void _onFilterTap(ExploreDateFilter dateF, ExplorePriceFilter priceF, ExploreParticipantsFilter partF) {
    AppBottomSheet.show(
      context: context,
      builder: (_) => ExploreFilterBottomSheet(
        initialDateFilter: dateF,
        initialPriceFilter: priceF,
        initialParticipantsFilter: partF,
        onApply: (date, price, participants) {
          context.read<ExploreBloc>().add(ApplyFilters(
            dateFilter: date,
            priceFilter: price,
            participantsFilter: participants,
          ));
        },
      ),
    );
  }

  void _onCategorySelected(String? id) {
    context.read<ExploreBloc>().add(CategorySelected(id));
  }

  void _onRetryTap() {
    context.read<ExploreBloc>().add(const LoadExplorePosts(refresh: true));
  }

  void _onSpotTap(String spotId) {
    context.push('${AppRoutes.spotDetails.replaceAll(':id', '')}$spotId');
  }

  List<RequestEntity> _getDisplayedPosts(ExploreLoaded state) {
    Iterable<RequestEntity> filtered = state.posts;

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
        final descMatch = post.description?.toLowerCase().contains(query) ?? false;
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
          return start.year == now.year && start.month == now.month && start.day == now.day;
        } else if (state.dateFilter == ExploreDateFilter.tomorrow) {
          final tmrw = now.add(const Duration(days: 1));
          return start.year == tmrw.year && start.month == tmrw.month && start.day == tmrw.day;
        } else if (state.dateFilter == ExploreDateFilter.thisWeekend) {
          final isWeekend = start.weekday >= DateTime.friday && start.weekday <= DateTime.sunday;
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
        } else if (state.participantsFilter == ExploreParticipantsFilter.spots3to5) {
          return total >= 3 && total <= 5;
        } else if (state.participantsFilter == ExploreParticipantsFilter.spots5plus) {
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
          final cityId = state.profile.cityId ?? '';
          final exploreState = context.read<ExploreBloc>().state;
          if (exploreState is ExploreLoaded && exploreState.cityId != cityId) {
            context.read<ExploreBloc>().add(CitySelected(cityId));
          } else if (exploreState is! ExploreLoaded) {
            context.read<ExploreBloc>().add(CitySelected(cityId));
          }
        }
      },
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        body: RefreshIndicator(
          color: AppColor.primaryColor,
          onRefresh: () async => _onRefresh(),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(offset: Offset(0, 20 * (1 - value)), child: child),
              );
            },
            child: AnimationLimiter(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // Animated App Bar
                  SliverAppBar(
                    pinned: true,
                    floating: false,
                    backgroundColor: context.backgroundColor,
                    surfaceTintColor: context.backgroundColor,
                    elevation: 0,
                    scrolledUnderElevation: 4,
                    expandedHeight: Dimensions.r60,
                    toolbarHeight: Dimensions.r60,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loc.navExplore,
                          style: TextStyle(
                            fontSize: Dimensions.r24.dynamicSP,
                            fontWeight: FontWeight.w800,
                            color: context.textPrimary,
                          ),
                        ),
                        Text(
                          loc.findActivitiesNearYou,
                          style: TextStyle(
                            fontSize: Dimensions.r14.dynamicSP,
                            color: context.textSecondary,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      IconButton(
                        onPressed: _onNotificationsTap,
                        icon: const Icon(Icons.notifications_outlined),
                      ),
                      SizedBox(width: Dimensions.r8.dynamicW),
                    ],
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(120.0),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.r16.dynamicW),
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
                                        suffixIcon: ValueListenableBuilder<TextEditingValue>(
                                          valueListenable: _searchController,
                                          builder: (context, value, child) {
                                            return value.text.isNotEmpty
                                                ? IconButton(
                                                    icon: const Icon(Icons.close),
                                                    onPressed: _onClearSearchTap,
                                                  )
                                                : const SizedBox.shrink();
                                          },
                                        ),
                                        filled: true,
                                        fillColor: context.surfaceColor,
                                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
                                          borderSide: BorderSide(color: context.borderColor),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
                                          borderSide: BorderSide(color: context.borderColor),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
                                          borderSide: BorderSide(color: AppColor.primaryColor),
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
                                    borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
                                    border: Border.all(color: context.borderColor),
                                  ),
                                  child: BlocBuilder<ExploreBloc, ExploreState>(
                                    builder: (context, state) {
                                      bool hasActiveFilters = false;
                                      ExploreDateFilter dateF = ExploreDateFilter.any;
                                      ExplorePriceFilter priceF = ExplorePriceFilter.any;
                                      ExploreParticipantsFilter partF = ExploreParticipantsFilter.any;

                                      if (state is ExploreLoaded) {
                                        hasActiveFilters = state.hasActiveFilters;
                                        dateF = state.dateFilter;
                                        priceF = state.priceFilter;
                                        partF = state.participantsFilter;
                                      }

                                      return Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          IconButton(
                                            onPressed: () => _onFilterTap(dateF, priceF, partF),
                                            icon: Icon(
                                              Icons.tune,
                                              color: hasActiveFilters ? AppColor.primaryColor : context.textSecondary,
                                            ),
                                          ),
                                          if (hasActiveFilters)
                                            Positioned(
                                              top: 12,
                                              right: 12,
                                              child: Container(
                                                width: 8,
                                                height: 8,
                                                decoration: const BoxDecoration(
                                                  color: AppColor.primaryColor,
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
                                String cityName = loc.selectYourCity;
                                if (state is ProfileLoaded) {
                                  cityName = state.profile.city ?? loc.selectYourCity;
                                }
                                return Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: AppColor.primaryColor,
                                      size: Dimensions.r18.dynamicH,
                                    ),
                                    SizedBox(width: Dimensions.r4.dynamicW),
                                    Text(
                                      cityName,
                                      style: TextStyle(
                                        fontSize: Dimensions.r14.dynamicSP,
                                        color: context.textSecondary,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            SizedBox(height: Dimensions.r16.dynamicH),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Sticky Categories Filter
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _SliverCategoryDelegate(
                      child: Container(
                        color: context.backgroundColor,
                        padding: EdgeInsets.symmetric(vertical: Dimensions.r8.dynamicH),
                        child: BlocBuilder<CategoryBloc, CategoryState>(
                          builder: (context, categoryState) {
                            if (categoryState is CategoryLoaded) {
                              final activeCategories = categoryState.categories.where((c) => c.isActive).toList()
                                ..sort((a, b) {
                                  int cmp = a.sortOrder.compareTo(b.sortOrder);
                                  if (cmp != 0) return cmp;
                                  return a.name.compareTo(b.name);
                                });
                              return BlocBuilder<ExploreBloc, ExploreState>(
                                builder: (context, exploreState) {
                                  String? selectedCategoryId;
                                  if (exploreState is ExploreLoaded) {
                                    selectedCategoryId = exploreState.categoryId;
                                  }
                                  return ExploreFilterBar(
                                    categories: activeCategories,
                                    selectedCategoryId: selectedCategoryId,
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
                            final displayedPosts = _getDisplayedPosts(state);
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
                                  style: TextStyle(fontSize: Dimensions.r13.dynamicSP, color: context.textSecondary),
                                ),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),

                  // Results List
                  BlocBuilder<ExploreBloc, ExploreState>(
                    builder: (context, state) {
                      if (state is ExploreLoading || state is ExploreInitial) {
                        final dummySpot = RequestEntity(
                          id: 'dummy',
                          userId: 'dummy',
                          categoryId: 'sports',
                          title: 'Loading Activity Title',
                          description:
                              'Loading Activity Description which is a bit long to cover two lines of text typically in this view.',
                          locationName: 'Loading Location',
                          latitude: 0,
                          longitude: 0,
                          eventDateTime: DateTime.now().add(const Duration(days: 1)),
                          maxParticipants: 10,
                          currentParticipants: 5,
                          pricePerPerson: 100,
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                        );

                        return SliverPadding(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.r16.dynamicW),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => Padding(
                                padding: EdgeInsets.only(bottom: Dimensions.r20.dynamicH),
                                child: Skeletonizer(
                                  enabled: true,
                                  child: Skeleton.ignorePointer(
                                    child: IgnorePointer(
                                      ignoring: true,
                                      child: HomeSpotCard(spot: dummySpot, onTap: () {}),
                                    ),
                                  ),
                                ),
                              ),
                              childCount: 5,
                            ),
                          ),
                        );
                      }

                      if (state is ExploreError) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error_outline, size: Dimensions.r48.dynamicH, color: context.textSecondary),
                                SizedBox(height: Dimensions.r16.dynamicH),
                                Text(
                                  loc.couldNotLoadActivities,
                                  style: TextStyle(fontSize: Dimensions.r16.dynamicSP, fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: Dimensions.r8.dynamicH),
                                Text(
                                  loc.checkConnectionRetry,
                                  style: TextStyle(fontSize: Dimensions.r14.dynamicSP, color: context.textSecondary),
                                ),
                                SizedBox(height: Dimensions.r16.dynamicH),
                                ElevatedButton(
                                  onPressed: _onRetryTap,
                                  child: Text(loc.retry),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (state is ExploreLoaded) {
                        final displayedPosts = _getDisplayedPosts(state);

                        if (displayedPosts.isEmpty) {
                          String emptyMessage = loc.noActivitiesFound;
                          String emptySubMessage = loc.noActivitiesInArea;

                          if (state.searchQuery != null && state.searchQuery!.isNotEmpty) {
                            emptyMessage = "No activities match your search";
                            emptySubMessage = loc.tryDifferentKeyword;
                          } else if (state.categoryId != null) {
                            emptyMessage = loc.noActivitiesInCategory;
                            emptySubMessage = loc.tryDifferentCategory;
                          }

                          return SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search_off, size: Dimensions.r48.dynamicH, color: context.textSecondary),
                                  SizedBox(height: Dimensions.r16.dynamicH),
                                  Text(
                                    emptyMessage,
                                    style: TextStyle(fontSize: Dimensions.r16.dynamicSP, fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(height: Dimensions.r8.dynamicH),
                                  Text(
                                    emptySubMessage,
                                    style: TextStyle(fontSize: Dimensions.r14.dynamicSP, color: context.textSecondary),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return SliverPadding(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.r16.dynamicW),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                if (index >= displayedPosts.length) {
                                  return Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: Dimensions.r16.dynamicH),
                                      child: const CircularProgressIndicator(),
                                    ),
                                  );
                                }
                                final spot = displayedPosts[index];
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 300),
                                  child: SlideAnimation(
                                    verticalOffset: 30.0,
                                    child: FadeInAnimation(
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: Dimensions.r16.dynamicH),
                                        child: HomeSpotCard(
                                          spot: spot,
                                          onTap: () => _onSpotTap(spot.id),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              childCount:
                                  (state.hasReachedMax || (state.searchQuery != null && state.searchQuery!.isNotEmpty))
                                  ? displayedPosts.length
                                  : displayedPosts.length + 1,
                            ),
                          ),
                        );
                      }

                      return const SliverToBoxAdapter(child: SizedBox.shrink());
                    },
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: Dimensions.r32.dynamicH)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverCategoryDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverCategoryDelegate({required this.child});

  @override
  double get minExtent => 60.0;
  @override
  double get maxExtent => 60.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverCategoryDelegate oldDelegate) {
    return true;
  }
}
