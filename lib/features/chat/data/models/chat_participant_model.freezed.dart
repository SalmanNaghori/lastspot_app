// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_participant_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatParticipantModel {

 String get id;@JsonKey(name: 'conversation_id') String get conversationId;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'joined_at') DateTime? get joinedAt;@JsonKey(name: 'user_name') String? get userName;@JsonKey(name: 'avatar_url') String? get avatarUrl;
/// Create a copy of ChatParticipantModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatParticipantModelCopyWith<ChatParticipantModel> get copyWith => _$ChatParticipantModelCopyWithImpl<ChatParticipantModel>(this as ChatParticipantModel, _$identity);

  /// Serializes this ChatParticipantModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatParticipantModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatParticipantModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.conversationId, _this.conversationId) || other.conversationId == _this.conversationId)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.joinedAt, _this.joinedAt) || other.joinedAt == _this.joinedAt)&&(identical(other.userName, _this.userName) || other.userName == _this.userName)&&(identical(other.avatarUrl, _this.avatarUrl) || other.avatarUrl == _this.avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatParticipantModel;
  return Object.hash(runtimeType,_this.id,_this.conversationId,_this.userId,_this.joinedAt,_this.userName,_this.avatarUrl);
}

@override
String toString() {
  final _this = this as ChatParticipantModel;
  return 'ChatParticipantModel(id: ${_this.id}, conversationId: ${_this.conversationId}, userId: ${_this.userId}, joinedAt: ${_this.joinedAt}, userName: ${_this.userName}, avatarUrl: ${_this.avatarUrl})';
}


}

/// @nodoc
abstract mixin class $ChatParticipantModelCopyWith<$Res>  {
  factory $ChatParticipantModelCopyWith(ChatParticipantModel value, $Res Function(ChatParticipantModel) _then) = _$ChatParticipantModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'conversation_id') String conversationId,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'joined_at') DateTime? joinedAt,@JsonKey(name: 'user_name') String? userName,@JsonKey(name: 'avatar_url') String? avatarUrl
});




}
/// @nodoc
class _$ChatParticipantModelCopyWithImpl<$Res>
    implements $ChatParticipantModelCopyWith<$Res> {
  _$ChatParticipantModelCopyWithImpl(this._self, this._then);

  final ChatParticipantModel _self;
  final $Res Function(ChatParticipantModel) _then;

/// Create a copy of ChatParticipantModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? conversationId = null,Object? userId = null,Object? joinedAt = freezed,Object? userName = freezed,Object? avatarUrl = freezed,}) {
  return _then(ChatParticipantModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,joinedAt: freezed == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatParticipantModel].
extension ChatParticipantModelPatterns on ChatParticipantModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatParticipantModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatParticipantModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatParticipantModel value)  $default,){
final _that = this;
switch (_that) {
case _ChatParticipantModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatParticipantModel value)?  $default,){
final _that = this;
switch (_that) {
case _ChatParticipantModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'conversation_id')  String conversationId, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'joined_at')  DateTime? joinedAt, @JsonKey(name: 'user_name')  String? userName, @JsonKey(name: 'avatar_url')  String? avatarUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatParticipantModel() when $default != null:
return $default(_that.id,_that.conversationId,_that.userId,_that.joinedAt,_that.userName,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'conversation_id')  String conversationId, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'joined_at')  DateTime? joinedAt, @JsonKey(name: 'user_name')  String? userName, @JsonKey(name: 'avatar_url')  String? avatarUrl)  $default,) {final _that = this;
switch (_that) {
case _ChatParticipantModel():
return $default(_that.id,_that.conversationId,_that.userId,_that.joinedAt,_that.userName,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'conversation_id')  String conversationId, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'joined_at')  DateTime? joinedAt, @JsonKey(name: 'user_name')  String? userName, @JsonKey(name: 'avatar_url')  String? avatarUrl)?  $default,) {final _that = this;
switch (_that) {
case _ChatParticipantModel() when $default != null:
return $default(_that.id,_that.conversationId,_that.userId,_that.joinedAt,_that.userName,_that.avatarUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatParticipantModel implements ChatParticipantModel {
  const _ChatParticipantModel({required this.id, @JsonKey(name: 'conversation_id') required this.conversationId, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'joined_at') this.joinedAt, @JsonKey(name: 'user_name') this.userName, @JsonKey(name: 'avatar_url') this.avatarUrl});
  factory _ChatParticipantModel.fromJson(Map<String, dynamic> json) => _$ChatParticipantModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'conversation_id') final  String conversationId;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'joined_at') final  DateTime? joinedAt;
@override@JsonKey(name: 'user_name') final  String? userName;
@override@JsonKey(name: 'avatar_url') final  String? avatarUrl;

/// Create a copy of ChatParticipantModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatParticipantModelCopyWith<_ChatParticipantModel> get copyWith => __$ChatParticipantModelCopyWithImpl<_ChatParticipantModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatParticipantModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatParticipantModel&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,conversationId,userId,joinedAt,userName,avatarUrl);
}

@override
String toString() {
    return 'ChatParticipantModel(id: $id, conversationId: $conversationId, userId: $userId, joinedAt: $joinedAt, userName: $userName, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class _$ChatParticipantModelCopyWith<$Res> implements $ChatParticipantModelCopyWith<$Res> {
  factory _$ChatParticipantModelCopyWith(_ChatParticipantModel value, $Res Function(_ChatParticipantModel) _then) = __$ChatParticipantModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'conversation_id') String conversationId,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'joined_at') DateTime? joinedAt,@JsonKey(name: 'user_name') String? userName,@JsonKey(name: 'avatar_url') String? avatarUrl
});




}
/// @nodoc
class __$ChatParticipantModelCopyWithImpl<$Res>
    implements _$ChatParticipantModelCopyWith<$Res> {
  __$ChatParticipantModelCopyWithImpl(this._self, this._then);

  final _ChatParticipantModel _self;
  final $Res Function(_ChatParticipantModel) _then;

/// Create a copy of ChatParticipantModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? conversationId = null,Object? userId = null,Object? joinedAt = freezed,Object? userName = freezed,Object? avatarUrl = freezed,}) {
  return _then(_ChatParticipantModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,joinedAt: freezed == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,userName: freezed == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
