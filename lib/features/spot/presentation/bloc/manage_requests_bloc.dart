import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/join_request_entity.dart';
import '../../domain/usecases/stream_spot_join_requests_usecase.dart';
import '../../domain/usecases/manage_join_request_usecase.dart';

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
  final List<JoinRequestEntity> requests;
  ManageRequestsLoaded({required this.requests});
}
class ManageRequestsError extends ManageRequestsState {
  final String message;
  ManageRequestsError({required this.message});
}

class ManageRequestsBloc extends Bloc<ManageRequestsEvent, ManageRequestsState> {
  final StreamSpotJoinRequestsUseCase _streamRequestsUseCase;
  final ManageJoinRequestUseCase _manageRequestUseCase;
  StreamSubscription? _requestsSubscription;

  ManageRequestsBloc({
    required StreamSpotJoinRequestsUseCase streamRequestsUseCase,
    required ManageJoinRequestUseCase manageRequestUseCase,
  })  : _streamRequestsUseCase = streamRequestsUseCase,
        _manageRequestUseCase = manageRequestUseCase,
        super(ManageRequestsInitial()) {
    on<LoadPendingRequestsEvent>(_onLoadPending);
    on<_RequestsUpdatedEvent>(_onRequestsUpdated);
    on<UpdateRequestStatusEvent>(_onUpdateStatus);
  }

  void _onLoadPending(LoadPendingRequestsEvent event, Emitter<ManageRequestsState> emit) {
    emit(ManageRequestsLoading());
    _requestsSubscription?.cancel();
    _requestsSubscription = _streamRequestsUseCase(event.spotId).listen((requests) {
      add(_RequestsUpdatedEvent(requests));
    });
    // In a real app we might handle stream errors explicitly
  }

  void _onRequestsUpdated(_RequestsUpdatedEvent event, Emitter<ManageRequestsState> emit) {
    emit(ManageRequestsLoaded(requests: event.requests));
  }

  Future<void> _onUpdateStatus(UpdateRequestStatusEvent event, Emitter<ManageRequestsState> emit) async {
    try {
      await _manageRequestUseCase(joinRequestId: event.requestId, status: event.status);
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
