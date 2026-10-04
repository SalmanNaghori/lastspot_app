import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../spot/domain/repositories/spot_repository.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import 'activities_event.dart';
import 'activities_state.dart';

class ActivitiesBloc extends Bloc<ActivitiesEvent, ActivitiesState> {
  final SpotRepository _spotRepository;
  final AuthRepository _authRepository;

  ActivitiesBloc({
    required SpotRepository spotRepository,
    required AuthRepository authRepository,
  }) : _spotRepository = spotRepository,
       _authRepository = authRepository,
       super(const ActivitiesInitial()) {
    on<LoadActivitiesEvent>(_onLoad);
    on<RefreshActivitiesEvent>(_onRefresh);
    on<AcceptJoinRequestEvent>(_onAcceptJoinRequest);
    on<RejectJoinRequestEvent>(_onRejectJoinRequest);
    on<CancelJoinRequestEvent>(_onCancelJoinRequest);
  }

  Future<void> _onLoad(
    LoadActivitiesEvent event,
    Emitter<ActivitiesState> emit,
  ) async {
    emit(const ActivitiesLoading());
    await _fetchActivities(emit);
  }

  Future<void> _onRefresh(
    RefreshActivitiesEvent event,
    Emitter<ActivitiesState> emit,
  ) async {
    // Keep current state visible during refresh (silent refresh)
    await _fetchActivities(emit);
  }

  Future<void> _fetchActivities(Emitter<ActivitiesState> emit) async {
    try {
      final currentUserId = _authRepository.getCurrentUserId();
      final all = await _spotRepository.getUserActivities();
      final receivedRequests = await _spotRepository.getReceivedJoinRequests();
      final sentRequests = await _spotRepository.getSentJoinRequests();

      final hosted = all.where((a) => a.userId == currentUserId).toList()
        ..sort((a, b) => b.eventDateTime.compareTo(a.eventDateTime));

      final joined = all.where((a) => a.userId != currentUserId).toList()
        ..sort((a, b) => b.eventDateTime.compareTo(a.eventDateTime));

      emit(
        ActivitiesLoaded(
          hosted: hosted,
          joined: joined,
          receivedRequests: receivedRequests,
          sentRequests: sentRequests,
        ),
      );
    } on SocketException {
      emit(
        const ActivitiesError(
          'No internet connection. Please try again.',
          isNetworkError: true,
        ),
      );
    } catch (e) {
      emit(ActivitiesError('Could not load activities. Please try again.'));
    }
  }

  Future<void> _onAcceptJoinRequest(
    AcceptJoinRequestEvent event,
    Emitter<ActivitiesState> emit,
  ) async {
    try {
      await _spotRepository.acceptJoinRequest(event.joinRequestId);
      await _fetchActivities(emit);
    } catch (e) {
      _handleActionError(e, emit);
    }
  }

  Future<void> _onRejectJoinRequest(
    RejectJoinRequestEvent event,
    Emitter<ActivitiesState> emit,
  ) async {
    try {
      await _spotRepository.rejectJoinRequest(event.joinRequestId);
      await _fetchActivities(emit);
    } catch (e) {
      _handleActionError(e, emit);
    }
  }

  Future<void> _onCancelJoinRequest(
    CancelJoinRequestEvent event,
    Emitter<ActivitiesState> emit,
  ) async {
    try {
      await _spotRepository.cancelJoinRequest(event.joinRequestId);
      await _fetchActivities(emit);
    } catch (e) {
      _handleActionError(e, emit);
    }
  }

  Future<void> _handleActionError(
    dynamic e,
    Emitter<ActivitiesState> emit,
  ) async {
    String message = 'An error occurred';
    if (e.runtimeType.toString() == 'PostgrestException') {
      message = (e as dynamic).message as String;
    } else {
      message = e.toString();
    }

    if (state is ActivitiesLoaded) {
      final currentState = state as ActivitiesLoaded;
      emit(
        ActivitiesActionMessage(
          hosted: currentState.hosted,
          joined: currentState.joined,
          receivedRequests: currentState.receivedRequests,
          sentRequests: currentState.sentRequests,
          message: message,
          isError: true,
        ),
      );
    }
    await _fetchActivities(emit);
  }
}
