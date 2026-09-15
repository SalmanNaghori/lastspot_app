import 'package:equatable/equatable.dart';
import '../../../spot/domain/entities/request_entity.dart';

abstract class ActivitiesState extends Equatable {
  const ActivitiesState();

  @override
  List<Object> get props => [];
}

class ActivitiesInitial extends ActivitiesState {}

class ActivitiesLoading extends ActivitiesState {}

class ActivitiesLoaded extends ActivitiesState {
  final List<RequestEntity> activities;

  const ActivitiesLoaded(this.activities);

  @override
  List<Object> get props => [activities];
}

class ActivitiesError extends ActivitiesState {
  final String message;

  const ActivitiesError(this.message);

  @override
  List<Object> get props => [message];
}
