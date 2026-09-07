import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/network_exceptions.dart';
import '../../../../core/utils/result.dart';
import '../../domain/usecases/get_active_cities_usecase.dart';
import 'city_state.dart';

class CityCubit extends Cubit<CityState> {
  final GetActiveCitiesUseCase _getActiveCitiesUseCase;

  CityCubit({required GetActiveCitiesUseCase getActiveCitiesUseCase})
      : _getActiveCitiesUseCase = getActiveCitiesUseCase,
        super(CityInitial());

  Future<void> fetchCities() async {
    emit(CityLoading());
    final result = await _getActiveCitiesUseCase();
    switch (result) {
      case Success(value: final cities):
        emit(CityLoaded(cities: cities));
      case Failure(exception: final exception):
        if (exception is NoInternetException) {
          emit(const CityError(message: 'no_internet'));
        } else {
          emit(CityError(message: exception.toString()));
        }
    }
  }
}
