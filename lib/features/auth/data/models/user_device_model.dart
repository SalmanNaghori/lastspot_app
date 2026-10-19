import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_device_model.freezed.dart';
part 'user_device_model.g.dart';

@freezed
abstract class UserDeviceModel with _$UserDeviceModel {
  const factory UserDeviceModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'device_identifier') required String deviceIdentifier,
    required String platform,
    @JsonKey(name: 'fcm_token') String? fcmToken,
    @JsonKey(name: 'device_model') String? deviceModel,
    @JsonKey(name: 'os_version') String? osVersion,
    @JsonKey(name: 'app_version') String? appVersion,
    @JsonKey(name: 'build_number') @Default(0) int buildNumber,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'last_active_at') DateTime? lastActiveAt,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _UserDeviceModel;

  factory UserDeviceModel.fromJson(Map<String, dynamic> json) =>
      _$UserDeviceModelFromJson(_normalizeDeviceJson(json));
}

Map<String, dynamic> _normalizeDeviceJson(Map<String, dynamic> json) {
  final copy = Map<String, dynamic>.from(json);
  copy['id'] = json['id']?.toString() ?? '';
  copy['user_id'] = (json['user_id'] ?? json['userId'])?.toString() ?? '';
  copy['device_identifier'] =
      (json['device_identifier'] ?? json['deviceIdentifier'])?.toString() ?? '';
  copy['platform'] = json['platform']?.toString() ?? 'android';
  copy['fcm_token'] = (json['fcm_token'] ?? json['fcmToken'])?.toString();
  copy['device_model'] = (json['device_model'] ?? json['deviceModel'])
      ?.toString();
  copy['os_version'] = (json['os_version'] ?? json['osVersion'])?.toString();
  copy['app_version'] = (json['app_version'] ?? json['appVersion'])?.toString();
  copy['build_number'] = _toInt(json['build_number'] ?? json['buildNumber']);
  copy['is_active'] = json['is_active'] ?? json['isActive'] ?? true;
  return copy;
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}
