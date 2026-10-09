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

class HomeCubit extends Cubit<HomeState> {
  final GetHomeActivitiesUseCase _getHomeActivitiesUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;
  final UpdateUserCityUseCase _updateUserCityUseCase;
  final GetActiveCitiesUseCase _getActiveCitiesUseCase;

  HomeCubit({
    required GetHomeActivitiesUseCase getHomeActivitiesUseCase,
    required GetCategoriesUseCase getCategoriesUseCase,
    required UpdateUserCityUseCase updateUserCityUseCase,
    required GetActiveCitiesUseCase getActiveCitiesUseCase,
  }) : _getHomeActivitiesUseCase = getHomeActivitiesUseCase,
       _getCategoriesUseCase = getCategoriesUseCase,
       _updateUserCityUseCase = updateUserCityUseCase,
       _getActiveCitiesUseCase = getActiveCitiesUseCase,
       super(HomeInitial());

  int _loadGeneration = 0;

  bool _isNetworkException(Exception e) {
    return e is SocketException ||
        e.toString().contains('SocketException') ||
        e.toString().contains('TimeoutException');
  }

  Future<void> loadHomeData({String? cityId}) async {
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

      final results = await Future.wait<dynamic>([
        categoriesFuture,
        citiesFuture,
        activitiesFuture,
      ]);

      if (isClosed || generation != _loadGeneration) return;

      final categoriesResult =
          results[0] as Result<List<CategoryEntity>, Exception>;
      final citiesResult = results[1] as Result<List<CityEntity>, Exception>;
      final activitiesResult =
          results[2] as Result<List<RequestEntity>, Exception>;

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

      // We always emit HomeSuccess to preserve the Home UI structure,
      // relying on the individual error flags to show localized retry buttons.

      final now = DateTime.now().toUtc();
      final in24Hours = now.add(const Duration(hours: 24));
      final inSevenDays = now.add(const Duration(days: 7));

      // 1. Only include future activities
      final futureActivities =
          allActivities
              .where(
                (a) =>
                    a.eventDateTime.isAfter(now) &&
                    (a.status == RequestStatus.open ||
                        a.status == RequestStatus.full),
              )
              .toList()
            ..sort((a, b) => a.eventDateTime.compareTo(b.eventDateTime));

      // 2. Urgent matches
      final urgent = futureActivities.where((a) {
        return a.eventDateTime.isBefore(in24Hours) &&
            (a.maxParticipants - a.currentParticipants) > 0;
      }).toList();
      final urgentIds = urgent.map((e) => e.id).toSet();

      // Keep time-based home sections mutually exclusive. The feed can include
      // other cities when no city is selected, so it cannot promise proximity.
      final comingUp = futureActivities.where((activity) {
        return !urgentIds.contains(activity.id) &&
            activity.eventDateTime.isBefore(inSevenDays);
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
          unreadNotifications: 0,
          hasFeedError: hasFeedError,
          isFeedNetworkError: isFeedNetworkError,
          hasCitiesError: hasCitiesError,
          hasCategoriesError: hasCategoriesError,
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
    String userId,
    String cityId,
    String cityName,
  ) async {
    if (isClosed) return;
    final currentState = state;
    if (currentState is HomeSuccess) {
      try {
        await _updateUserCityUseCase(
          userId: userId,
          cityId: cityId,
          cityName: cityName,
        );
        if (isClosed) return;
        await loadHomeData(cityId: cityId);
      } catch (e) {
        // Fallback or log if user update fails, but home load will retry anyway if we called it
      }
    }
  }
}
