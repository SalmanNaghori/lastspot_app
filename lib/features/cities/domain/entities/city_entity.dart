import 'package:equatable/equatable.dart';
import '../../../../core/extension/string_extension.dart';

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

extension CityEntityFormattingX on CityEntity {
  /// City name with capitalized first characters
  String get formattedName => name.toTitleCase();

  /// State name with capitalized first characters
  String? get formattedState => state?.trim().toTitleCase();

  /// Combined formatted "City, State" string
  String get formattedLocation =>
      formattedState != null && formattedState!.isNotEmpty
      ? '$formattedName, $formattedState'
      : formattedName;
}
