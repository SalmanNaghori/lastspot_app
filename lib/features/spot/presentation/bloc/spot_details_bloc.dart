import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/request_entity.dart';
import '../../domain/usecases/get_spot_details_usecase.dart';
import '../../domain/usecases/join_spot_usecase.dart';
import '../../domain/usecases/get_confirmed_players_usecase.dart';
import '../../domain/usecases/get_user_join_request_usecase.dart';
import '../../domain/entities/join_request_entity.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SpotDetailsEvent {}

class LoadSpotDetailsEvent extends SpotDetailsEvent {
  final String spotId;
  final RequestEntity? initialSpot;

  LoadSpotDetailsEvent({required this.spotId, this.initialSpot});
}

class RequestToJoinEvent extends SpotDetailsEvent {
  final String spotId;

  RequestToJoinEvent({required this.spotId});
}

abstract class SpotDetailsState {}

class SpotDetailsInitial extends SpotDetailsState {}

class SpotDetailsLoading extends SpotDetailsState {}

class SpotDetailsLoaded extends SpotDetailsState {
  final RequestEntity post;
  final bool isHost;
  final List<JoinRequestEntity> confirmedPlayers;
  final JoinRequestEntity? userJoinRequest;

  SpotDetailsLoaded({
    required this.post,
    required this.isHost,
    required this.confirmedPlayers,
    this.userJoinRequest,
  });
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
  final GetConfirmedPlayersUseCase _getConfirmedPlayersUseCase;
  final GetUserJoinRequestUseCase _getUserJoinRequestUseCase;

  SpotDetailsBloc({
    required GetSpotDetailsUseCase getSpotDetailsUseCase,
    required JoinSpotUseCase joinSpotUseCase,
    required AuthRepository authRepository,
    required GetConfirmedPlayersUseCase getConfirmedPlayersUseCase,
    required GetUserJoinRequestUseCase getUserJoinRequestUseCase,
  }) : _getSpotDetailsUseCase = getSpotDetailsUseCase,
       _joinSpotUseCase = joinSpotUseCase,
       _authRepository = authRepository,
       _getConfirmedPlayersUseCase = getConfirmedPlayersUseCase,
       _getUserJoinRequestUseCase = getUserJoinRequestUseCase,
       super(SpotDetailsInitial()) {
    on<LoadSpotDetailsEvent>(_onLoadSpotDetails);
    on<RequestToJoinEvent>(_onRequestToJoin);
  }

  Future<void> _onLoadSpotDetails(
    LoadSpotDetailsEvent event,
    Emitter<SpotDetailsState> emit,
  ) async {
    final currentUserId = _authRepository.getCurrentUserId();
    if (event.initialSpot != null) {
      emit(
        SpotDetailsLoaded(
          post: event.initialSpot!,
          isHost: event.initialSpot!.userId == currentUserId,
          confirmedPlayers: [],
        ),
      );
    } else {
      emit(SpotDetailsLoading());
    }
    try {
      final post = await _getSpotDetailsUseCase(event.spotId);
      final confirmedPlayers = await _getConfirmedPlayersUseCase(event.spotId);
      final currentUserId = _authRepository.getCurrentUserId();
      final userJoinRequest = await _getUserJoinRequestUseCase(event.spotId);
      emit(
        SpotDetailsLoaded(
          post: post,
          isHost: post.userId == currentUserId,
          confirmedPlayers: confirmedPlayers,
          userJoinRequest: userJoinRequest,
        ),
      );
    } catch (e) {
      emit(SpotDetailsError(message: 'Failed to load spot details.'));
    }
  }

  Future<void> _onRequestToJoin(
    RequestToJoinEvent event,
    Emitter<SpotDetailsState> emit,
  ) async {
    final currentState = state;
    try {
      await _joinSpotUseCase(event.spotId);
      emit(RequestJoinSuccess(message: "Request sent successfully!"));
      if (currentState is SpotDetailsLoaded) {
        add(LoadSpotDetailsEvent(spotId: event.spotId));
      }
    } on PostgrestException catch (e) {
      emit(SpotDetailsError(message: e.message));
      if (currentState is SpotDetailsLoaded) {
        emit(currentState);
      }
    } catch (e, st) {
      log(
        'Unexpected error requesting to join',
        name: 'SpotDetailsBloc',
        error: e,
        stackTrace: st,
      );
      emit(SpotDetailsError(message: 'An unexpected error occurred.'));
      if (currentState is SpotDetailsLoaded) {
        emit(currentState);
      }
    }
  }
}
