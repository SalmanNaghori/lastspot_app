import 'package:equatable/equatable.dart';
import '../../../spot/domain/entities/request_entity.dart';

enum ExploreDateFilter { any, today, tomorrow, thisWeekend }
enum ExplorePriceFilter { any, free, paid }
enum ExploreParticipantsFilter { any, spots1to2, spots3to5, spots5plus }

abstract class ExploreState extends Equatable {
  const ExploreState();

  @override
  List<Object?> get props => [];
}

class ExploreInitial extends ExploreState {}

class ExploreLoading extends ExploreState {}

class ExploreLoaded extends ExploreState {
  final List<RequestEntity> posts;
  final String? searchQuery;
  final String? categoryId;
  final String? cityId;
  final ExploreDateFilter dateFilter;
  final ExplorePriceFilter priceFilter;
  final ExploreParticipantsFilter participantsFilter;
  final bool hasReachedMax;
  final bool isPaginating;

  const ExploreLoaded({
    required this.posts,
    this.searchQuery,
    this.categoryId,
    this.cityId,
    this.dateFilter = ExploreDateFilter.any,
    this.priceFilter = ExplorePriceFilter.any,
    this.participantsFilter = ExploreParticipantsFilter.any,
    this.hasReachedMax = false,
    this.isPaginating = false,
  });

  ExploreLoaded copyWith({
    List<RequestEntity>? posts,
    String? searchQuery,
    String? categoryId,
    String? cityId,
    ExploreDateFilter? dateFilter,
    ExplorePriceFilter? priceFilter,
    ExploreParticipantsFilter? participantsFilter,
    bool? hasReachedMax,
    bool? isPaginating,
  }) {
    return ExploreLoaded(
      posts: posts ?? this.posts,
      searchQuery: searchQuery != null && searchQuery.isEmpty ? null : (searchQuery ?? this.searchQuery),
      categoryId: categoryId != null && categoryId.isEmpty ? null : (categoryId ?? this.categoryId),
      cityId: cityId ?? this.cityId,
      dateFilter: dateFilter ?? this.dateFilter,
      priceFilter: priceFilter ?? this.priceFilter,
      participantsFilter: participantsFilter ?? this.participantsFilter,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isPaginating: isPaginating ?? this.isPaginating,
    );
  }

  ExploreLoaded clearCategory() {
    return ExploreLoaded(
      posts: posts,
      searchQuery: searchQuery,
      categoryId: null,
      cityId: cityId,
      dateFilter: dateFilter,
      priceFilter: priceFilter,
      participantsFilter: participantsFilter,
      hasReachedMax: hasReachedMax,
      isPaginating: isPaginating,
    );
  }

  ExploreLoaded clearSearch() {
    return ExploreLoaded(
      posts: posts,
      searchQuery: null,
      categoryId: categoryId,
      cityId: cityId,
      dateFilter: dateFilter,
      priceFilter: priceFilter,
      participantsFilter: participantsFilter,
      hasReachedMax: hasReachedMax,
      isPaginating: isPaginating,
    );
  }

  ExploreLoaded clearFilters() {
    return ExploreLoaded(
      posts: posts,
      searchQuery: searchQuery,
      categoryId: categoryId,
      cityId: cityId,
      dateFilter: ExploreDateFilter.any,
      priceFilter: ExplorePriceFilter.any,
      participantsFilter: ExploreParticipantsFilter.any,
      hasReachedMax: hasReachedMax,
      isPaginating: isPaginating,
    );
  }

  bool get hasActiveFilters => 
    dateFilter != ExploreDateFilter.any || 
    priceFilter != ExplorePriceFilter.any || 
    participantsFilter != ExploreParticipantsFilter.any;

  @override
  List<Object?> get props => [posts, searchQuery, categoryId, cityId, dateFilter, priceFilter, participantsFilter, hasReachedMax, isPaginating];
}

class ExploreError extends ExploreState {
  final String message;

  const ExploreError(this.message);

  @override
  List<Object?> get props => [message];
}
