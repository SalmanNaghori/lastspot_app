import 'package:equatable/equatable.dart';
import 'package:lastspot_app/features/spot/domain/entities/join_request_entity.dart';
import '../../../spot/domain/entities/request_entity.dart';

abstract class ActivitiesState extends Equatable {
  const ActivitiesState();

  @override
  List<Object> get props => [];
}

class ActivitiesInitial extends ActivitiesState {
  const ActivitiesInitial();
}

class ActivitiesLoading extends ActivitiesState {
  const ActivitiesLoading();
}

class ActivitiesLoaded extends ActivitiesState {
  /// Activities where the current user is the creator.
  final List<RequestEntity> hosted;

  /// Activities the current user has joined (accepted join request, not creator).
  final List<RequestEntity> joined;

  /// Join requests received by the current user for their hosted activities.
  final List<JoinRequestEntity> receivedRequests;

  /// Join requests sent by the current user.
  final List<JoinRequestEntity> sentRequests;

  const ActivitiesLoaded({
    required this.hosted,
    required this.joined,
    required this.receivedRequests,
    required this.sentRequests,
  });

  @override
  List<Object> get props => [hosted, joined, receivedRequests, sentRequests];
}

class ActivitiesError extends ActivitiesState {
  final String message;
  final bool isNetworkError;

  const ActivitiesError(this.message, {this.isNetworkError = false});

  @override
  List<Object> get props => [message, isNetworkError];
}

class ActivitiesActionMessage extends ActivitiesLoaded {
  final String message;
  final bool isError;

  const ActivitiesActionMessage({
    required super.hosted,
    required super.joined,
    required super.receivedRequests,
    required super.sentRequests,
    required this.message,
    this.isError = false,
  });

  @override
  List<Object> get props => [...super.props, message, isError];
}
