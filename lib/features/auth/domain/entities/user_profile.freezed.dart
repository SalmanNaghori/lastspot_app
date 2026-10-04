// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserProfile {

 String get id;@JsonKey(name: 'full_name') String? get fullName;@JsonKey(name: 'avatar_url') String? get avatarUrl; String? get phone; String? get email;@JsonKey(unknownEnumValue: AccountStatus.active) AccountStatus get status;@JsonKey(name: 'is_profile_completed', defaultValue: false) bool get isProfileCompleted;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'deleted_at') DateTime? get deletedAt; String? get bio; String? get city;@JsonKey(name: 'city_id') String? get cityId;@JsonKey(name: 'sports_interests', defaultValue: []) List<String> get sportsInterests;@JsonKey(defaultValue: 0.0) double get rating;
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UserProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.avatarUrl, _this.avatarUrl) || other.avatarUrl == _this.avatarUrl)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.isProfileCompleted, _this.isProfileCompleted) || other.isProfileCompleted == _this.isProfileCompleted)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.deletedAt, _this.deletedAt) || other.deletedAt == _this.deletedAt)&&(identical(other.bio, _this.bio) || other.bio == _this.bio)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.cityId, _this.cityId) || other.cityId == _this.cityId)&&const DeepCollectionEquality().equals(other.sportsInterests, _this.sportsInterests)&&(identical(other.rating, _this.rating) || other.rating == _this.rating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UserProfile;
  return Object.hash(runtimeType,_this.id,_this.fullName,_this.avatarUrl,_this.phone,_this.email,_this.status,_this.isProfileCompleted,_this.createdAt,_this.deletedAt,_this.bio,_this.city,_this.cityId,const DeepCollectionEquality().hash(_this.sportsInterests),_this.rating);
}

@override
String toString() {
  final _this = this as UserProfile;
  return 'UserProfile(id: ${_this.id}, fullName: ${_this.fullName}, avatarUrl: ${_this.avatarUrl}, phone: ${_this.phone}, email: ${_this.email}, status: ${_this.status}, isProfileCompleted: ${_this.isProfileCompleted}, createdAt: ${_this.createdAt}, deletedAt: ${_this.deletedAt}, bio: ${_this.bio}, city: ${_this.city}, cityId: ${_this.cityId}, sportsInterests: ${_this.sportsInterests}, rating: ${_this.rating})';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res>  {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'full_name') String? fullName,@JsonKey(name: 'avatar_url') String? avatarUrl, String? phone, String? email,@JsonKey(unknownEnumValue: AccountStatus.active) AccountStatus status,@JsonKey(name: 'is_profile_completed', defaultValue: false) bool isProfileCompleted,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'deleted_at') DateTime? deletedAt, String? bio, String? city,@JsonKey(name: 'city_id') String? cityId,@JsonKey(name: 'sports_interests', defaultValue: []) List<String> sportsInterests,@JsonKey(defaultValue: 0.0) double rating
});




}
/// @nodoc
class _$UserProfileCopyWithImpl<$Res>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fullName = freezed,Object? avatarUrl = freezed,Object? phone = freezed,Object? email = freezed,Object? status = null,Object? isProfileCompleted = null,Object? createdAt = null,Object? deletedAt = freezed,Object? bio = freezed,Object? city = freezed,Object? cityId = freezed,Object? sportsInterests = null,Object? rating = null,}) {
  return _then(UserProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AccountStatus,isProfileCompleted: null == isProfileCompleted ? _self.isProfileCompleted : isProfileCompleted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,cityId: freezed == cityId ? _self.cityId : cityId // ignore: cast_nullable_to_non_nullable
as String?,sportsInterests: null == sportsInterests ? _self.sportsInterests : sportsInterests // ignore: cast_nullable_to_non_nullable
as List<String>,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfile].
extension UserProfilePatterns on UserProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfile value)  $default,){
final _that = this;
switch (_that) {
case _UserProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfile value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'full_name')  String? fullName, @JsonKey(name: 'avatar_url')  String? avatarUrl,  String? phone,  String? email, @JsonKey(unknownEnumValue: AccountStatus.active)  AccountStatus status, @JsonKey(name: 'is_profile_completed', defaultValue: false)  bool isProfileCompleted, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'deleted_at')  DateTime? deletedAt,  String? bio,  String? city, @JsonKey(name: 'city_id')  String? cityId, @JsonKey(name: 'sports_interests', defaultValue: [])  List<String> sportsInterests, @JsonKey(defaultValue: 0.0)  double rating)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.id,_that.fullName,_that.avatarUrl,_that.phone,_that.email,_that.status,_that.isProfileCompleted,_that.createdAt,_that.deletedAt,_that.bio,_that.city,_that.cityId,_that.sportsInterests,_that.rating);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'full_name')  String? fullName, @JsonKey(name: 'avatar_url')  String? avatarUrl,  String? phone,  String? email, @JsonKey(unknownEnumValue: AccountStatus.active)  AccountStatus status, @JsonKey(name: 'is_profile_completed', defaultValue: false)  bool isProfileCompleted, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'deleted_at')  DateTime? deletedAt,  String? bio,  String? city, @JsonKey(name: 'city_id')  String? cityId, @JsonKey(name: 'sports_interests', defaultValue: [])  List<String> sportsInterests, @JsonKey(defaultValue: 0.0)  double rating)  $default,) {final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that.id,_that.fullName,_that.avatarUrl,_that.phone,_that.email,_that.status,_that.isProfileCompleted,_that.createdAt,_that.deletedAt,_that.bio,_that.city,_that.cityId,_that.sportsInterests,_that.rating);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'full_name')  String? fullName, @JsonKey(name: 'avatar_url')  String? avatarUrl,  String? phone,  String? email, @JsonKey(unknownEnumValue: AccountStatus.active)  AccountStatus status, @JsonKey(name: 'is_profile_completed', defaultValue: false)  bool isProfileCompleted, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'deleted_at')  DateTime? deletedAt,  String? bio,  String? city, @JsonKey(name: 'city_id')  String? cityId, @JsonKey(name: 'sports_interests', defaultValue: [])  List<String> sportsInterests, @JsonKey(defaultValue: 0.0)  double rating)?  $default,) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.id,_that.fullName,_that.avatarUrl,_that.phone,_that.email,_that.status,_that.isProfileCompleted,_that.createdAt,_that.deletedAt,_that.bio,_that.city,_that.cityId,_that.sportsInterests,_that.rating);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserProfile implements UserProfile {
  const _UserProfile({required this.id, @JsonKey(name: 'full_name') this.fullName, @JsonKey(name: 'avatar_url') this.avatarUrl, this.phone, this.email, @JsonKey(unknownEnumValue: AccountStatus.active) this.status = AccountStatus.active, @JsonKey(name: 'is_profile_completed', defaultValue: false) this.isProfileCompleted = false, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'deleted_at') this.deletedAt, this.bio, this.city, @JsonKey(name: 'city_id') this.cityId, @JsonKey(name: 'sports_interests', defaultValue: [])  List<String> sportsInterests = const [], @JsonKey(defaultValue: 0.0) this.rating = 0.0}): _sportsInterests = sportsInterests;
  factory _UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);

