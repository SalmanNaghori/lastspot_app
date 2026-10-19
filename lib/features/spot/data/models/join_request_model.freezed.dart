// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'join_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JoinRequestModel {

 String get id;@JsonKey(name: 'request_id') String get requestId;@JsonKey(name: 'user_id') String get userId; JoinRequestStatus get status; String? get message;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(includeToJson: false, includeFromJson: false) UserProfile? get userProfile;@JsonKey(includeToJson: false, includeFromJson: false) RequestEntity? get request;
/// Create a copy of JoinRequestModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JoinRequestModelCopyWith<JoinRequestModel> get copyWith => _$JoinRequestModelCopyWithImpl<JoinRequestModel>(this as JoinRequestModel, _$identity);

  /// Serializes this JoinRequestModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as JoinRequestModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JoinRequestModel&&super == other&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.requestId, _this.requestId) || other.requestId == _this.requestId)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.message, _this.message) || other.message == _this.message)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.userProfile, _this.userProfile) || other.userProfile == _this.userProfile)&&(identical(other.request, _this.request) || other.request == _this.request));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as JoinRequestModel;
  return Object.hash(runtimeType,super.hashCode,_this.id,_this.requestId,_this.userId,_this.status,_this.message,_this.createdAt,_this.userProfile,_this.request);
}



}

/// @nodoc
abstract mixin class $JoinRequestModelCopyWith<$Res>  {
  factory $JoinRequestModelCopyWith(JoinRequestModel value, $Res Function(JoinRequestModel) _then) = _$JoinRequestModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'request_id') String requestId,@JsonKey(name: 'user_id') String userId, JoinRequestStatus status, String? message,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(includeToJson: false, includeFromJson: false) UserProfile? userProfile,@JsonKey(includeToJson: false, includeFromJson: false) RequestEntity? request
});


$UserProfileCopyWith<$Res>? get userProfile;

}
/// @nodoc
class _$JoinRequestModelCopyWithImpl<$Res>
    implements $JoinRequestModelCopyWith<$Res> {
  _$JoinRequestModelCopyWithImpl(this._self, this._then);

  final JoinRequestModel _self;
  final $Res Function(JoinRequestModel) _then;

/// Create a copy of JoinRequestModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? requestId = null,Object? userId = null,Object? status = null,Object? message = freezed,Object? createdAt = null,Object? userProfile = freezed,Object? request = freezed,}) {
  return _then(JoinRequestModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as JoinRequestStatus,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,userProfile: freezed == userProfile ? _self.userProfile : userProfile // ignore: cast_nullable_to_non_nullable
as UserProfile?,request: freezed == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as RequestEntity?,
  ));
}
/// Create a copy of JoinRequestModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserProfileCopyWith<$Res>? get userProfile {
    if (_self.userProfile == null) {
    return null;
  }

  return $UserProfileCopyWith<$Res>(_self.userProfile!, (value) {
    return _then(_self.copyWith(userProfile: value));
  });
}
}


