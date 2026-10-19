// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_conversation_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatConversationEntity {

 String get conversationId; String get requestId; String? get activityTitle; String get chatType; String? get otherUserId; String? get otherUserName; String? get otherUserAvatarUrl; String? get categoryId; String? get categorySlug; String? get groupAvatarUrl; String? get lastMessage; DateTime? get lastMessageAt; int get unreadCount;
/// Create a copy of ChatConversationEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatConversationEntityCopyWith<ChatConversationEntity> get copyWith => _$ChatConversationEntityCopyWithImpl<ChatConversationEntity>(this as ChatConversationEntity, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ChatConversationEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatConversationEntity&&(identical(other.conversationId, _this.conversationId) || other.conversationId == _this.conversationId)&&(identical(other.requestId, _this.requestId) || other.requestId == _this.requestId)&&(identical(other.activityTitle, _this.activityTitle) || other.activityTitle == _this.activityTitle)&&(identical(other.chatType, _this.chatType) || other.chatType == _this.chatType)&&(identical(other.otherUserId, _this.otherUserId) || other.otherUserId == _this.otherUserId)&&(identical(other.otherUserName, _this.otherUserName) || other.otherUserName == _this.otherUserName)&&(identical(other.otherUserAvatarUrl, _this.otherUserAvatarUrl) || other.otherUserAvatarUrl == _this.otherUserAvatarUrl)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.categorySlug, _this.categorySlug) || other.categorySlug == _this.categorySlug)&&(identical(other.groupAvatarUrl, _this.groupAvatarUrl) || other.groupAvatarUrl == _this.groupAvatarUrl)&&(identical(other.lastMessage, _this.lastMessage) || other.lastMessage == _this.lastMessage)&&(identical(other.lastMessageAt, _this.lastMessageAt) || other.lastMessageAt == _this.lastMessageAt)&&(identical(other.unreadCount, _this.unreadCount) || other.unreadCount == _this.unreadCount));
}


@override
int get hashCode {
  final _this = this as ChatConversationEntity;
  return Object.hash(runtimeType,_this.conversationId,_this.requestId,_this.activityTitle,_this.chatType,_this.otherUserId,_this.otherUserName,_this.otherUserAvatarUrl,_this.categoryId,_this.categorySlug,_this.groupAvatarUrl,_this.lastMessage,_this.lastMessageAt,_this.unreadCount);
}

@override
String toString() {
  final _this = this as ChatConversationEntity;
  return 'ChatConversationEntity(conversationId: ${_this.conversationId}, requestId: ${_this.requestId}, activityTitle: ${_this.activityTitle}, chatType: ${_this.chatType}, otherUserId: ${_this.otherUserId}, otherUserName: ${_this.otherUserName}, otherUserAvatarUrl: ${_this.otherUserAvatarUrl}, categoryId: ${_this.categoryId}, categorySlug: ${_this.categorySlug}, groupAvatarUrl: ${_this.groupAvatarUrl}, lastMessage: ${_this.lastMessage}, lastMessageAt: ${_this.lastMessageAt}, unreadCount: ${_this.unreadCount})';
}


}