@override final  String id;
@override@JsonKey(name: 'full_name') final  String? fullName;
@override@JsonKey(name: 'avatar_url') final  String? avatarUrl;
@override final  String? phone;
@override final  String? email;
@override@JsonKey(unknownEnumValue: AccountStatus.active) final  AccountStatus status;
@override@JsonKey(name: 'is_profile_completed', defaultValue: false) final  bool isProfileCompleted;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'deleted_at') final  DateTime? deletedAt;
@override final  String? bio;
@override final  String? city;
@override@JsonKey(name: 'city_id') final  String? cityId;
 final  List<String> _sportsInterests;
@override@JsonKey(name: 'sports_interests', defaultValue: []) List<String> get sportsInterests {
  if (_sportsInterests is EqualUnmodifiableListView) return _sportsInterests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sportsInterests);
}

@override@JsonKey(defaultValue: 0.0) final  double rating;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileCopyWith<_UserProfile> get copyWith => __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserProfileToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.status, status) || other.status == status)&&(identical(other.isProfileCompleted, isProfileCompleted) || other.isProfileCompleted == isProfileCompleted)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.city, city) || other.city == city)&&(identical(other.cityId, cityId) || other.cityId == cityId)&&const DeepCollectionEquality().equals(other.sportsInterests, _sportsInterests)&&(identical(other.rating, rating) || other.rating == rating));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,fullName,avatarUrl,phone,email,status,isProfileCompleted,createdAt,deletedAt,bio,city,cityId,const DeepCollectionEquality().hash(_sportsInterests),rating);
}

@override
String toString() {
    return 'UserProfile(id: $id, fullName: $fullName, avatarUrl: $avatarUrl, phone: $phone, email: $email, status: $status, isProfileCompleted: $isProfileCompleted, createdAt: $createdAt, deletedAt: $deletedAt, bio: $bio, city: $city, cityId: $cityId, sportsInterests: $sportsInterests, rating: $rating)';
}


}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res> implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(_UserProfile value, $Res Function(_UserProfile) _then) = __$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'full_name') String? fullName,@JsonKey(name: 'avatar_url') String? avatarUrl, String? phone, String? email,@JsonKey(unknownEnumValue: AccountStatus.active) AccountStatus status,@JsonKey(name: 'is_profile_completed', defaultValue: false) bool isProfileCompleted,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'deleted_at') DateTime? deletedAt, String? bio, String? city,@JsonKey(name: 'city_id') String? cityId,@JsonKey(name: 'sports_interests', defaultValue: []) List<String> sportsInterests,@JsonKey(defaultValue: 0.0) double rating
});




}
/// @nodoc
class __$UserProfileCopyWithImpl<$Res>
    implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = freezed,Object? avatarUrl = freezed,Object? phone = freezed,Object? email = freezed,Object? status = null,Object? isProfileCompleted = null,Object? createdAt = null,Object? deletedAt = freezed,Object? bio = freezed,Object? city = freezed,Object? cityId = freezed,Object? sportsInterests = null,Object? rating = null,}) {
  return _then(_UserProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AccountStatus,isProfileCompleted: null == isProfileCompleted ? _self.isProfileCompleted : isProfileCompleted // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,cityId: freezed == cityId ? _self.cityId : cityId // ignore: cast_nullable_to_non_nullable
as String?,sportsInterests: null == sportsInterests ? _self._sportsInterests : sportsInterests // ignore: cast_nullable_to_non_nullable
as List<String>,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
