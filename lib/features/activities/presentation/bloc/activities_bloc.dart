import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../spot/domain/repositories/spot_repository.dart';
import 'activities_event.dart';
import 'activities_state.dart';

class ActivitiesBloc extends Bloc<ActivitiesEvent, ActivitiesState> {
  final SpotRepository spotRepository;

  ActivitiesBloc({required this.spotRepository}) : super(ActivitiesInitial()) {
    on<LoadActivitiesEvent>(_onLoadActivities);
  }

  Future<void> _onLoadActivities(
    LoadActivitiesEvent event,
    Emitter<ActivitiesState> emit,
  ) async {
    emit(ActivitiesLoading());
    try {
      final activities = await spotRepository.getUserActivities();
      emit(ActivitiesLoaded(activities));
    } catch (e) {
      emit(ActivitiesError(e.toString()));
    }
  }
}
