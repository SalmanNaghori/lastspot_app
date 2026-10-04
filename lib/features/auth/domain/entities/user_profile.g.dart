// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  id: json['id'] as String,
  fullName: json['full_name'] as String?,
  avatarUrl: json['avatar_url'] as String?,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  status:
      $enumDecodeNullable(
        _$AccountStatusEnumMap,
        json['status'],
        unknownValue: AccountStatus.active,
      ) ??
      AccountStatus.active,
  isProfileCompleted: json['is_profile_completed'] as bool? ?? false,
  createdAt: DateTime.parse(json['created_at'] as String),
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
  bio: json['bio'] as String?,
  city: json['city'] as String?,
  cityId: json['city_id'] as String?,
  sportsInterests:
      (json['sports_interests'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'full_name': instance.fullName,
      'avatar_url': instance.avatarUrl,
      'phone': instance.phone,
      'email': instance.email,
      'status': _$AccountStatusEnumMap[instance.status]!,
      'is_profile_completed': instance.isProfileCompleted,
      'created_at': instance.createdAt.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'bio': instance.bio,
      'city': instance.city,
      'city_id': instance.cityId,
      'sports_interests': instance.sportsInterests,
      'rating': instance.rating,
    };

const _$AccountStatusEnumMap = {
  AccountStatus.active: 'active',
  AccountStatus.suspended: 'suspended',
  AccountStatus.banned: 'banned',
};