/// Adds pattern-matching-related methods to [JoinRequestModel].
extension JoinRequestModelPatterns on JoinRequestModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JoinRequestModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JoinRequestModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JoinRequestModel value)  $default,){
final _that = this;
switch (_that) {
case _JoinRequestModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JoinRequestModel value)?  $default,){
final _that = this;
switch (_that) {
case _JoinRequestModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'request_id')  String requestId, @JsonKey(name: 'user_id')  String userId,  JoinRequestStatus status,  String? message, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(includeToJson: false, includeFromJson: false)  UserProfile? userProfile, @JsonKey(includeToJson: false, includeFromJson: false)  RequestEntity? request)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JoinRequestModel() when $default != null:
return $default(_that.id,_that.requestId,_that.userId,_that.status,_that.message,_that.createdAt,_that.userProfile,_that.request);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'request_id')  String requestId, @JsonKey(name: 'user_id')  String userId,  JoinRequestStatus status,  String? message, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(includeToJson: false, includeFromJson: false)  UserProfile? userProfile, @JsonKey(includeToJson: false, includeFromJson: false)  RequestEntity? request)  $default,) {final _that = this;
switch (_that) {
case _JoinRequestModel():
return $default(_that.id,_that.requestId,_that.userId,_that.status,_that.message,_that.createdAt,_that.userProfile,_that.request);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'request_id')  String requestId, @JsonKey(name: 'user_id')  String userId,  JoinRequestStatus status,  String? message, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(includeToJson: false, includeFromJson: false)  UserProfile? userProfile, @JsonKey(includeToJson: false, includeFromJson: false)  RequestEntity? request)?  $default,) {final _that = this;
switch (_that) {
case _JoinRequestModel() when $default != null:
return $default(_that.id,_that.requestId,_that.userId,_that.status,_that.message,_that.createdAt,_that.userProfile,_that.request);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createFactory: false)

class _JoinRequestModel extends JoinRequestModel {
  const _JoinRequestModel({required this.id, @JsonKey(name: 'request_id') required this.requestId, @JsonKey(name: 'user_id') required this.userId, this.status = JoinRequestStatus.pending, this.message, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(includeToJson: false, includeFromJson: false) this.userProfile, @JsonKey(includeToJson: false, includeFromJson: false) this.request}): super._();
  

@override final  String id;
@override@JsonKey(name: 'request_id') final  String requestId;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey() final  JoinRequestStatus status;
@override final  String? message;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  UserProfile? userProfile;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  RequestEntity? request;

/// Create a copy of JoinRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JoinRequestModelCopyWith<_JoinRequestModel> get copyWith => __$JoinRequestModelCopyWithImpl<_JoinRequestModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JoinRequestModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _JoinRequestModel&&super == other&&(identical(other.id, id) || other.id == id)&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.status, status) || other.status == status)&&(identical(other.message, message) || other.message == message)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.userProfile, userProfile) || other.userProfile == userProfile)&&(identical(other.request, request) || other.request == request));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,super.hashCode,id,requestId,userId,status,message,createdAt,userProfile,request);
}



}

/// @nodoc
abstract mixin class _$JoinRequestModelCopyWith<$Res> implements $JoinRequestModelCopyWith<$Res> {
  factory _$JoinRequestModelCopyWith(_JoinRequestModel value, $Res Function(_JoinRequestModel) _then) = __$JoinRequestModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'request_id') String requestId,@JsonKey(name: 'user_id') String userId, JoinRequestStatus status, String? message,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(includeToJson: false, includeFromJson: false) UserProfile? userProfile,@JsonKey(includeToJson: false, includeFromJson: false) RequestEntity? request
});


@override $UserProfileCopyWith<$Res>? get userProfile;

}
/// @nodoc
class __$JoinRequestModelCopyWithImpl<$Res>
    implements _$JoinRequestModelCopyWith<$Res> {
  __$JoinRequestModelCopyWithImpl(this._self, this._then);

  final _JoinRequestModel _self;
  final $Res Function(_JoinRequestModel) _then;

/// Create a copy of JoinRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? requestId = null,Object? userId = null,Object? status = null,Object? message = freezed,Object? createdAt = null,Object? userProfile = freezed,Object? request = freezed,}) {
  return _then(_JoinRequestModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as JoinRequestStatus,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,userProfile: freezed == userProfile ? _self.userProfile : userProfile // ignore: cast_nullable_to_non_nullable
as UserProfile?,request: freezed == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as RequestEntity?,
  ));
}

/// Create a copy of JoinRequestModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserProfileCopyWith<$Res>? get userProfile {
    if (_self.userProfile == null) {
    return null;
  }

  return $UserProfileCopyWith<$Res>(_self.userProfile!, (value) {
    return _then(_self.copyWith(userProfile: value));
  });
}
}

// dart format on
