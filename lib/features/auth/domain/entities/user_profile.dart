import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

enum AccountStatus { active, suspended, banned }

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    @JsonKey(name: 'full_name') String? fullName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    String? phone,
    String? email,
    @JsonKey(unknownEnumValue: AccountStatus.active) @Default(AccountStatus.active) AccountStatus status,
    @JsonKey(name: 'is_profile_completed', defaultValue: false) @Default(false) bool isProfileCompleted,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    String? bio,
    String? city,
    @JsonKey(name: 'city_id') String? cityId,
    @JsonKey(name: 'sports_interests', defaultValue: []) @Default([]) List<String> sportsInterests,
    @JsonKey(defaultValue: 0.0) @Default(0.0) double rating,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
}
