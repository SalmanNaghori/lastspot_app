// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RequestModel {

 String get id;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'category_id') String get categoryId; String get title; String? get description;@JsonKey(name: 'city_id', includeIfNull: false) String? get cityId;@JsonKey(name: 'location_name') String get locationName; double get latitude; double get longitude;@JsonKey(name: 'event_date_time') DateTime get eventDateTime;@JsonKey(name: 'max_participants') int get maxParticipants;@JsonKey(name: 'current_participants') int get currentParticipants;@JsonKey(name: 'price_per_person') double get pricePerPerson; RequestStatus get status;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'updated_at') DateTime get updatedAt;@JsonKey(includeToJson: false, includeFromJson: false) UserProfile? get hostProfile;@JsonKey(includeToJson: false, includeFromJson: false) List<RequestImageEntity> get images;
/// Create a copy of RequestModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestModelCopyWith<RequestModel> get copyWith => _$RequestModelCopyWithImpl<RequestModel>(this as RequestModel, _$identity);

  /// Serializes this RequestModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RequestModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestModel&&super == other&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.cityId, _this.cityId) || other.cityId == _this.cityId)&&(identical(other.locationName, _this.locationName) || other.locationName == _this.locationName)&&(identical(other.latitude, _this.latitude) || other.latitude == _this.latitude)&&(identical(other.longitude, _this.longitude) || other.longitude == _this.longitude)&&(identical(other.eventDateTime, _this.eventDateTime) || other.eventDateTime == _this.eventDateTime)&&(identical(other.maxParticipants, _this.maxParticipants) || other.maxParticipants == _this.maxParticipants)&&(identical(other.currentParticipants, _this.currentParticipants) || other.currentParticipants == _this.currentParticipants)&&(identical(other.pricePerPerson, _this.pricePerPerson) || other.pricePerPerson == _this.pricePerPerson)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.hostProfile, _this.hostProfile) || other.hostProfile == _this.hostProfile)&&const DeepCollectionEquality().equals(other.images, _this.images));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RequestModel;
  return Object.hashAll([runtimeType,super.hashCode,_this.id,_this.userId,_this.categoryId,_this.title,_this.description,_this.cityId,_this.locationName,_this.latitude,_this.longitude,_this.eventDateTime,_this.maxParticipants,_this.currentParticipants,_this.pricePerPerson,_this.status,_this.createdAt,_this.updatedAt,_this.hostProfile,const DeepCollectionEquality().hash(_this.images)]);
}



}

/// @nodoc
abstract mixin class $RequestModelCopyWith<$Res>  {
  factory $RequestModelCopyWith(RequestModel value, $Res Function(RequestModel) _then) = _$RequestModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'category_id') String categoryId, String title, String? description,@JsonKey(name: 'city_id', includeIfNull: false) String? cityId,@JsonKey(name: 'location_name') String locationName, double latitude, double longitude,@JsonKey(name: 'event_date_time') DateTime eventDateTime,@JsonKey(name: 'max_participants') int maxParticipants,@JsonKey(name: 'current_participants') int currentParticipants,@JsonKey(name: 'price_per_person') double pricePerPerson, RequestStatus status,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt,@JsonKey(includeToJson: false, includeFromJson: false) UserProfile? hostProfile,@JsonKey(includeToJson: false, includeFromJson: false) List<RequestImageEntity> images
});


$UserProfileCopyWith<$Res>? get hostProfile;

}
/// @nodoc
class _$RequestModelCopyWithImpl<$Res>
    implements $RequestModelCopyWith<$Res> {
  _$RequestModelCopyWithImpl(this._self, this._then);

  final RequestModel _self;
  final $Res Function(RequestModel) _then;

/// Create a copy of RequestModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? categoryId = null,Object? title = null,Object? description = freezed,Object? cityId = freezed,Object? locationName = null,Object? latitude = null,Object? longitude = null,Object? eventDateTime = null,Object? maxParticipants = null,Object? currentParticipants = null,Object? pricePerPerson = null,Object? status = null,Object? createdAt = null,Object? updatedAt = null,Object? hostProfile = freezed,Object? images = null,}) {
  return _then(RequestModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,cityId: freezed == cityId ? _self.cityId : cityId // ignore: cast_nullable_to_non_nullable
as String?,locationName: null == locationName ? _self.locationName : locationName // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,eventDateTime: null == eventDateTime ? _self.eventDateTime : eventDateTime // ignore: cast_nullable_to_non_nullable
as DateTime,maxParticipants: null == maxParticipants ? _self.maxParticipants : maxParticipants // ignore: cast_nullable_to_non_nullable
as int,currentParticipants: null == currentParticipants ? _self.currentParticipants : currentParticipants // ignore: cast_nullable_to_non_nullable
as int,pricePerPerson: null == pricePerPerson ? _self.pricePerPerson : pricePerPerson // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RequestStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,hostProfile: freezed == hostProfile ? _self.hostProfile : hostProfile // ignore: cast_nullable_to_non_nullable
as UserProfile?,images: null == images ? _self.images : images // ignore: cast_nullable_to_non_nullable
as List<RequestImageEntity>,
  ));
}
/// Create a copy of RequestModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserProfileCopyWith<$Res>? get hostProfile {
    if (_self.hostProfile == null) {
    return null;
  }

  return $UserProfileCopyWith<$Res>(_self.hostProfile!, (value) {
    return _then(_self.copyWith(hostProfile: value));
  });
}
}


