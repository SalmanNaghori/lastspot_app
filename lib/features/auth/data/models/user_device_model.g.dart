// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_device_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserDeviceModel _$UserDeviceModelFromJson(Map<String, dynamic> json) =>
    _UserDeviceModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      deviceIdentifier: json['device_identifier'] as String,
      platform: json['platform'] as String,
      fcmToken: json['fcm_token'] as String?,
      deviceModel: json['device_model'] as String?,
      osVersion: json['os_version'] as String?,
      appVersion: json['app_version'] as String?,
      buildNumber: (json['build_number'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      lastActiveAt: json['last_active_at'] == null
          ? null
          : DateTime.parse(json['last_active_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$UserDeviceModelToJson(_UserDeviceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'device_identifier': instance.deviceIdentifier,
      'platform': instance.platform,
      'fcm_token': instance.fcmToken,
      'device_model': instance.deviceModel,
      'os_version': instance.osVersion,
      'app_version': instance.appVersion,
      'build_number': instance.buildNumber,
      'is_active': instance.isActive,
      'last_active_at': instance.lastActiveAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
