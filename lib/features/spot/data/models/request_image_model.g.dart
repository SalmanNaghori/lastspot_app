// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_image_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RequestImageModel _$RequestImageModelFromJson(Map<String, dynamic> json) =>
    _RequestImageModel(
      id: json['id'] as String? ?? '',
      requestId: json['request_id'] as String? ?? '',
      storagePath: json['storage_path'] as String? ?? '',
      sortOrder: _intValue(json['sort_order']),
      createdAt: _dateValue(json['created_at']),
    );

Map<String, dynamic> _$RequestImageModelToJson(_RequestImageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'request_id': instance.requestId,
      'storage_path': instance.storagePath,
      'sort_order': instance.sortOrder,
      'created_at': instance.createdAt.toIso8601String(),
    };
