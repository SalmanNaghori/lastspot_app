// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_device_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserDeviceModel {

 String get id;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'device_identifier') String get deviceIdentifier; String get platform;@JsonKey(name: 'fcm_token') String? get fcmToken;@JsonKey(name: 'device_model') String? get deviceModel;@JsonKey(name: 'os_version') String? get osVersion;@JsonKey(name: 'app_version') String? get appVersion;@JsonKey(name: 'build_number') int get buildNumber;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'last_active_at') DateTime? get lastActiveAt;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;
/// Create a copy of UserDeviceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserDeviceModelCopyWith<UserDeviceModel> get copyWith => _$UserDeviceModelCopyWithImpl<UserDeviceModel>(this as UserDeviceModel, _$identity);

  /// Serializes this UserDeviceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UserDeviceModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserDeviceModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.deviceIdentifier, _this.deviceIdentifier) || other.deviceIdentifier == _this.deviceIdentifier)&&(identical(other.platform, _this.platform) || other.platform == _this.platform)&&(identical(other.fcmToken, _this.fcmToken) || other.fcmToken == _this.fcmToken)&&(identical(other.deviceModel, _this.deviceModel) || other.deviceModel == _this.deviceModel)&&(identical(other.osVersion, _this.osVersion) || other.osVersion == _this.osVersion)&&(identical(other.appVersion, _this.appVersion) || other.appVersion == _this.appVersion)&&(identical(other.buildNumber, _this.buildNumber) || other.buildNumber == _this.buildNumber)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.lastActiveAt, _this.lastActiveAt) || other.lastActiveAt == _this.lastActiveAt)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UserDeviceModel;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.deviceIdentifier,_this.platform,_this.fcmToken,_this.deviceModel,_this.osVersion,_this.appVersion,_this.buildNumber,_this.isActive,_this.lastActiveAt,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as UserDeviceModel;
  return 'UserDeviceModel(id: ${_this.id}, userId: ${_this.userId}, deviceIdentifier: ${_this.deviceIdentifier}, platform: ${_this.platform}, fcmToken: ${_this.fcmToken}, deviceModel: ${_this.deviceModel}, osVersion: ${_this.osVersion}, appVersion: ${_this.appVersion}, buildNumber: ${_this.buildNumber}, isActive: ${_this.isActive}, lastActiveAt: ${_this.lastActiveAt}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $UserDeviceModelCopyWith<$Res>  {
  factory $UserDeviceModelCopyWith(UserDeviceModel value, $Res Function(UserDeviceModel) _then) = _$UserDeviceModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'device_identifier') String deviceIdentifier, String platform,@JsonKey(name: 'fcm_token') String? fcmToken,@JsonKey(name: 'device_model') String? deviceModel,@JsonKey(name: 'os_version') String? osVersion,@JsonKey(name: 'app_version') String? appVersion,@JsonKey(name: 'build_number') int buildNumber,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'last_active_at') DateTime? lastActiveAt,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class _$UserDeviceModelCopyWithImpl<$Res>
    implements $UserDeviceModelCopyWith<$Res> {
  _$UserDeviceModelCopyWithImpl(this._self, this._then);

  final UserDeviceModel _self;
  final $Res Function(UserDeviceModel) _then;

/// Create a copy of UserDeviceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? deviceIdentifier = null,Object? platform = null,Object? fcmToken = freezed,Object? deviceModel = freezed,Object? osVersion = freezed,Object? appVersion = freezed,Object? buildNumber = null,Object? isActive = null,Object? lastActiveAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(UserDeviceModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,deviceIdentifier: null == deviceIdentifier ? _self.deviceIdentifier : deviceIdentifier // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,fcmToken: freezed == fcmToken ? _self.fcmToken : fcmToken // ignore: cast_nullable_to_non_nullable
as String?,deviceModel: freezed == deviceModel ? _self.deviceModel : deviceModel // ignore: cast_nullable_to_non_nullable
as String?,osVersion: freezed == osVersion ? _self.osVersion : osVersion // ignore: cast_nullable_to_non_nullable
as String?,appVersion: freezed == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String?,buildNumber: null == buildNumber ? _self.buildNumber : buildNumber // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,lastActiveAt: freezed == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserDeviceModel].
extension UserDeviceModelPatterns on UserDeviceModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserDeviceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserDeviceModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserDeviceModel value)  $default,){
final _that = this;
switch (_that) {
case _UserDeviceModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserDeviceModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserDeviceModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'device_identifier')  String deviceIdentifier,  String platform, @JsonKey(name: 'fcm_token')  String? fcmToken, @JsonKey(name: 'device_model')  String? deviceModel, @JsonKey(name: 'os_version')  String? osVersion, @JsonKey(name: 'app_version')  String? appVersion, @JsonKey(name: 'build_number')  int buildNumber, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'last_active_at')  DateTime? lastActiveAt, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserDeviceModel() when $default != null:
return $default(_that.id,_that.userId,_that.deviceIdentifier,_that.platform,_that.fcmToken,_that.deviceModel,_that.osVersion,_that.appVersion,_that.buildNumber,_that.isActive,_that.lastActiveAt,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'device_identifier')  String deviceIdentifier,  String platform, @JsonKey(name: 'fcm_token')  String? fcmToken, @JsonKey(name: 'device_model')  String? deviceModel, @JsonKey(name: 'os_version')  String? osVersion, @JsonKey(name: 'app_version')  String? appVersion, @JsonKey(name: 'build_number')  int buildNumber, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'last_active_at')  DateTime? lastActiveAt, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _UserDeviceModel():
return $default(_that.id,_that.userId,_that.deviceIdentifier,_that.platform,_that.fcmToken,_that.deviceModel,_that.osVersion,_that.appVersion,_that.buildNumber,_that.isActive,_that.lastActiveAt,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'device_identifier')  String deviceIdentifier,  String platform, @JsonKey(name: 'fcm_token')  String? fcmToken, @JsonKey(name: 'device_model')  String? deviceModel, @JsonKey(name: 'os_version')  String? osVersion, @JsonKey(name: 'app_version')  String? appVersion, @JsonKey(name: 'build_number')  int buildNumber, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'last_active_at')  DateTime? lastActiveAt, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _UserDeviceModel() when $default != null:
return $default(_that.id,_that.userId,_that.deviceIdentifier,_that.platform,_that.fcmToken,_that.deviceModel,_that.osVersion,_that.appVersion,_that.buildNumber,_that.isActive,_that.lastActiveAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserDeviceModel implements UserDeviceModel {
  const _UserDeviceModel({required this.id, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'device_identifier') required this.deviceIdentifier, required this.platform, @JsonKey(name: 'fcm_token') this.fcmToken, @JsonKey(name: 'device_model') this.deviceModel, @JsonKey(name: 'os_version') this.osVersion, @JsonKey(name: 'app_version') this.appVersion, @JsonKey(name: 'build_number') this.buildNumber = 0, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'last_active_at') this.lastActiveAt, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt});
  factory _UserDeviceModel.fromJson(Map<String, dynamic> json) => _$UserDeviceModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'device_identifier') final  String deviceIdentifier;