/// @nodoc
abstract mixin class $ChatConversationEntityCopyWith<$Res>  {
  factory $ChatConversationEntityCopyWith(ChatConversationEntity value, $Res Function(ChatConversationEntity) _then) = _$ChatConversationEntityCopyWithImpl;
@useResult
$Res call({
 String conversationId, String requestId, String? activityTitle, String chatType, String? otherUserId, String? otherUserName, String? otherUserAvatarUrl, String? categoryId, String? categorySlug, String? groupAvatarUrl, String? lastMessage, DateTime? lastMessageAt, int unreadCount
});




}
/// @nodoc
class _$ChatConversationEntityCopyWithImpl<$Res>
    implements $ChatConversationEntityCopyWith<$Res> {
  _$ChatConversationEntityCopyWithImpl(this._self, this._then);

  final ChatConversationEntity _self;
  final $Res Function(ChatConversationEntity) _then;

/// Create a copy of ChatConversationEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? conversationId = null,Object? requestId = null,Object? activityTitle = freezed,Object? chatType = null,Object? otherUserId = freezed,Object? otherUserName = freezed,Object? otherUserAvatarUrl = freezed,Object? categoryId = freezed,Object? categorySlug = freezed,Object? groupAvatarUrl = freezed,Object? lastMessage = freezed,Object? lastMessageAt = freezed,Object? unreadCount = null,}) {
  return _then(ChatConversationEntity(
conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,activityTitle: freezed == activityTitle ? _self.activityTitle : activityTitle // ignore: cast_nullable_to_non_nullable
as String?,chatType: null == chatType ? _self.chatType : chatType // ignore: cast_nullable_to_non_nullable
as String,otherUserId: freezed == otherUserId ? _self.otherUserId : otherUserId // ignore: cast_nullable_to_non_nullable
as String?,otherUserName: freezed == otherUserName ? _self.otherUserName : otherUserName // ignore: cast_nullable_to_non_nullable
as String?,otherUserAvatarUrl: freezed == otherUserAvatarUrl ? _self.otherUserAvatarUrl : otherUserAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,categorySlug: freezed == categorySlug ? _self.categorySlug : categorySlug // ignore: cast_nullable_to_non_nullable
as String?,groupAvatarUrl: freezed == groupAvatarUrl ? _self.groupAvatarUrl : groupAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as String?,lastMessageAt: freezed == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as DateTime?,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatConversationEntity].
extension ChatConversationEntityPatterns on ChatConversationEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatConversationEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatConversationEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatConversationEntity value)  $default,){
final _that = this;
switch (_that) {
case _ChatConversationEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatConversationEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ChatConversationEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String conversationId,  String requestId,  String? activityTitle,  String chatType,  String? otherUserId,  String? otherUserName,  String? otherUserAvatarUrl,  String? categoryId,  String? categorySlug,  String? groupAvatarUrl,  String? lastMessage,  DateTime? lastMessageAt,  int unreadCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatConversationEntity() when $default != null:
return $default(_that.conversationId,_that.requestId,_that.activityTitle,_that.chatType,_that.otherUserId,_that.otherUserName,_that.otherUserAvatarUrl,_that.categoryId,_that.categorySlug,_that.groupAvatarUrl,_that.lastMessage,_that.lastMessageAt,_that.unreadCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String conversationId,  String requestId,  String? activityTitle,  String chatType,  String? otherUserId,  String? otherUserName,  String? otherUserAvatarUrl,  String? categoryId,  String? categorySlug,  String? groupAvatarUrl,  String? lastMessage,  DateTime? lastMessageAt,  int unreadCount)  $default,) {final _that = this;
switch (_that) {
case _ChatConversationEntity():
return $default(_that.conversationId,_that.requestId,_that.activityTitle,_that.chatType,_that.otherUserId,_that.otherUserName,_that.otherUserAvatarUrl,_that.categoryId,_that.categorySlug,_that.groupAvatarUrl,_that.lastMessage,_that.lastMessageAt,_that.unreadCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String conversationId,  String requestId,  String? activityTitle,  String chatType,  String? otherUserId,  String? otherUserName,  String? otherUserAvatarUrl,  String? categoryId,  String? categorySlug,  String? groupAvatarUrl,  String? lastMessage,  DateTime? lastMessageAt,  int unreadCount)?  $default,) {final _that = this;
switch (_that) {
case _ChatConversationEntity() when $default != null:
return $default(_that.conversationId,_that.requestId,_that.activityTitle,_that.chatType,_that.otherUserId,_that.otherUserName,_that.otherUserAvatarUrl,_that.categoryId,_that.categorySlug,_that.groupAvatarUrl,_that.lastMessage,_that.lastMessageAt,_that.unreadCount);case _:
  return null;

}
}

}

/// @nodoc


class _ChatConversationEntity extends ChatConversationEntity {
  const _ChatConversationEntity({required this.conversationId, required this.requestId, this.activityTitle, required this.chatType, this.otherUserId, this.otherUserName, this.otherUserAvatarUrl, this.categoryId, this.categorySlug, this.groupAvatarUrl, this.lastMessage, this.lastMessageAt, this.unreadCount = 0}): super._();
  

@override final  String conversationId;
@override final  String requestId;
@override final  String? activityTitle;
@override final  String chatType;
@override final  String? otherUserId;
@override final  String? otherUserName;
@override final  String? otherUserAvatarUrl;
@override final  String? categoryId;
@override final  String? categorySlug;
@override final  String? groupAvatarUrl;
@override final  String? lastMessage;
@override final  DateTime? lastMessageAt;
@override@JsonKey() final  int unreadCount;

/// Create a copy of ChatConversationEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatConversationEntityCopyWith<_ChatConversationEntity> get copyWith => __$ChatConversationEntityCopyWithImpl<_ChatConversationEntity>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatConversationEntity&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.activityTitle, activityTitle) || other.activityTitle == activityTitle)&&(identical(other.chatType, chatType) || other.chatType == chatType)&&(identical(other.otherUserId, otherUserId) || other.otherUserId == otherUserId)&&(identical(other.otherUserName, otherUserName) || other.otherUserName == otherUserName)&&(identical(other.otherUserAvatarUrl, otherUserAvatarUrl) || other.otherUserAvatarUrl == otherUserAvatarUrl)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categorySlug, categorySlug) || other.categorySlug == categorySlug)&&(identical(other.groupAvatarUrl, groupAvatarUrl) || other.groupAvatarUrl == groupAvatarUrl)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount));
}


@override
int get hashCode {
    return Object.hash(runtimeType,conversationId,requestId,activityTitle,chatType,otherUserId,otherUserName,otherUserAvatarUrl,categoryId,categorySlug,groupAvatarUrl,lastMessage,lastMessageAt,unreadCount);
}

@override
String toString() {
    return 'ChatConversationEntity(conversationId: $conversationId, requestId: $requestId, activityTitle: $activityTitle, chatType: $chatType, otherUserId: $otherUserId, otherUserName: $otherUserName, otherUserAvatarUrl: $otherUserAvatarUrl, categoryId: $categoryId, categorySlug: $categorySlug, groupAvatarUrl: $groupAvatarUrl, lastMessage: $lastMessage, lastMessageAt: $lastMessageAt, unreadCount: $unreadCount)';
}


}

