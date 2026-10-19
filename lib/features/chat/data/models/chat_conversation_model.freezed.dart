// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_conversation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatConversationModel {

@JsonKey(name: 'conversation_id', readValue: _readConversationId) String get conversationId;@JsonKey(name: 'request_id', fromJson: _stringFromJson) String get requestId;@JsonKey(name: 'activity_title', readValue: _readActivityTitle, fromJson: _nullableStringFromJson) String? get activityTitle;@JsonKey(name: 'chat_type', fromJson: _chatTypeFromJson) String get chatType;@JsonKey(name: 'other_user_id', fromJson: _nullableStringFromJson) String? get otherUserId;@JsonKey(name: 'other_user_name', fromJson: _nullableStringFromJson) String? get otherUserName;@JsonKey(name: 'other_user_avatar_url', readValue: _readAvatarUrl, fromJson: _nullableStringFromJson) String? get otherUserAvatarUrl;@JsonKey(name: 'category_id', fromJson: _nullableStringFromJson) String? get categoryId;@JsonKey(name: 'category_slug', fromJson: _nullableStringFromJson) String? get categorySlug;@JsonKey(name: 'group_avatar_url', fromJson: _nullableStringFromJson) String? get groupAvatarUrl;@JsonKey(name: 'last_message', fromJson: _nullableStringFromJson) String? get lastMessage;@JsonKey(name: 'last_message_at', fromJson: _dateTimeFromJson) DateTime? get lastMessageAt;@JsonKey(name: 'unread_count', fromJson: _intFromJson) int get unreadCount;
/// Create a copy of ChatConversationModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatConversationModelCopyWith<ChatConversationModel> get copyWith => _$ChatConversationModelCopyWithImpl<ChatConversationModel>(this as ChatConversationModel, _$identity);

  /// Serializes this ChatConversationModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChatConversationModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatConversationModel&&(identical(other.conversationId, _this.conversationId) || other.conversationId == _this.conversationId)&&(identical(other.requestId, _this.requestId) || other.requestId == _this.requestId)&&(identical(other.activityTitle, _this.activityTitle) || other.activityTitle == _this.activityTitle)&&(identical(other.chatType, _this.chatType) || other.chatType == _this.chatType)&&(identical(other.otherUserId, _this.otherUserId) || other.otherUserId == _this.otherUserId)&&(identical(other.otherUserName, _this.otherUserName) || other.otherUserName == _this.otherUserName)&&(identical(other.otherUserAvatarUrl, _this.otherUserAvatarUrl) || other.otherUserAvatarUrl == _this.otherUserAvatarUrl)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.categorySlug, _this.categorySlug) || other.categorySlug == _this.categorySlug)&&(identical(other.groupAvatarUrl, _this.groupAvatarUrl) || other.groupAvatarUrl == _this.groupAvatarUrl)&&(identical(other.lastMessage, _this.lastMessage) || other.lastMessage == _this.lastMessage)&&(identical(other.lastMessageAt, _this.lastMessageAt) || other.lastMessageAt == _this.lastMessageAt)&&(identical(other.unreadCount, _this.unreadCount) || other.unreadCount == _this.unreadCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChatConversationModel;
  return Object.hash(runtimeType,_this.conversationId,_this.requestId,_this.activityTitle,_this.chatType,_this.otherUserId,_this.otherUserName,_this.otherUserAvatarUrl,_this.categoryId,_this.categorySlug,_this.groupAvatarUrl,_this.lastMessage,_this.lastMessageAt,_this.unreadCount);
}

@override
String toString() {
  final _this = this as ChatConversationModel;
  return 'ChatConversationModel(conversationId: ${_this.conversationId}, requestId: ${_this.requestId}, activityTitle: ${_this.activityTitle}, chatType: ${_this.chatType}, otherUserId: ${_this.otherUserId}, otherUserName: ${_this.otherUserName}, otherUserAvatarUrl: ${_this.otherUserAvatarUrl}, categoryId: ${_this.categoryId}, categorySlug: ${_this.categorySlug}, groupAvatarUrl: ${_this.groupAvatarUrl}, lastMessage: ${_this.lastMessage}, lastMessageAt: ${_this.lastMessageAt}, unreadCount: ${_this.unreadCount})';
}


}

