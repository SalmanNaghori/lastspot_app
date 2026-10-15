import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_home_activities_usecase.dart';
import '../../../categories/domain/usecases/get_categories_usecase.dart';
import '../../../auth/domain/usecases/update_user_city_usecase.dart';
import 'home_state.dart';
import '../../../../core/utils/result.dart';
import '../../../categories/domain/entities/category.dart';
import '../../../cities/domain/entities/city_entity.dart';
import '../../domain/entities/request_entity.dart';
import '../../../cities/domain/usecases/get_active_cities_usecase.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../domain/repositories/spot_repository.dart';
import '../../domain/entities/join_request_entity.dart';
import '../../domain/policies/spot_participation_policy.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetHomeActivitiesUseCase _getHomeActivitiesUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;
  final UpdateUserCityUseCase _updateUserCityUseCase;
  final GetActiveCitiesUseCase _getActiveCitiesUseCase;
  final SpotRepository _spotRepository;
  final AuthRepository _authRepository;

  HomeCubit({
    required GetHomeActivitiesUseCase getHomeActivitiesUseCase,
    required GetCategoriesUseCase getCategoriesUseCase,
    required UpdateUserCityUseCase updateUserCityUseCase,
    required GetActiveCitiesUseCase getActiveCitiesUseCase,
    required SpotRepository spotRepository,
    required AuthRepository authRepository,
  }) : _getHomeActivitiesUseCase = getHomeActivitiesUseCase,
       _getCategoriesUseCase = getCategoriesUseCase,
       _updateUserCityUseCase = updateUserCityUseCase,
       _getActiveCitiesUseCase = getActiveCitiesUseCase,
       _spotRepository = spotRepository,
       _authRepository = authRepository,
       super(HomeInitial());

  int _loadGeneration = 0;

  bool _isNetworkException(Exception e) {
    return e is SocketException ||
        e.toString().contains('SocketException') ||
        e.toString().contains('TimeoutException');
  }

  Future<void> loadHomeData({
    String? cityId,
    List<String> categoryPreferences = const [],
  }) async {
    if (isClosed) return;
    final generation = ++_loadGeneration;
    emit(HomeLoading());
    try {
      final categoriesFuture = _getCategoriesUseCase()
          .then<Result<List<CategoryEntity>, Exception>>((val) => Success(val))
          .catchError(
            (e) => Failure<List<CategoryEntity>, Exception>(
              e is Exception ? e : Exception(e.toString()),
            ),
          );

      final citiesFuture = _getActiveCitiesUseCase();

      final activitiesFuture = _getHomeActivitiesUseCase(cityId: cityId)
          .then<Result<List<RequestEntity>, Exception>>((val) => Success(val))
          .catchError(
            (e) => Failure<List<RequestEntity>, Exception>(
              e is Exception ? e : Exception(e.toString()),
            ),
          );

      final hubActivitiesFuture = _capture(_spotRepository.getUserActivities);
      final receivedRequestsFuture = _capture(
        _spotRepository.getReceivedJoinRequests,
      );
      final sentRequestsFuture = _capture(_spotRepository.getSentJoinRequests);

      final results = await Future.wait<dynamic>([
        categoriesFuture,
        citiesFuture,
        activitiesFuture,
        hubActivitiesFuture,
        receivedRequestsFuture,
        sentRequestsFuture,
      ]);

      if (isClosed || generation != _loadGeneration) return;

      final categoriesResult =
          results[0] as Result<List<CategoryEntity>, Exception>;
      final citiesResult = results[1] as Result<List<CityEntity>, Exception>;
      final activitiesResult =
          results[2] as Result<List<RequestEntity>, Exception>;
      final hubActivitiesResult =
          results[3] as Result<List<RequestEntity>, Exception>;
      final receivedRequestsResult =
          results[4] as Result<List<JoinRequestEntity>, Exception>;
      final sentRequestsResult =
          results[5] as Result<List<JoinRequestEntity>, Exception>;

      bool hasCategoriesError = false;
      List<CategoryEntity> categories = [];
      if (categoriesResult is Success<List<CategoryEntity>, Exception>) {
        categories = categoriesResult.value;
      } else {
        hasCategoriesError = true;
      }

      bool hasCitiesError = false;
      List<CityEntity> cities = [];
      if (citiesResult is Success<List<CityEntity>, Exception>) {
        cities = citiesResult.value;
      } else {
        hasCitiesError = true;
      }

      bool hasFeedError = false;
      bool isFeedNetworkError = false;
      List<RequestEntity> allActivities = [];

      if (activitiesResult is Success<List<RequestEntity>, Exception>) {
        allActivities = activitiesResult.value;
      } else if (activitiesResult is Failure<List<RequestEntity>, Exception>) {
        hasFeedError = true;
        if (_isNetworkException(activitiesResult.exception)) {
          isFeedNetworkError = true;
        }
      }

      final userId = _authRepository.getCurrentUserId();
      final userActivities =
          hubActivitiesResult is Success<List<RequestEntity>, Exception>
          ? hubActivitiesResult.value
          : <RequestEntity>[];
      final receivedRequests =
          receivedRequestsResult is Success<List<JoinRequestEntity>, Exception>
          ? receivedRequestsResult.value
          : <JoinRequestEntity>[];
      final sentRequests =
          sentRequestsResult is Success<List<JoinRequestEntity>, Exception>
          ? sentRequestsResult.value
          : <JoinRequestEntity>[];
      final hasActivityHubError =
          hubActivitiesResult is Failure<List<RequestEntity>, Exception> ||
          receivedRequestsResult
              is Failure<List<JoinRequestEntity>, Exception> ||
          sentRequestsResult is Failure<List<JoinRequestEntity>, Exception>;

      final now = DateTime.now().toUtc();
      final futureActivities =
          allActivities
              .where(
                (activity) =>
                    activity.eventDateTime.toUtc().isAfter(now) &&
                    (activity.status == RequestStatus.open ||
                        activity.status == RequestStatus.full),
              )
              .toList()
            ..sort(
              (a, b) =>
                  a.eventDateTime.toUtc().compareTo(b.eventDateTime.toUtc()),
            );
      final upcomingUserActivities =
          userActivities.where((activity) {
            return activity.eventDateTime.toUtc().isAfter(now) &&
                (activity.status == RequestStatus.open ||
                    activity.status == RequestStatus.full);
          }).toList()..sort(
            (a, b) =>
                a.eventDateTime.toUtc().compareTo(b.eventDateTime.toUtc()),
          );
      final hostedActivity = upcomingUserActivities
          .where((activity) => activity.userId == userId)
          .firstOrNull;
      final joinedActivity = upcomingUserActivities
          .where((activity) => activity.userId != userId)
          .firstOrNull;
      final pendingRequests =
          receivedRequests
              .where((request) => request.status == JoinRequestStatus.pending)
              .toList()
            ..sort(
              (a, b) => b.createdAt.toUtc().compareTo(a.createdAt.toUtc()),
            );
      final joinedRequest = joinedActivity == null
          ? null
          : sentRequests
                .where(
                  (request) =>
                      request.requestId == joinedActivity.id &&
                      request.status == JoinRequestStatus.accepted,
                )
                .firstOrNull;
      final preferredCategoryIds = categories
          .where(
            (category) => categoryPreferences.any((preference) {
              final normalized = preference.trim().toLowerCase();
              return normalized == category.id.toLowerCase() ||
                  normalized == category.name.trim().toLowerCase() ||
                  normalized == category.slug.trim().toLowerCase();
            }),
          )
          .map((category) => category.id)
          .toSet();
      final recommendation = cityId == null
          ? null
          : futureActivities
                .where((activity) => activity.cityId == cityId)
                .where(
                  (activity) =>
                      categoryPreferences.isEmpty ||
                      preferredCategoryIds.contains(activity.categoryId),
                )
                .firstOrNull;

      // We always emit HomeSuccess to preserve the Home UI structure,
      // relying on the individual error flags to show localized retry buttons.

      final in24Hours = now.add(const Duration(hours: 24));
      final inSevenDays = now.add(const Duration(days: 7));

      // Keep the feed sections limited to future activities.
      final urgent = futureActivities.where((a) {
        return a.eventDateTime.toUtc().isBefore(in24Hours) &&
            (a.maxParticipants - a.currentParticipants) > 0;
      }).toList();
      final urgentIds = urgent.map((e) => e.id).toSet();

      // Keep time-based home sections mutually exclusive. The feed can include
      // other cities when no city is selected, so it cannot promise proximity.
      final comingUp = futureActivities.where((activity) {
        return !urgentIds.contains(activity.id) &&
            activity.eventDateTime.toUtc().isBefore(inSevenDays);
      }).toList();
      final comingUpIds = comingUp.map((activity) => activity.id).toSet();
      final later = futureActivities.where((activity) {
        return !urgentIds.contains(activity.id) &&
            !comingUpIds.contains(activity.id);
      }).toList();

      emit(
        HomeSuccess(
          urgentMatches: urgent,
          laterActivities: later,
          comingUp: comingUp,
          categories: [...categories]
            ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder)),
          cities: [...cities]
            ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder)),
          selectedCityId: cityId,
          pendingJoinRequests: pendingRequests,
          upcomingJoinedActivity: joinedActivity,
          upcomingHostedActivity: hostedActivity,
          canOpenJoinedGroupChat: SpotParticipationPolicy.canAccessGroupChat(
            isHost: false,
            request: joinedRequest,
          ),
          recommendation: recommendation,
          unreadNotifications: 0,
          hasFeedError: hasFeedError,
          isFeedNetworkError: isFeedNetworkError,
          hasCitiesError: hasCitiesError,
          hasCategoriesError: hasCategoriesError,
          hasActivityHubError: hasActivityHubError,
        ),
      );
    } catch (e) {
      if (isClosed || generation != _loadGeneration) return;
      if (_isNetworkException(e is Exception ? e : Exception(e.toString()))) {
        emit(
          HomeNetworkError(
            message: 'No internet connection. Please try again.',
          ),
        );
      } else {
        emit(
          HomeServerError(message: 'Something went wrong. Please try again.'),
        );
      }
    }
  }

  Future<void> updateSelectedCity(
    String cityId,
    String cityName,
    List<String> categoryPreferences,
  ) async {
    if (isClosed) return;
    final currentState = state;
    if (currentState is HomeSuccess) {
      try {
        final userId = _authRepository.getCurrentUserId();
        if (userId == null) return;
        await _updateUserCityUseCase(
          userId: userId,
          cityId: cityId,
          cityName: cityName,
        );
        if (isClosed) return;
        await loadHomeData(
          cityId: cityId,
          categoryPreferences: categoryPreferences,
        );
      } catch (e) {
        // Fallback or log if user update fails, but home load will retry anyway if we called it
      }
    }
  }

  Future<Result<T, Exception>> _capture<T>(Future<T> Function() operation) {
    return operation()
        .then<Result<T, Exception>>((value) => Success(value))
        .catchError(
          (error) => Failure<T, Exception>(
            error is Exception ? error : Exception(error.toString()),
          ),
        );
  }
}
