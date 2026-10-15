import 'package:equatable/equatable.dart';
import '../../domain/entities/request_entity.dart';
import '../../../categories/domain/entities/category.dart';
import '../../../cities/domain/entities/city_entity.dart';
import '../../domain/entities/join_request_entity.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<RequestEntity> urgentMatches;
  final List<RequestEntity> laterActivities;
  final List<RequestEntity> comingUp;
  final List<CategoryEntity> categories;
  final List<CityEntity> cities;
  final String? selectedCityId;
  final int unreadNotifications;
  final List<JoinRequestEntity> pendingJoinRequests;
  final RequestEntity? upcomingJoinedActivity;
  final RequestEntity? upcomingHostedActivity;
  final bool canOpenJoinedGroupChat;
  final RequestEntity? recommendation;

  // Error flags for partial success
  final bool hasFeedError;
  final bool isFeedNetworkError;
  final bool hasCitiesError;
  final bool hasCategoriesError;
  final bool hasActivityHubError;

  HomeSuccess({
    required this.urgentMatches,
    required this.laterActivities,
    required this.comingUp,
    required this.categories,
    required this.cities,
    this.selectedCityId,
    this.unreadNotifications = 0,
    this.pendingJoinRequests = const [],
    this.upcomingJoinedActivity,
    this.upcomingHostedActivity,
    this.canOpenJoinedGroupChat = false,
    this.recommendation,
    this.hasFeedError = false,
    this.isFeedNetworkError = false,
    this.hasCitiesError = false,
    this.hasCategoriesError = false,
    this.hasActivityHubError = false,
  });

  bool get isEmpty =>
      urgentMatches.isEmpty && laterActivities.isEmpty && comingUp.isEmpty;
  bool get isPartialSuccess =>
      hasFeedError || hasCitiesError || hasCategoriesError;

  @override
  List<Object?> get props => [
    urgentMatches,
    laterActivities,
    comingUp,
    categories,
    cities,
    selectedCityId,
    unreadNotifications,
    pendingJoinRequests,
    upcomingJoinedActivity,
    upcomingHostedActivity,
    canOpenJoinedGroupChat,
    recommendation,
    hasFeedError,
    isFeedNetworkError,
    hasCitiesError,
    hasCategoriesError,
    hasActivityHubError,
  ];

  HomeSuccess copyWith({
    List<RequestEntity>? urgentMatches,
    List<RequestEntity>? laterActivities,
    List<RequestEntity>? comingUp,
    List<CategoryEntity>? categories,
    List<CityEntity>? cities,
    String? selectedCityId,
    int? unreadNotifications,
    List<JoinRequestEntity>? pendingJoinRequests,
    RequestEntity? upcomingJoinedActivity,
    RequestEntity? upcomingHostedActivity,
    bool? canOpenJoinedGroupChat,
    RequestEntity? recommendation,
    bool? hasFeedError,
    bool? isFeedNetworkError,
    bool? hasCitiesError,
    bool? hasCategoriesError,
    bool? hasActivityHubError,
  }) {
    return HomeSuccess(
      urgentMatches: urgentMatches ?? this.urgentMatches,
      laterActivities: laterActivities ?? this.laterActivities,
      comingUp: comingUp ?? this.comingUp,
      categories: categories ?? this.categories,
      cities: cities ?? this.cities,
      selectedCityId: selectedCityId ?? this.selectedCityId,
      unreadNotifications: unreadNotifications ?? this.unreadNotifications,
      pendingJoinRequests: pendingJoinRequests ?? this.pendingJoinRequests,
      upcomingJoinedActivity:
          upcomingJoinedActivity ?? this.upcomingJoinedActivity,
      upcomingHostedActivity:
          upcomingHostedActivity ?? this.upcomingHostedActivity,
      canOpenJoinedGroupChat:
          canOpenJoinedGroupChat ?? this.canOpenJoinedGroupChat,
      recommendation: recommendation ?? this.recommendation,
      hasFeedError: hasFeedError ?? this.hasFeedError,
      isFeedNetworkError: isFeedNetworkError ?? this.isFeedNetworkError,
      hasCitiesError: hasCitiesError ?? this.hasCitiesError,
      hasCategoriesError: hasCategoriesError ?? this.hasCategoriesError,
      hasActivityHubError: hasActivityHubError ?? this.hasActivityHubError,
    );
  }
}

// Complete failure of the screen (e.g. initial load failed completely due to network)
class HomeNetworkError extends HomeState {
  final String message;
  HomeNetworkError({required this.message});
  @override
  List<Object?> get props => [message];
}

class HomeServerError extends HomeState {
  final String message;
  HomeServerError({required this.message});
  @override
  List<Object?> get props => [message];
}