@override final  String platform;
@override@JsonKey(name: 'fcm_token') final  String? fcmToken;
@override@JsonKey(name: 'device_model') final  String? deviceModel;
@override@JsonKey(name: 'os_version') final  String? osVersion;
@override@JsonKey(name: 'app_version') final  String? appVersion;
@override@JsonKey(name: 'build_number') final  int buildNumber;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'last_active_at') final  DateTime? lastActiveAt;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;

/// Create a copy of UserDeviceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserDeviceModelCopyWith<_UserDeviceModel> get copyWith => __$UserDeviceModelCopyWithImpl<_UserDeviceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserDeviceModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserDeviceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.deviceIdentifier, deviceIdentifier) || other.deviceIdentifier == deviceIdentifier)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.fcmToken, fcmToken) || other.fcmToken == fcmToken)&&(identical(other.deviceModel, deviceModel) || other.deviceModel == deviceModel)&&(identical(other.osVersion, osVersion) || other.osVersion == osVersion)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.buildNumber, buildNumber) || other.buildNumber == buildNumber)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.lastActiveAt, lastActiveAt) || other.lastActiveAt == lastActiveAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,deviceIdentifier,platform,fcmToken,deviceModel,osVersion,appVersion,buildNumber,isActive,lastActiveAt,createdAt,updatedAt);
}

@override
String toString() {
    return 'UserDeviceModel(id: $id, userId: $userId, deviceIdentifier: $deviceIdentifier, platform: $platform, fcmToken: $fcmToken, deviceModel: $deviceModel, osVersion: $osVersion, appVersion: $appVersion, buildNumber: $buildNumber, isActive: $isActive, lastActiveAt: $lastActiveAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$UserDeviceModelCopyWith<$Res> implements $UserDeviceModelCopyWith<$Res> {
  factory _$UserDeviceModelCopyWith(_UserDeviceModel value, $Res Function(_UserDeviceModel) _then) = __$UserDeviceModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'device_identifier') String deviceIdentifier, String platform,@JsonKey(name: 'fcm_token') String? fcmToken,@JsonKey(name: 'device_model') String? deviceModel,@JsonKey(name: 'os_version') String? osVersion,@JsonKey(name: 'app_version') String? appVersion,@JsonKey(name: 'build_number') int buildNumber,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'last_active_at') DateTime? lastActiveAt,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt
});




}
/// @nodoc
class __$UserDeviceModelCopyWithImpl<$Res>
    implements _$UserDeviceModelCopyWith<$Res> {
  __$UserDeviceModelCopyWithImpl(this._self, this._then);

  final _UserDeviceModel _self;
  final $Res Function(_UserDeviceModel) _then;

/// Create a copy of UserDeviceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? deviceIdentifier = null,Object? platform = null,Object? fcmToken = freezed,Object? deviceModel = freezed,Object? osVersion = freezed,Object? appVersion = freezed,Object? buildNumber = null,Object? isActive = null,Object? lastActiveAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_UserDeviceModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,deviceIdentifier: null == deviceIdentifier ? _self.deviceIdentifier : deviceIdentifier // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,fcmToken: freezed == fcmToken ? _self.fcmToken : fcmToken // ignore: cast_nullable_to_non_nullable
as String?,deviceModel: freezed == deviceModel ? _self.deviceModel : deviceModel // ignore: cast_nullable_to_non_nullable
as String?,osVersion: freezed == osVersion ? _self.osVersion : osVersion // ignore: cast_nullable_to_non_nullable
as String?,appVersion: freezed == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String?,buildNumber: null == buildNumber ? _self.buildNumber : buildNumber // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,lastActiveAt: freezed == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
