import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/city_entity.dart';

part 'city_model.freezed.dart';
part 'city_model.g.dart';

@freezed
abstract class CityModel extends Equatable
    with _$CityModel
    implements CityEntity {
  const CityModel._() : super();

  const factory CityModel({
    required String id,
    required String name,
    @JsonKey(includeIfNull: false) String? state,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'display_order', fromJson: _intFromJson)
    @Default(0)
    int displayOrder,
  }) = _CityModel;

  factory CityModel.fromJson(Map<String, dynamic> json) =>
      _$CityModelFromJson(json);

  @override
  List<Object?> get props => [id, name, state, isActive, displayOrder];

  @JsonKey(includeToJson: false, includeFromJson: false)
  @override
  bool? get stringify => true;
}

int _intFromJson(Object? value) =>
    value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;
