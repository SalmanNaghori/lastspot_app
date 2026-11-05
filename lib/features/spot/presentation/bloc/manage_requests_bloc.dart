import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/join_request_entity.dart';
import '../../domain/entities/request_entity.dart';
import '../../domain/usecases/get_spot_details_usecase.dart';
import '../../domain/usecases/manage_join_request_usecase.dart';
import '../../domain/usecases/stream_spot_join_requests_usecase.dart';

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

class _RequestsErrorEvent extends ManageRequestsEvent {
  final String message;
  _RequestsErrorEvent(this.message);
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

class ManageRequestsActionError extends ManageRequestsState {
  final String message;
  final ManageRequestsLoaded previousState;
  ManageRequestsActionError({
    required this.message,
    required this.previousState,
  });
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
    on<_RequestsErrorEvent>(_onRequestsError);
    on<UpdateRequestStatusEvent>(_onUpdateStatus);
  }

  void _onLoadPending(
    LoadPendingRequestsEvent event,
    Emitter<ManageRequestsState> emit,
  ) async {
    emit(ManageRequestsLoading());
    try {
      _currentSpot = await _getSpotDetailsUseCase(event.spotId);
    } catch (e, st) {
      developer.log(
        'Failed to load spot details: $e',
        name: 'ManageRequestsBloc',
        error: e,
        stackTrace: st,
      );
      emit(
        ManageRequestsError(
          message: _resolveErrorMessage(
            e,
            fallback: 'Failed to load spot details.',
          ),
        ),
      );
      return;
    }

    await _requestsSubscription?.cancel();
    _requestsSubscription = _streamRequestsUseCase(event.spotId).listen(
      (requests) {
        add(_RequestsUpdatedEvent(requests));
      },
      onError: (error) {
        developer.log(
          'Error in join requests stream: $error',
          name: 'ManageRequestsBloc',
          error: error,
        );
        add(_RequestsErrorEvent(_resolveStreamErrorMessage(error)));
      },
    );
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

  void _onRequestsError(
    _RequestsErrorEvent event,
    Emitter<ManageRequestsState> emit,
  ) {
    final currentState = state;
    if (currentState is ManageRequestsLoaded) {
      emit(
        ManageRequestsActionError(
          message: event.message,
          previousState: currentState,
        ),
      );
    } else if (currentState is ManageRequestsActionError) {
      emit(
        ManageRequestsActionError(
          message: event.message,
          previousState: currentState.previousState,
        ),
      );
    } else {
      emit(ManageRequestsError(message: event.message));
    }
  }

  Future<void> _onUpdateStatus(
    UpdateRequestStatusEvent event,
    Emitter<ManageRequestsState> emit,
  ) async {
    final currentState = state is ManageRequestsLoaded
        ? state as ManageRequestsLoaded
        : (state is ManageRequestsActionError
              ? (state as ManageRequestsActionError).previousState
              : null);

    try {
      if (event.status == 'accepted') {
        await _manageRequestUseCase.accept(event.requestId);
        if (_currentSpot != null) {
          try {
            _currentSpot = await _getSpotDetailsUseCase(_currentSpot!.id);
          } catch (_) {}
        }
      } else if (event.status == 'rejected') {
        await _manageRequestUseCase.reject(event.requestId);
      } else if (event.status == 'cancelled') {
        await _manageRequestUseCase.cancel(event.requestId);
      }
    } on PostgrestException catch (e) {
      final msg = _resolveErrorMessage(e);
      if (currentState != null) {
        emit(
          ManageRequestsActionError(message: msg, previousState: currentState),
        );
      } else {
        emit(ManageRequestsError(message: msg));
      }
    } catch (e) {
      final msg = _resolveErrorMessage(e);
      if (currentState != null) {
        emit(
          ManageRequestsActionError(message: msg, previousState: currentState),
        );
      } else {
        emit(ManageRequestsError(message: msg));
      }
    }
  }

  String _resolveStreamErrorMessage(Object error) {
    final errStr = error.toString().toLowerCase();

    if (error is SocketException ||
        errStr.contains('socketexception') ||
        errStr.contains('failed host lookup') ||
        errStr.contains('network is unreachable') ||
        errStr.contains('connection refused') ||
        errStr.contains('connection reset')) {
      return 'Network connection lost. Please check your internet connection.';
    }

    if (error is AuthException ||
        errStr.contains('invalid claim') ||
        errStr.contains('jwt expired')) {
      return 'Authentication session expired. Please log in again.';
    }

    if (error is PostgrestException) {
      if (error.code == '42501' ||
          errStr.contains('permission denied') ||
          errStr.contains('violates row-level security')) {
        return 'Permission denied. You do not have permission to view these requests.';
      }
      return error.message;
    }

    if (error is FormatException ||
        error is TypeError ||
        errStr.contains('is not a subtype of type')) {
      return 'Data parsing error occurred while reading join requests.';
    }

    if (errStr.contains('channel') ||
        errStr.contains('realtime') ||
        errStr.contains('websocket') ||
        errStr.contains('subscription') ||
        errStr.contains('closed')) {
      return 'Realtime subscription interrupted. Please check if Realtime is enabled for the join_requests table in your Supabase Dashboard.';
    }

    return 'Failed to stream join requests. Please pull to refresh.';
  }

  String _resolveErrorMessage(Object error, {String? fallback}) {
    final errStr = error.toString().toLowerCase();

    if (error is SocketException ||
        errStr.contains('socketexception') ||
        errStr.contains('failed host lookup') ||
        errStr.contains('network is unreachable')) {
      return 'No internet connection. Please check your network and try again.';
    }

    if (error is AuthException) {
      return 'Authentication required. Please log in again.';
    }

    if (error is PostgrestException) {
      if (error.code == '42501' ||
          errStr.contains('permission denied') ||
          errStr.contains('violates row-level security')) {
        return 'Permission denied. You do not have permission to perform this action.';
      }
      return error.message;
    }

    return fallback ?? 'An unexpected error occurred. Please try again.';
  }

  @override
  Future<void> close() {
    _requestsSubscription?.cancel();
    return super.close();
  }
}
