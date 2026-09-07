import 'package:equatable/equatable.dart';
import '../../domain/entities/city_entity.dart';

abstract class CityState extends Equatable {
  const CityState();

  @override
  List<Object?> get props => [];
}

class CityInitial extends CityState {}

class CityLoading extends CityState {}

class CityLoaded extends CityState {
  final List<CityEntity> cities;

  const CityLoaded({required this.cities});

  @override
  List<Object?> get props => [cities];
}

class CityError extends CityState {
  final String message;

  const CityError({required this.message});

  @override
  List<Object?> get props => [message];
}
