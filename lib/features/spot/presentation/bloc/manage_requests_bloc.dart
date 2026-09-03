import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/join_request_entity.dart';
import '../../domain/usecases/stream_spot_join_requests_usecase.dart';
import '../../domain/usecases/manage_join_request_usecase.dart';
import '../../domain/usecases/get_spot_details_usecase.dart';
import '../../domain/entities/request_entity.dart';

abstract class ManageRequestsEvent {}

class LoadPendingRequestsEvent extends ManageRequestsEvent {
  final String spotId;
  LoadPendingRequestsEvent({required this.spotId});
}

class UpdateRequestStatusEvent extends ManageRequestsEvent {
  final String requestId;
  final String status;
  UpdateRequestStatusEvent({required this.requestId, required this.status});
}

class _RequestsUpdatedEvent extends ManageRequestsEvent {
  final List<JoinRequestEntity> requests;
  _RequestsUpdatedEvent(this.requests);
}

abstract class ManageRequestsState {}

class ManageRequestsInitial extends ManageRequestsState {}

class ManageRequestsLoading extends ManageRequestsState {}

class ManageRequestsLoaded extends ManageRequestsState {
  final RequestEntity post;
  final List<JoinRequestEntity> pendingRequests;
  ManageRequestsLoaded({required this.post, required this.pendingRequests});
}

class ManageRequestsError extends ManageRequestsState {
  final String message;
  ManageRequestsError({required this.message});
}

class ManageRequestsBloc
    extends Bloc<ManageRequestsEvent, ManageRequestsState> {
  final StreamSpotJoinRequestsUseCase _streamRequestsUseCase;
  final ManageJoinRequestUseCase _manageRequestUseCase;
  final GetSpotDetailsUseCase _getSpotDetailsUseCase;
  RequestEntity? _currentSpot;
  StreamSubscription? _requestsSubscription;

  ManageRequestsBloc({
    required StreamSpotJoinRequestsUseCase streamRequestsUseCase,
    required ManageJoinRequestUseCase manageRequestUseCase,
    required GetSpotDetailsUseCase getSpotDetailsUseCase,
  }) : _streamRequestsUseCase = streamRequestsUseCase,
       _manageRequestUseCase = manageRequestUseCase,
       _getSpotDetailsUseCase = getSpotDetailsUseCase,
       super(ManageRequestsInitial()) {
    on<LoadPendingRequestsEvent>(_onLoadPending);
    on<_RequestsUpdatedEvent>(_onRequestsUpdated);
    on<UpdateRequestStatusEvent>(_onUpdateStatus);
  }

  void _onLoadPending(
    LoadPendingRequestsEvent event,
    Emitter<ManageRequestsState> emit,
  ) async {
    emit(ManageRequestsLoading());
    try {
      _currentSpot = await _getSpotDetailsUseCase(event.spotId);
    } catch (e) {
      emit(ManageRequestsError(message: 'Failed to load spot details.'));
      return;
    }

    _requestsSubscription?.cancel();
    _requestsSubscription = _streamRequestsUseCase(event.spotId).listen((
      requests,
    ) {
      add(_RequestsUpdatedEvent(requests));
    });
  }

  void _onRequestsUpdated(
    _RequestsUpdatedEvent event,
    Emitter<ManageRequestsState> emit,
  ) {
    if (_currentSpot != null) {
      emit(
        ManageRequestsLoaded(
          post: _currentSpot!,
          pendingRequests: event.requests,
        ),
      );
    }
  }

  Future<void> _onUpdateStatus(
    UpdateRequestStatusEvent event,
    Emitter<ManageRequestsState> emit,
  ) async {
    try {
      await _manageRequestUseCase(
        joinRequestId: event.requestId,
        status: event.status,
      );
    } catch (e) {
      // In a more complex app, we might emit a temporary error state, but this is sufficient for now
    }
  }

  @override
  Future<void> close() {
    _requestsSubscription?.cancel();
    return super.close();
  }
}
