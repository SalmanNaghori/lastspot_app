// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_image_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RequestImageModel {

@JsonKey(defaultValue: '') String get id;@JsonKey(name: 'request_id', defaultValue: '') String get requestId;@JsonKey(name: 'storage_path', defaultValue: '') String get storagePath;@JsonKey(name: 'sort_order', fromJson: _intValue) int get sortOrder;@JsonKey(name: 'created_at', fromJson: _dateValue) DateTime get createdAt;
/// Create a copy of RequestImageModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestImageModelCopyWith<RequestImageModel> get copyWith => _$RequestImageModelCopyWithImpl<RequestImageModel>(this as RequestImageModel, _$identity);

  /// Serializes this RequestImageModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RequestImageModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestImageModel&&super == other&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.requestId, _this.requestId) || other.requestId == _this.requestId)&&(identical(other.storagePath, _this.storagePath) || other.storagePath == _this.storagePath)&&(identical(other.sortOrder, _this.sortOrder) || other.sortOrder == _this.sortOrder)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RequestImageModel;
  return Object.hash(runtimeType,super.hashCode,_this.id,_this.requestId,_this.storagePath,_this.sortOrder,_this.createdAt);
}



}

/// @nodoc
abstract mixin class $RequestImageModelCopyWith<$Res>  {
  factory $RequestImageModelCopyWith(RequestImageModel value, $Res Function(RequestImageModel) _then) = _$RequestImageModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(defaultValue: '') String id,@JsonKey(name: 'request_id', defaultValue: '') String requestId,@JsonKey(name: 'storage_path', defaultValue: '') String storagePath,@JsonKey(name: 'sort_order', fromJson: _intValue) int sortOrder,@JsonKey(name: 'created_at', fromJson: _dateValue) DateTime createdAt
});




}
/// @nodoc
class _$RequestImageModelCopyWithImpl<$Res>
    implements $RequestImageModelCopyWith<$Res> {
  _$RequestImageModelCopyWithImpl(this._self, this._then);

  final RequestImageModel _self;
  final $Res Function(RequestImageModel) _then;

/// Create a copy of RequestImageModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? requestId = null,Object? storagePath = null,Object? sortOrder = null,Object? createdAt = null,}) {
  return _then(RequestImageModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,storagePath: null == storagePath ? _self.storagePath : storagePath // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [RequestImageModel].
extension RequestImageModelPatterns on RequestImageModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RequestImageModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RequestImageModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RequestImageModel value)  $default,){
final _that = this;
switch (_that) {
case _RequestImageModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RequestImageModel value)?  $default,){
final _that = this;
switch (_that) {
case _RequestImageModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String id, @JsonKey(name: 'request_id', defaultValue: '')  String requestId, @JsonKey(name: 'storage_path', defaultValue: '')  String storagePath, @JsonKey(name: 'sort_order', fromJson: _intValue)  int sortOrder, @JsonKey(name: 'created_at', fromJson: _dateValue)  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RequestImageModel() when $default != null:
return $default(_that.id,_that.requestId,_that.storagePath,_that.sortOrder,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: '')  String id, @JsonKey(name: 'request_id', defaultValue: '')  String requestId, @JsonKey(name: 'storage_path', defaultValue: '')  String storagePath, @JsonKey(name: 'sort_order', fromJson: _intValue)  int sortOrder, @JsonKey(name: 'created_at', fromJson: _dateValue)  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _RequestImageModel():
return $default(_that.id,_that.requestId,_that.storagePath,_that.sortOrder,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(defaultValue: '')  String id, @JsonKey(name: 'request_id', defaultValue: '')  String requestId, @JsonKey(name: 'storage_path', defaultValue: '')  String storagePath, @JsonKey(name: 'sort_order', fromJson: _intValue)  int sortOrder, @JsonKey(name: 'created_at', fromJson: _dateValue)  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _RequestImageModel() when $default != null:
return $default(_that.id,_that.requestId,_that.storagePath,_that.sortOrder,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RequestImageModel extends RequestImageModel {
  const _RequestImageModel({@JsonKey(defaultValue: '') required this.id, @JsonKey(name: 'request_id', defaultValue: '') required this.requestId, @JsonKey(name: 'storage_path', defaultValue: '') required this.storagePath, @JsonKey(name: 'sort_order', fromJson: _intValue) required this.sortOrder, @JsonKey(name: 'created_at', fromJson: _dateValue) required this.createdAt}): super._();
  factory _RequestImageModel.fromJson(Map<String, dynamic> json) => _$RequestImageModelFromJson(json);

@override@JsonKey(defaultValue: '') final  String id;
@override@JsonKey(name: 'request_id', defaultValue: '') final  String requestId;
@override@JsonKey(name: 'storage_path', defaultValue: '') final  String storagePath;
@override@JsonKey(name: 'sort_order', fromJson: _intValue) final  int sortOrder;
@override@JsonKey(name: 'created_at', fromJson: _dateValue) final  DateTime createdAt;

/// Create a copy of RequestImageModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequestImageModelCopyWith<_RequestImageModel> get copyWith => __$RequestImageModelCopyWithImpl<_RequestImageModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RequestImageModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequestImageModel&&super == other&&(identical(other.id, id) || other.id == id)&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.storagePath, storagePath) || other.storagePath == storagePath)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,super.hashCode,id,requestId,storagePath,sortOrder,createdAt);
}



}

/// @nodoc
abstract mixin class _$RequestImageModelCopyWith<$Res> implements $RequestImageModelCopyWith<$Res> {
  factory _$RequestImageModelCopyWith(_RequestImageModel value, $Res Function(_RequestImageModel) _then) = __$RequestImageModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(defaultValue: '') String id,@JsonKey(name: 'request_id', defaultValue: '') String requestId,@JsonKey(name: 'storage_path', defaultValue: '') String storagePath,@JsonKey(name: 'sort_order', fromJson: _intValue) int sortOrder,@JsonKey(name: 'created_at', fromJson: _dateValue) DateTime createdAt
});




}
/// @nodoc
class __$RequestImageModelCopyWithImpl<$Res>
    implements _$RequestImageModelCopyWith<$Res> {
  __$RequestImageModelCopyWithImpl(this._self, this._then);

  final _RequestImageModel _self;
  final $Res Function(_RequestImageModel) _then;

/// Create a copy of RequestImageModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? requestId = null,Object? storagePath = null,Object? sortOrder = null,Object? createdAt = null,}) {
  return _then(_RequestImageModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,storagePath: null == storagePath ? _self.storagePath : storagePath // ignore: cast_nullable_to_non_nullable
as String,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
