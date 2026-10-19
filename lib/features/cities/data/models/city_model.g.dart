// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CityModel _$CityModelFromJson(Map<String, dynamic> json) => _CityModel(
  id: json['id'] as String,
  name: json['name'] as String,
  state: json['state'] as String?,
  isActive: json['is_active'] as bool? ?? true,
  displayOrder: json['display_order'] == null
      ? 0
      : _intFromJson(json['display_order']),
);

Map<String, dynamic> _$CityModelToJson(_CityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'state': ?instance.state,
      'is_active': instance.isActive,
      'display_order': instance.displayOrder,
    };