/// @nodoc
abstract mixin class _$ChatConversationEntityCopyWith<$Res> implements $ChatConversationEntityCopyWith<$Res> {
  factory _$ChatConversationEntityCopyWith(_ChatConversationEntity value, $Res Function(_ChatConversationEntity) _then) = __$ChatConversationEntityCopyWithImpl;
@override @useResult
$Res call({
 String conversationId, String requestId, String? activityTitle, String chatType, String? otherUserId, String? otherUserName, String? otherUserAvatarUrl, String? categoryId, String? categorySlug, String? groupAvatarUrl, String? lastMessage, DateTime? lastMessageAt, int unreadCount
});




}
/// @nodoc
class __$ChatConversationEntityCopyWithImpl<$Res>
    implements _$ChatConversationEntityCopyWith<$Res> {
  __$ChatConversationEntityCopyWithImpl(this._self, this._then);

  final _ChatConversationEntity _self;
  final $Res Function(_ChatConversationEntity) _then;

/// Create a copy of ChatConversationEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? conversationId = null,Object? requestId = null,Object? activityTitle = freezed,Object? chatType = null,Object? otherUserId = freezed,Object? otherUserName = freezed,Object? otherUserAvatarUrl = freezed,Object? categoryId = freezed,Object? categorySlug = freezed,Object? groupAvatarUrl = freezed,Object? lastMessage = freezed,Object? lastMessageAt = freezed,Object? unreadCount = null,}) {
  return _then(_ChatConversationEntity(
conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as String,requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,activityTitle: freezed == activityTitle ? _self.activityTitle : activityTitle // ignore: cast_nullable_to_non_nullable
as String?,chatType: null == chatType ? _self.chatType : chatType // ignore: cast_nullable_to_non_nullable
as String,otherUserId: freezed == otherUserId ? _self.otherUserId : otherUserId // ignore: cast_nullable_to_non_nullable
as String?,otherUserName: freezed == otherUserName ? _self.otherUserName : otherUserName // ignore: cast_nullable_to_non_nullable
as String?,otherUserAvatarUrl: freezed == otherUserAvatarUrl ? _self.otherUserAvatarUrl : otherUserAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,categorySlug: freezed == categorySlug ? _self.categorySlug : categorySlug // ignore: cast_nullable_to_non_nullable
as String?,groupAvatarUrl: freezed == groupAvatarUrl ? _self.groupAvatarUrl : groupAvatarUrl // ignore: cast_nullable_to_non_nullable
as String?,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as String?,lastMessageAt: freezed == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as DateTime?,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
