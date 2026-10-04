// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'startup_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StartupState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is StartupState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'StartupState()';
}


}

/// @nodoc
class $StartupStateCopyWith<$Res>  {
$StartupStateCopyWith(StartupState _, $Res Function(StartupState) __);
}


/// Adds pattern-matching-related methods to [StartupState].
extension StartupStatePatterns on StartupState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _MaintenanceMode value)?  maintenanceMode,TResult Function( _UpdateRequired value)?  updateRequired,TResult Function( _Success value)?  success,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _MaintenanceMode() when maintenanceMode != null:
return maintenanceMode(_that);case _UpdateRequired() when updateRequired != null:
return updateRequired(_that);case _Success() when success != null:
return success(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _MaintenanceMode value)  maintenanceMode,required TResult Function( _UpdateRequired value)  updateRequired,required TResult Function( _Success value)  success,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _MaintenanceMode():
return maintenanceMode(_that);case _UpdateRequired():
return updateRequired(_that);case _Success():
return success(_that);case _Error():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _MaintenanceMode value)?  maintenanceMode,TResult? Function( _UpdateRequired value)?  updateRequired,TResult? Function( _Success value)?  success,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _MaintenanceMode() when maintenanceMode != null:
return maintenanceMode(_that);case _UpdateRequired() when updateRequired != null:
return updateRequired(_that);case _Success() when success != null:
return success(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( String title,  String message)?  maintenanceMode,TResult Function( VersionMessage messageData,  String storeUrl,  bool isForced,  String? latestVersion)?  updateRequired,TResult Function()?  success,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _MaintenanceMode() when maintenanceMode != null:
return maintenanceMode(_that.title,_that.message);case _UpdateRequired() when updateRequired != null:
return updateRequired(_that.messageData,_that.storeUrl,_that.isForced,_that.latestVersion);case _Success() when success != null:
return success();case _Error() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( String title,  String message)  maintenanceMode,required TResult Function( VersionMessage messageData,  String storeUrl,  bool isForced,  String? latestVersion)  updateRequired,required TResult Function()  success,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _MaintenanceMode():
return maintenanceMode(_that.title,_that.message);case _UpdateRequired():
return updateRequired(_that.messageData,_that.storeUrl,_that.isForced,_that.latestVersion);case _Success():
return success();case _Error():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( String title,  String message)?  maintenanceMode,TResult? Function( VersionMessage messageData,  String storeUrl,  bool isForced,  String? latestVersion)?  updateRequired,TResult? Function()?  success,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _MaintenanceMode() when maintenanceMode != null:
return maintenanceMode(_that.title,_that.message);case _UpdateRequired() when updateRequired != null:
return updateRequired(_that.messageData,_that.storeUrl,_that.isForced,_that.latestVersion);case _Success() when success != null:
return success();case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements StartupState {
  const _Initial();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'StartupState.initial()';
}


}




/// @nodoc


class _Loading implements StartupState {
  const _Loading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'StartupState.loading()';
}


}




/// @nodoc


class _MaintenanceMode implements StartupState {
  const _MaintenanceMode({required this.title, required this.message});
  

 final  String title;
 final  String message;

/// Create a copy of StartupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MaintenanceModeCopyWith<_MaintenanceMode> get copyWith => __$MaintenanceModeCopyWithImpl<_MaintenanceMode>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MaintenanceMode&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,title,message);
}

@override
String toString() {
    return 'StartupState.maintenanceMode(title: $title, message: $message)';
}


}

/// @nodoc
abstract mixin class _$MaintenanceModeCopyWith<$Res> implements $StartupStateCopyWith<$Res> {
  factory _$MaintenanceModeCopyWith(_MaintenanceMode value, $Res Function(_MaintenanceMode) _then) = __$MaintenanceModeCopyWithImpl;
@useResult
$Res call({
 String title, String message
});




}
/// @nodoc
class __$MaintenanceModeCopyWithImpl<$Res>
    implements _$MaintenanceModeCopyWith<$Res> {
  __$MaintenanceModeCopyWithImpl(this._self, this._then);

  final _MaintenanceMode _self;
  final $Res Function(_MaintenanceMode) _then;

/// Create a copy of StartupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? title = null,Object? message = null,}) {
  return _then(_MaintenanceMode(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _UpdateRequired implements StartupState {
  const _UpdateRequired({required this.messageData, required this.storeUrl, required this.isForced, this.latestVersion});
  

 final  VersionMessage messageData;
 final  String storeUrl;
 final  bool isForced;
 final  String? latestVersion;

/// Create a copy of StartupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateRequiredCopyWith<_UpdateRequired> get copyWith => __$UpdateRequiredCopyWithImpl<_UpdateRequired>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateRequired&&(identical(other.messageData, messageData) || other.messageData == messageData)&&(identical(other.storeUrl, storeUrl) || other.storeUrl == storeUrl)&&(identical(other.isForced, isForced) || other.isForced == isForced)&&(identical(other.latestVersion, latestVersion) || other.latestVersion == latestVersion));
}


@override
int get hashCode {
    return Object.hash(runtimeType,messageData,storeUrl,isForced,latestVersion);
}

@override
String toString() {
    return 'StartupState.updateRequired(messageData: $messageData, storeUrl: $storeUrl, isForced: $isForced, latestVersion: $latestVersion)';
}


}

/// @nodoc
abstract mixin class _$UpdateRequiredCopyWith<$Res> implements $StartupStateCopyWith<$Res> {
  factory _$UpdateRequiredCopyWith(_UpdateRequired value, $Res Function(_UpdateRequired) _then) = __$UpdateRequiredCopyWithImpl;
@useResult
$Res call({
 VersionMessage messageData, String storeUrl, bool isForced, String? latestVersion
});




}
/// @nodoc
class __$UpdateRequiredCopyWithImpl<$Res>
    implements _$UpdateRequiredCopyWith<$Res> {
  __$UpdateRequiredCopyWithImpl(this._self, this._then);

  final _UpdateRequired _self;
  final $Res Function(_UpdateRequired) _then;

/// Create a copy of StartupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? messageData = null,Object? storeUrl = null,Object? isForced = null,Object? latestVersion = freezed,}) {
  return _then(_UpdateRequired(
messageData: null == messageData ? _self.messageData : messageData // ignore: cast_nullable_to_non_nullable
as VersionMessage,storeUrl: null == storeUrl ? _self.storeUrl : storeUrl // ignore: cast_nullable_to_non_nullable
as String,isForced: null == isForced ? _self.isForced : isForced // ignore: cast_nullable_to_non_nullable
as bool,latestVersion: freezed == latestVersion ? _self.latestVersion : latestVersion // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _Success implements StartupState {
  const _Success();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Success);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'StartupState.success()';
}


}




/// @nodoc


class _Error implements StartupState {
  const _Error({required this.message});
  

 final  String message;

/// Create a copy of StartupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'StartupState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $StartupStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of StartupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
