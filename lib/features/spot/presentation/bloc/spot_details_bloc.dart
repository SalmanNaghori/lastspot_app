import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/spot_entity.dart';
import '../../domain/usecases/get_spot_details_usecase.dart';
import '../../domain/usecases/join_spot_usecase.dart';
import '../../../auth/domain/repositories/auth_repository.dart';

abstract class SpotDetailsEvent {}

class LoadSpotDetailsEvent extends SpotDetailsEvent {
  final String spotId;
  LoadSpotDetailsEvent({required this.spotId});
}

class RequestToJoinEvent extends SpotDetailsEvent {
  final String spotId;
  RequestToJoinEvent({required this.spotId});
}

abstract class SpotDetailsState {}

class SpotDetailsInitial extends SpotDetailsState {}
class SpotDetailsLoading extends SpotDetailsState {}
class SpotDetailsLoaded extends SpotDetailsState {
  final SpotEntity post;
  final bool isHost;
  SpotDetailsLoaded({required this.post, required this.isHost});
}
class SpotDetailsError extends SpotDetailsState {
  final String message;
  SpotDetailsError({required this.message});
}

class RequestJoinSuccess extends SpotDetailsState {
  final String message;
  RequestJoinSuccess({required this.message});
}

class SpotDetailsBloc extends Bloc<SpotDetailsEvent, SpotDetailsState> {
  final GetSpotDetailsUseCase _getSpotDetailsUseCase;
  final JoinSpotUseCase _joinSpotUseCase;
  final AuthRepository _authRepository;

  SpotDetailsBloc({
    required GetSpotDetailsUseCase getSpotDetailsUseCase,
    required JoinSpotUseCase joinSpotUseCase,
    required AuthRepository authRepository,
  })  : _getSpotDetailsUseCase = getSpotDetailsUseCase,
        _joinSpotUseCase = joinSpotUseCase,
        _authRepository = authRepository,
        super(SpotDetailsInitial()) {
    on<LoadSpotDetailsEvent>(_onLoadSpotDetails);
    on<RequestToJoinEvent>(_onRequestToJoin);
  }

  Future<void> _onLoadSpotDetails(LoadSpotDetailsEvent event, Emitter<SpotDetailsState> emit) async {
    emit(SpotDetailsLoading());
    try {
      final post = await _getSpotDetailsUseCase(event.spotId);
      final currentUserId = _authRepository.getCurrentUserId();
      emit(SpotDetailsLoaded(post: post, isHost: post.hostId == currentUserId));
    } catch (e) {
      emit(SpotDetailsError(message: 'Failed to load spot details.'));
    }
  }

  Future<void> _onRequestToJoin(RequestToJoinEvent event, Emitter<SpotDetailsState> emit) async {
    final currentState = state;
    try {
      await _joinSpotUseCase(event.spotId);
      emit(RequestJoinSuccess(message: "Request sent successfully!"));
      if (currentState is SpotDetailsLoaded) {
        add(LoadSpotDetailsEvent(spotId: event.spotId));
      }
    } catch (e, st) {
      log('Unexpected error requesting to join', name: 'SpotDetailsBloc', error: e, stackTrace: st);
      emit(SpotDetailsError(message: 'An unexpected error occurred.'));
      if (currentState is SpotDetailsLoaded) {
        emit(currentState);
      }
    }
  }
}