/// @nodoc
abstract mixin class $ChatConversationModelCopyWith<$Res>  {
  factory $ChatConversationModelCopyWith(ChatConversationModel value, $Res Function(ChatConversationModel) _then) = _$ChatConversationModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'conversation_id', readValue: _readConversationId) String conversationId,@JsonKey(name: 'request_id', fromJson: _stringFromJson) String requestId,@JsonKey(name: 'activity_title', readValue: _readActivityTitle, fromJson: _nullableStringFromJson) String? activityTitle,@JsonKey(name: 'chat_type', fromJson: _chatTypeFromJson) String chatType,@JsonKey(name: 'other_user_id', fromJson: _nullableStringFromJson) String? otherUserId,@JsonKey(name: 'other_user_name', fromJson: _nullableStringFromJson) String? otherUserName,@JsonKey(name: 'other_user_avatar_url', readValue: _readAvatarUrl, fromJson: _nullableStringFromJson) String? otherUserAvatarUrl,@JsonKey(name: 'category_id', fromJson: _nullableStringFromJson) String? categoryId,@JsonKey(name: 'category_slug', fromJson: _nullableStringFromJson) String? categorySlug,@JsonKey(name: 'group_avatar_url', fromJson: _nullableStringFromJson) String? groupAvatarUrl,@JsonKey(name: 'last_message', fromJson: _nullableStringFromJson) String? lastMessage,@JsonKey(name: 'last_message_at', fromJson: _dateTimeFromJson) DateTime? lastMessageAt,@JsonKey(name: 'unread_count', fromJson: _intFromJson) int unreadCount
});




}
/// @nodoc
class _$ChatConversationModelCopyWithImpl<$Res>
    implements $ChatConversationModelCopyWith<$Res> {
  _$ChatConversationModelCopyWithImpl(this._self, this._then);

  final ChatConversationModel _self;
  final $Res Function(ChatConversationModel) _then;

/// Create a copy of ChatConversationModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? conversationId = null,Object? requestId = null,Object? activityTitle = freezed,Object? chatType = null,Object? otherUserId = freezed,Object? otherUserName = freezed,Object? otherUserAvatarUrl = freezed,Object? categoryId = freezed,Object? categorySlug = freezed,Object? groupAvatarUrl = freezed,Object? lastMessage = freezed,Object? lastMessageAt = freezed,Object? unreadCount = null,}) {
  return _then(ChatConversationModel(
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


/// Adds pattern-matching-related methods to [ChatConversationModel].
extension ChatConversationModelPatterns on ChatConversationModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatConversationModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatConversationModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatConversationModel value)  $default,){
final _that = this;
switch (_that) {
case _ChatConversationModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatConversationModel value)?  $default,){
final _that = this;
switch (_that) {
case _ChatConversationModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'conversation_id', readValue: _readConversationId)  String conversationId, @JsonKey(name: 'request_id', fromJson: _stringFromJson)  String requestId, @JsonKey(name: 'activity_title', readValue: _readActivityTitle, fromJson: _nullableStringFromJson)  String? activityTitle, @JsonKey(name: 'chat_type', fromJson: _chatTypeFromJson)  String chatType, @JsonKey(name: 'other_user_id', fromJson: _nullableStringFromJson)  String? otherUserId, @JsonKey(name: 'other_user_name', fromJson: _nullableStringFromJson)  String? otherUserName, @JsonKey(name: 'other_user_avatar_url', readValue: _readAvatarUrl, fromJson: _nullableStringFromJson)  String? otherUserAvatarUrl, @JsonKey(name: 'category_id', fromJson: _nullableStringFromJson)  String? categoryId, @JsonKey(name: 'category_slug', fromJson: _nullableStringFromJson)  String? categorySlug, @JsonKey(name: 'group_avatar_url', fromJson: _nullableStringFromJson)  String? groupAvatarUrl, @JsonKey(name: 'last_message', fromJson: _nullableStringFromJson)  String? lastMessage, @JsonKey(name: 'last_message_at', fromJson: _dateTimeFromJson)  DateTime? lastMessageAt, @JsonKey(name: 'unread_count', fromJson: _intFromJson)  int unreadCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatConversationModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'conversation_id', readValue: _readConversationId)  String conversationId, @JsonKey(name: 'request_id', fromJson: _stringFromJson)  String requestId, @JsonKey(name: 'activity_title', readValue: _readActivityTitle, fromJson: _nullableStringFromJson)  String? activityTitle, @JsonKey(name: 'chat_type', fromJson: _chatTypeFromJson)  String chatType, @JsonKey(name: 'other_user_id', fromJson: _nullableStringFromJson)  String? otherUserId, @JsonKey(name: 'other_user_name', fromJson: _nullableStringFromJson)  String? otherUserName, @JsonKey(name: 'other_user_avatar_url', readValue: _readAvatarUrl, fromJson: _nullableStringFromJson)  String? otherUserAvatarUrl, @JsonKey(name: 'category_id', fromJson: _nullableStringFromJson)  String? categoryId, @JsonKey(name: 'category_slug', fromJson: _nullableStringFromJson)  String? categorySlug, @JsonKey(name: 'group_avatar_url', fromJson: _nullableStringFromJson)  String? groupAvatarUrl, @JsonKey(name: 'last_message', fromJson: _nullableStringFromJson)  String? lastMessage, @JsonKey(name: 'last_message_at', fromJson: _dateTimeFromJson)  DateTime? lastMessageAt, @JsonKey(name: 'unread_count', fromJson: _intFromJson)  int unreadCount)  $default,) {final _that = this;
switch (_that) {
case _ChatConversationModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'conversation_id', readValue: _readConversationId)  String conversationId, @JsonKey(name: 'request_id', fromJson: _stringFromJson)  String requestId, @JsonKey(name: 'activity_title', readValue: _readActivityTitle, fromJson: _nullableStringFromJson)  String? activityTitle, @JsonKey(name: 'chat_type', fromJson: _chatTypeFromJson)  String chatType, @JsonKey(name: 'other_user_id', fromJson: _nullableStringFromJson)  String? otherUserId, @JsonKey(name: 'other_user_name', fromJson: _nullableStringFromJson)  String? otherUserName, @JsonKey(name: 'other_user_avatar_url', readValue: _readAvatarUrl, fromJson: _nullableStringFromJson)  String? otherUserAvatarUrl, @JsonKey(name: 'category_id', fromJson: _nullableStringFromJson)  String? categoryId, @JsonKey(name: 'category_slug', fromJson: _nullableStringFromJson)  String? categorySlug, @JsonKey(name: 'group_avatar_url', fromJson: _nullableStringFromJson)  String? groupAvatarUrl, @JsonKey(name: 'last_message', fromJson: _nullableStringFromJson)  String? lastMessage, @JsonKey(name: 'last_message_at', fromJson: _dateTimeFromJson)  DateTime? lastMessageAt, @JsonKey(name: 'unread_count', fromJson: _intFromJson)  int unreadCount)?  $default,) {final _that = this;
switch (_that) {
case _ChatConversationModel() when $default != null:
return $default(_that.conversationId,_that.requestId,_that.activityTitle,_that.chatType,_that.otherUserId,_that.otherUserName,_that.otherUserAvatarUrl,_that.categoryId,_that.categorySlug,_that.groupAvatarUrl,_that.lastMessage,_that.lastMessageAt,_that.unreadCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatConversationModel extends ChatConversationModel {
  const _ChatConversationModel({@JsonKey(name: 'conversation_id', readValue: _readConversationId) required this.conversationId, @JsonKey(name: 'request_id', fromJson: _stringFromJson) required this.requestId, @JsonKey(name: 'activity_title', readValue: _readActivityTitle, fromJson: _nullableStringFromJson) this.activityTitle, @JsonKey(name: 'chat_type', fromJson: _chatTypeFromJson) required this.chatType, @JsonKey(name: 'other_user_id', fromJson: _nullableStringFromJson) this.otherUserId, @JsonKey(name: 'other_user_name', fromJson: _nullableStringFromJson) this.otherUserName, @JsonKey(name: 'other_user_avatar_url', readValue: _readAvatarUrl, fromJson: _nullableStringFromJson) this.otherUserAvatarUrl, @JsonKey(name: 'category_id', fromJson: _nullableStringFromJson) this.categoryId, @JsonKey(name: 'category_slug', fromJson: _nullableStringFromJson) this.categorySlug, @JsonKey(name: 'group_avatar_url', fromJson: _nullableStringFromJson) this.groupAvatarUrl, @JsonKey(name: 'last_message', fromJson: _nullableStringFromJson) this.lastMessage, @JsonKey(name: 'last_message_at', fromJson: _dateTimeFromJson) this.lastMessageAt, @JsonKey(name: 'unread_count', fromJson: _intFromJson) this.unreadCount = 0}): super._();
  factory _ChatConversationModel.fromJson(Map<String, dynamic> json) => _$ChatConversationModelFromJson(json);

@override@JsonKey(name: 'conversation_id', readValue: _readConversationId) final  String conversationId;
@override@JsonKey(name: 'request_id', fromJson: _stringFromJson) final  String requestId;
@override@JsonKey(name: 'activity_title', readValue: _readActivityTitle, fromJson: _nullableStringFromJson) final  String? activityTitle;
@override@JsonKey(name: 'chat_type', fromJson: _chatTypeFromJson) final  String chatType;
@override@JsonKey(name: 'other_user_id', fromJson: _nullableStringFromJson) final  String? otherUserId;
@override@JsonKey(name: 'other_user_name', fromJson: _nullableStringFromJson) final  String? otherUserName;
@override@JsonKey(name: 'other_user_avatar_url', readValue: _readAvatarUrl, fromJson: _nullableStringFromJson) final  String? otherUserAvatarUrl;
@override@JsonKey(name: 'category_id', fromJson: _nullableStringFromJson) final  String? categoryId;
@override@JsonKey(name: 'category_slug', fromJson: _nullableStringFromJson) final  String? categorySlug;
@override@JsonKey(name: 'group_avatar_url', fromJson: _nullableStringFromJson) final  String? groupAvatarUrl;
@override@JsonKey(name: 'last_message', fromJson: _nullableStringFromJson) final  String? lastMessage;
@override@JsonKey(name: 'last_message_at', fromJson: _dateTimeFromJson) final  DateTime? lastMessageAt;
@override@JsonKey(name: 'unread_count', fromJson: _intFromJson) final  int unreadCount;

/// Create a copy of ChatConversationModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatConversationModelCopyWith<_ChatConversationModel> get copyWith => __$ChatConversationModelCopyWithImpl<_ChatConversationModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatConversationModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatConversationModel&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.activityTitle, activityTitle) || other.activityTitle == activityTitle)&&(identical(other.chatType, chatType) || other.chatType == chatType)&&(identical(other.otherUserId, otherUserId) || other.otherUserId == otherUserId)&&(identical(other.otherUserName, otherUserName) || other.otherUserName == otherUserName)&&(identical(other.otherUserAvatarUrl, otherUserAvatarUrl) || other.otherUserAvatarUrl == otherUserAvatarUrl)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categorySlug, categorySlug) || other.categorySlug == categorySlug)&&(identical(other.groupAvatarUrl, groupAvatarUrl) || other.groupAvatarUrl == groupAvatarUrl)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,conversationId,requestId,activityTitle,chatType,otherUserId,otherUserName,otherUserAvatarUrl,categoryId,categorySlug,groupAvatarUrl,lastMessage,lastMessageAt,unreadCount);
}

@override
String toString() {
    return 'ChatConversationModel(conversationId: $conversationId, requestId: $requestId, activityTitle: $activityTitle, chatType: $chatType, otherUserId: $otherUserId, otherUserName: $otherUserName, otherUserAvatarUrl: $otherUserAvatarUrl, categoryId: $categoryId, categorySlug: $categorySlug, groupAvatarUrl: $groupAvatarUrl, lastMessage: $lastMessage, lastMessageAt: $lastMessageAt, unreadCount: $unreadCount)';
}


}

/// @nodoc
abstract mixin class _$ChatConversationModelCopyWith<$Res> implements $ChatConversationModelCopyWith<$Res> {
  factory _$ChatConversationModelCopyWith(_ChatConversationModel value, $Res Function(_ChatConversationModel) _then) = __$ChatConversationModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'conversation_id', readValue: _readConversationId) String conversationId,@JsonKey(name: 'request_id', fromJson: _stringFromJson) String requestId,@JsonKey(name: 'activity_title', readValue: _readActivityTitle, fromJson: _nullableStringFromJson) String? activityTitle,@JsonKey(name: 'chat_type', fromJson: _chatTypeFromJson) String chatType,@JsonKey(name: 'other_user_id', fromJson: _nullableStringFromJson) String? otherUserId,@JsonKey(name: 'other_user_name', fromJson: _nullableStringFromJson) String? otherUserName,@JsonKey(name: 'other_user_avatar_url', readValue: _readAvatarUrl, fromJson: _nullableStringFromJson) String? otherUserAvatarUrl,@JsonKey(name: 'category_id', fromJson: _nullableStringFromJson) String? categoryId,@JsonKey(name: 'category_slug', fromJson: _nullableStringFromJson) String? categorySlug,@JsonKey(name: 'group_avatar_url', fromJson: _nullableStringFromJson) String? groupAvatarUrl,@JsonKey(name: 'last_message', fromJson: _nullableStringFromJson) String? lastMessage,@JsonKey(name: 'last_message_at', fromJson: _dateTimeFromJson) DateTime? lastMessageAt,@JsonKey(name: 'unread_count', fromJson: _intFromJson) int unreadCount
});




}
/// @nodoc
class __$ChatConversationModelCopyWithImpl<$Res>
    implements _$ChatConversationModelCopyWith<$Res> {
  __$ChatConversationModelCopyWithImpl(this._self, this._then);

  final _ChatConversationModel _self;
  final $Res Function(_ChatConversationModel) _then;

/// Create a copy of ChatConversationModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? conversationId = null,Object? requestId = null,Object? activityTitle = freezed,Object? chatType = null,Object? otherUserId = freezed,Object? otherUserName = freezed,Object? otherUserAvatarUrl = freezed,Object? categoryId = freezed,Object? categorySlug = freezed,Object? groupAvatarUrl = freezed,Object? lastMessage = freezed,Object? lastMessageAt = freezed,Object? unreadCount = null,}) {
  return _then(_ChatConversationModel(
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
