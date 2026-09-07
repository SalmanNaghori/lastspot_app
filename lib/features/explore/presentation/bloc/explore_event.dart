import 'package:equatable/equatable.dart';
import 'explore_state.dart';

abstract class ExploreEvent extends Equatable {
  const ExploreEvent();

  @override
  List<Object?> get props => [];
}

class LoadExplorePosts extends ExploreEvent {
  final bool refresh;

  const LoadExplorePosts({this.refresh = false});

  @override
  List<Object?> get props => [refresh];
}

class SearchQueryChanged extends ExploreEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class CategorySelected extends ExploreEvent {
  final String? categoryId;

  const CategorySelected(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class CitySelected extends ExploreEvent {
  final String cityId;

  const CitySelected(this.cityId);

  @override
  List<Object?> get props => [cityId];
}

class ApplyFilters extends ExploreEvent {
  final ExploreDateFilter dateFilter;
  final ExplorePriceFilter priceFilter;
  final ExploreParticipantsFilter participantsFilter;

  const ApplyFilters({
    required this.dateFilter,
    required this.priceFilter,
    required this.participantsFilter,
  });

  @override
  List<Object?> get props => [dateFilter, priceFilter, participantsFilter];
}

class ClearFilters extends ExploreEvent {}
