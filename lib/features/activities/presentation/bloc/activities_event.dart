import 'package:equatable/equatable.dart';

abstract class ActivitiesEvent extends Equatable {
  const ActivitiesEvent();

  @override
  List<Object> get props => [];
}

class LoadActivitiesEvent extends ActivitiesEvent {
  const LoadActivitiesEvent();
}

class RefreshActivitiesEvent extends ActivitiesEvent {
  const RefreshActivitiesEvent();
}

class AcceptJoinRequestEvent extends ActivitiesEvent {
  final String joinRequestId;
  const AcceptJoinRequestEvent(this.joinRequestId);

  @override
  List<Object> get props => [joinRequestId];
}

class RejectJoinRequestEvent extends ActivitiesEvent {
  final String joinRequestId;
  const RejectJoinRequestEvent(this.joinRequestId);

  @override
  List<Object> get props => [joinRequestId];
}

class CancelJoinRequestEvent extends ActivitiesEvent {
  final String joinRequestId;
  const CancelJoinRequestEvent(this.joinRequestId);

  @override
  List<Object> get props => [joinRequestId];
}
