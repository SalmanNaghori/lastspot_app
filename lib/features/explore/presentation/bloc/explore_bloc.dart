import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../spot/domain/repositories/spot_repository.dart';
import 'explore_event.dart';
import 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final SpotRepository _spotRepository;
  static const int _limit = 20;

  ExploreBloc({required SpotRepository spotRepository})
      : _spotRepository = spotRepository,
        super(ExploreInitial()) {
    on<LoadExplorePosts>(_onLoadExplorePosts);
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<CategorySelected>(_onCategorySelected);
    on<CitySelected>(_onCitySelected);
    on<ApplyFilters>(_onApplyFilters);
    on<ClearFilters>(_onClearFilters);
  }

  Future<void> _onLoadExplorePosts(
    LoadExplorePosts event,
    Emitter<ExploreState> emit,
  ) async {
    final currentState = state;
    String? currentCityId;
    String? currentSearch;
    String? currentCategory;
    int offset = 0;
    
    if (currentState is ExploreLoaded) {
      currentCityId = currentState.cityId;
      currentSearch = currentState.searchQuery;
      currentCategory = currentState.categoryId;
      
      if (event.refresh) {
        offset = 0;
      } else {
        if (currentState.hasReachedMax) return;
        if (currentState.isPaginating) return;
        offset = currentState.posts.length;
        emit(currentState.copyWith(isPaginating: true));
      }
    } else {
      emit(ExploreLoading());
    }

    if (currentCityId == null && currentState is ExploreLoaded) {
      // Need city to fetch. Return if no city is available.
      return; 
    }

    try {
      final posts = await _spotRepository.getExplorePosts(
        cityId: currentCityId ?? '', // Will fail safely or load empty if cityId is empty initially
        categoryId: currentCategory,
        searchQuery: currentSearch,
        limit: _limit,
        offset: offset,
      );

      final hasReachedMax = posts.length < _limit;

      if (currentState is ExploreLoaded && !event.refresh) {
        emit(currentState.copyWith(
          posts: List.of(currentState.posts)..addAll(posts),
          hasReachedMax: hasReachedMax,
          isPaginating: false,
        ));
      } else {
        emit(ExploreLoaded(
          posts: posts,
          searchQuery: currentSearch,
          categoryId: currentCategory,
          cityId: currentCityId,
          hasReachedMax: hasReachedMax,
          isPaginating: false,
        ));
      }
    } catch (e) {
      if (currentState is ExploreLoaded) {
        emit(currentState.copyWith(isPaginating: false));
        // You might want to show a toast instead of replacing the list on pagination error
      } else {
        emit(ExploreError(e.toString()));
      }
    }
  }

  void _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<ExploreState> emit,
  ) {
    if (state is ExploreLoaded) {
      final currentState = state as ExploreLoaded;
      if (event.query.trim().isEmpty) {
        emit(currentState.clearSearch());
      } else {
        emit(currentState.copyWith(searchQuery: event.query));
      }
      // Removed network request here to support local filtering per requirements
    }
  }

  void _onCategorySelected(
    CategorySelected event,
    Emitter<ExploreState> emit,
  ) {
    if (state is ExploreLoaded) {
      final currentState = state as ExploreLoaded;
      if (event.categoryId == null || event.categoryId!.isEmpty) {
        emit(currentState.clearCategory());
      } else {
        emit(currentState.copyWith(categoryId: event.categoryId));
      }
      // Removed network request here to support local filtering per requirements
    }
  }

  void _onCitySelected(
    CitySelected event,
    Emitter<ExploreState> emit,
  ) {
    if (state is ExploreLoaded) {
      emit((state as ExploreLoaded).copyWith(cityId: event.cityId));
    } else {
      emit(ExploreLoaded(posts: const [], cityId: event.cityId));
    }
    add(const LoadExplorePosts(refresh: true));
  }

  void _onApplyFilters(
    ApplyFilters event,
    Emitter<ExploreState> emit,
  ) {
    if (state is ExploreLoaded) {
      emit((state as ExploreLoaded).copyWith(
        dateFilter: event.dateFilter,
        priceFilter: event.priceFilter,
        participantsFilter: event.participantsFilter,
      ));
    }
  }

  void _onClearFilters(
    ClearFilters event,
    Emitter<ExploreState> emit,
  ) {
    if (state is ExploreLoaded) {
      emit((state as ExploreLoaded).clearFilters());
    }
  }
}