/// Adds pattern-matching-related methods to [RequestModel].
extension RequestModelPatterns on RequestModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RequestModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RequestModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RequestModel value)  $default,){
final _that = this;
switch (_that) {
case _RequestModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RequestModel value)?  $default,){
final _that = this;
switch (_that) {
case _RequestModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'category_id')  String categoryId,  String title,  String? description, @JsonKey(name: 'city_id', includeIfNull: false)  String? cityId, @JsonKey(name: 'location_name')  String locationName,  double latitude,  double longitude, @JsonKey(name: 'event_date_time')  DateTime eventDateTime, @JsonKey(name: 'max_participants')  int maxParticipants, @JsonKey(name: 'current_participants')  int currentParticipants, @JsonKey(name: 'price_per_person')  double pricePerPerson,  RequestStatus status, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt, @JsonKey(includeToJson: false, includeFromJson: false)  UserProfile? hostProfile, @JsonKey(includeToJson: false, includeFromJson: false)  List<RequestImageEntity> images)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RequestModel() when $default != null:
return $default(_that.id,_that.userId,_that.categoryId,_that.title,_that.description,_that.cityId,_that.locationName,_that.latitude,_that.longitude,_that.eventDateTime,_that.maxParticipants,_that.currentParticipants,_that.pricePerPerson,_that.status,_that.createdAt,_that.updatedAt,_that.hostProfile,_that.images);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'category_id')  String categoryId,  String title,  String? description, @JsonKey(name: 'city_id', includeIfNull: false)  String? cityId, @JsonKey(name: 'location_name')  String locationName,  double latitude,  double longitude, @JsonKey(name: 'event_date_time')  DateTime eventDateTime, @JsonKey(name: 'max_participants')  int maxParticipants, @JsonKey(name: 'current_participants')  int currentParticipants, @JsonKey(name: 'price_per_person')  double pricePerPerson,  RequestStatus status, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt, @JsonKey(includeToJson: false, includeFromJson: false)  UserProfile? hostProfile, @JsonKey(includeToJson: false, includeFromJson: false)  List<RequestImageEntity> images)  $default,) {final _that = this;
switch (_that) {
case _RequestModel():
return $default(_that.id,_that.userId,_that.categoryId,_that.title,_that.description,_that.cityId,_that.locationName,_that.latitude,_that.longitude,_that.eventDateTime,_that.maxParticipants,_that.currentParticipants,_that.pricePerPerson,_that.status,_that.createdAt,_that.updatedAt,_that.hostProfile,_that.images);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'category_id')  String categoryId,  String title,  String? description, @JsonKey(name: 'city_id', includeIfNull: false)  String? cityId, @JsonKey(name: 'location_name')  String locationName,  double latitude,  double longitude, @JsonKey(name: 'event_date_time')  DateTime eventDateTime, @JsonKey(name: 'max_participants')  int maxParticipants, @JsonKey(name: 'current_participants')  int currentParticipants, @JsonKey(name: 'price_per_person')  double pricePerPerson,  RequestStatus status, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'updated_at')  DateTime updatedAt, @JsonKey(includeToJson: false, includeFromJson: false)  UserProfile? hostProfile, @JsonKey(includeToJson: false, includeFromJson: false)  List<RequestImageEntity> images)?  $default,) {final _that = this;
switch (_that) {
case _RequestModel() when $default != null:
return $default(_that.id,_that.userId,_that.categoryId,_that.title,_that.description,_that.cityId,_that.locationName,_that.latitude,_that.longitude,_that.eventDateTime,_that.maxParticipants,_that.currentParticipants,_that.pricePerPerson,_that.status,_that.createdAt,_that.updatedAt,_that.hostProfile,_that.images);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable(createFactory: false)

class _RequestModel extends RequestModel {
  const _RequestModel({required this.id, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'category_id') required this.categoryId, required this.title, this.description, @JsonKey(name: 'city_id', includeIfNull: false) this.cityId, @JsonKey(name: 'location_name') required this.locationName, required this.latitude, required this.longitude, @JsonKey(name: 'event_date_time') required this.eventDateTime, @JsonKey(name: 'max_participants') required this.maxParticipants, @JsonKey(name: 'current_participants') required this.currentParticipants, @JsonKey(name: 'price_per_person') required this.pricePerPerson, this.status = RequestStatus.open, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt, @JsonKey(includeToJson: false, includeFromJson: false) this.hostProfile, @JsonKey(includeToJson: false, includeFromJson: false)  List<RequestImageEntity> images = const []}): _images = images,super._();
  

@override final  String id;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'category_id') final  String categoryId;
@override final  String title;
@override final  String? description;
@override@JsonKey(name: 'city_id', includeIfNull: false) final  String? cityId;
@override@JsonKey(name: 'location_name') final  String locationName;
@override final  double latitude;
@override final  double longitude;
@override@JsonKey(name: 'event_date_time') final  DateTime eventDateTime;
@override@JsonKey(name: 'max_participants') final  int maxParticipants;
@override@JsonKey(name: 'current_participants') final  int currentParticipants;
@override@JsonKey(name: 'price_per_person') final  double pricePerPerson;
@override@JsonKey() final  RequestStatus status;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime updatedAt;
@override@JsonKey(includeToJson: false, includeFromJson: false) final  UserProfile? hostProfile;
 final  List<RequestImageEntity> _images;
@override@JsonKey(includeToJson: false, includeFromJson: false) List<RequestImageEntity> get images {
  if (_images is EqualUnmodifiableListView) return _images;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_images);
}


