import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_spot_usecase.dart';

abstract class CreateSpotEvent {}

class SubmitSpotEvent extends CreateSpotEvent {
  final String sportCategory;
  final int totalSpots;
  final int neededSpots;
  final DateTime matchTime;
  final String venueName;
  final String? googleMapsUrl;
  final String? additionalNotes;

  SubmitSpotEvent({
    required this.sportCategory,
    required this.totalSpots,
    required this.neededSpots,
    required this.matchTime,
    required this.venueName,
    this.googleMapsUrl,
    this.additionalNotes,
  });
}

abstract class CreateSpotState {}

class CreateSpotInitial extends CreateSpotState {}
class CreateSpotLoading extends CreateSpotState {}
class CreateSpotSuccess extends CreateSpotState {}
class CreateSpotError extends CreateSpotState {
  final String message;
  CreateSpotError({required this.message});
}

class CreateSpotBloc extends Bloc<CreateSpotEvent, CreateSpotState> {
  final CreateSpotUseCase _createSpotUseCase;

  CreateSpotBloc({required CreateSpotUseCase createSpotUseCase}) 
      : _createSpotUseCase = createSpotUseCase,
        super(CreateSpotInitial()) {
    on<SubmitSpotEvent>(_onSubmitSpot);
  }

  Future<void> _onSubmitSpot(SubmitSpotEvent event, Emitter<CreateSpotState> emit) async {
    emit(CreateSpotLoading());
    try {
      await _createSpotUseCase(
        sportCategory: event.sportCategory,
        totalSpots: event.totalSpots,
        neededSpots: event.neededSpots,
        matchTime: event.matchTime,
        venueName: event.venueName,
        googleMapsUrl: event.googleMapsUrl,
        additionalNotes: event.additionalNotes,
      );
      emit(CreateSpotSuccess());
    } catch (e) {
      emit(CreateSpotError(message: 'Failed to create request.'));
    }
  }
}
