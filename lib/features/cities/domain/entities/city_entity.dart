import 'package:equatable/equatable.dart';

class CityEntity extends Equatable {
  final String id;
  final String name;
  final String? state;
  final bool isActive;
  final int displayOrder;

  const CityEntity({
    required this.id,
    required this.name,
    this.state,
    this.isActive = true,
    this.displayOrder = 0,
  });

  @override
  List<Object?> get props => [id, name, state, isActive, displayOrder];
}