/// Create a copy of RequestModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequestModelCopyWith<_RequestModel> get copyWith => __$RequestModelCopyWithImpl<_RequestModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RequestModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequestModel&&super == other&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.cityId, cityId) || other.cityId == cityId)&&(identical(other.locationName, locationName) || other.locationName == locationName)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.eventDateTime, eventDateTime) || other.eventDateTime == eventDateTime)&&(identical(other.maxParticipants, maxParticipants) || other.maxParticipants == maxParticipants)&&(identical(other.currentParticipants, currentParticipants) || other.currentParticipants == currentParticipants)&&(identical(other.pricePerPerson, pricePerPerson) || other.pricePerPerson == pricePerPerson)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.hostProfile, hostProfile) || other.hostProfile == hostProfile)&&const DeepCollectionEquality().equals(other.images, _images));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,super.hashCode,id,userId,categoryId,title,description,cityId,locationName,latitude,longitude,eventDateTime,maxParticipants,currentParticipants,pricePerPerson,status,createdAt,updatedAt,hostProfile,const DeepCollectionEquality().hash(_images)]);
}



}

/// @nodoc
abstract mixin class _$RequestModelCopyWith<$Res> implements $RequestModelCopyWith<$Res> {
  factory _$RequestModelCopyWith(_RequestModel value, $Res Function(_RequestModel) _then) = __$RequestModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'category_id') String categoryId, String title, String? description,@JsonKey(name: 'city_id', includeIfNull: false) String? cityId,@JsonKey(name: 'location_name') String locationName, double latitude, double longitude,@JsonKey(name: 'event_date_time') DateTime eventDateTime,@JsonKey(name: 'max_participants') int maxParticipants,@JsonKey(name: 'current_participants') int currentParticipants,@JsonKey(name: 'price_per_person') double pricePerPerson, RequestStatus status,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'updated_at') DateTime updatedAt,@JsonKey(includeToJson: false, includeFromJson: false) UserProfile? hostProfile,@JsonKey(includeToJson: false, includeFromJson: false) List<RequestImageEntity> images
});


@override $UserProfileCopyWith<$Res>? get hostProfile;

}
/// @nodoc
class __$RequestModelCopyWithImpl<$Res>
    implements _$RequestModelCopyWith<$Res> {
  __$RequestModelCopyWithImpl(this._self, this._then);

  final _RequestModel _self;
  final $Res Function(_RequestModel) _then;

/// Create a copy of RequestModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? categoryId = null,Object? title = null,Object? description = freezed,Object? cityId = freezed,Object? locationName = null,Object? latitude = null,Object? longitude = null,Object? eventDateTime = null,Object? maxParticipants = null,Object? currentParticipants = null,Object? pricePerPerson = null,Object? status = null,Object? createdAt = null,Object? updatedAt = null,Object? hostProfile = freezed,Object? images = null,}) {
  return _then(_RequestModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,cityId: freezed == cityId ? _self.cityId : cityId // ignore: cast_nullable_to_non_nullable
as String?,locationName: null == locationName ? _self.locationName : locationName // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,eventDateTime: null == eventDateTime ? _self.eventDateTime : eventDateTime // ignore: cast_nullable_to_non_nullable
as DateTime,maxParticipants: null == maxParticipants ? _self.maxParticipants : maxParticipants // ignore: cast_nullable_to_non_nullable
as int,currentParticipants: null == currentParticipants ? _self.currentParticipants : currentParticipants // ignore: cast_nullable_to_non_nullable
as int,pricePerPerson: null == pricePerPerson ? _self.pricePerPerson : pricePerPerson // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RequestStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,hostProfile: freezed == hostProfile ? _self.hostProfile : hostProfile // ignore: cast_nullable_to_non_nullable
as UserProfile?,images: null == images ? _self._images : images // ignore: cast_nullable_to_non_nullable
as List<RequestImageEntity>,
  ));
}

/// Create a copy of RequestModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserProfileCopyWith<$Res>? get hostProfile {
    if (_self.hostProfile == null) {
    return null;
  }

  return $UserProfileCopyWith<$Res>(_self.hostProfile!, (value) {
    return _then(_self.copyWith(hostProfile: value));
  });
}
}

// dart format on
