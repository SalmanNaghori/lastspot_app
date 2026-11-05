import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/extension/string_extension.dart';

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
    @JsonKey(unknownEnumValue: AccountStatus.active)
    @Default(AccountStatus.active)
    AccountStatus status,
    @JsonKey(name: 'is_profile_completed', defaultValue: false)
    @Default(false)
    bool isProfileCompleted,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    String? bio,
    String? city,
    @JsonKey(name: 'city_id') String? cityId,
    @JsonKey(name: 'sports_interests', defaultValue: [])
    @Default([])
    List<String> sportsInterests,
    @JsonKey(defaultValue: 0.0) @Default(0.0) double rating,
    @JsonKey(name: 'status_reason') String? statusReason,
    @JsonKey(name: 'status_message') String? statusMessage,
    @JsonKey(name: 'status_expires_at') DateTime? statusExpiresAt,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final sanitized = Map<String, dynamic>.from(json);
    final rawCreatedAt = sanitized['created_at'];
    if (rawCreatedAt == null || rawCreatedAt.toString().trim().isEmpty) {
      sanitized['created_at'] = DateTime.now().toUtc().toIso8601String();
    } else if (rawCreatedAt is! String) {
      sanitized['created_at'] = rawCreatedAt.toString();
    }

    final rawId = sanitized['id'];
    if (rawId != null && rawId is! String) {
      sanitized['id'] = rawId.toString();
    }

    final rawSports = sanitized['sports_interests'];
    if (rawSports is List) {
      sanitized['sports_interests'] = rawSports
          .map((e) => e.toString())
          .toList();
    }

    return _$UserProfileFromJson(sanitized);
  }
}

extension UserProfileStatusX on UserProfile {
  /// Whether an account suspension has expired based on status_expires_at.
  bool get isSuspensionExpired {
    if (status != AccountStatus.suspended) return false;
    if (statusExpiresAt == null) return false;
    return statusExpiresAt!.isBefore(DateTime.now());
  }

  /// Whether the user account is active, taking soft delete, bans, and suspension expiries into account.
  bool get isAccountActive {
    if (deletedAt != null) return false;
    if (status == AccountStatus.banned) return false;
    if (status == AccountStatus.suspended) {
      return isSuspensionExpired;
    }
    return status == AccountStatus.active;
  }
}

extension UserProfileFormattingX on UserProfile {
  /// City name with capitalized first characters (Title Case).
  String? get formattedCity => city?.trim().toTitleCase();

  /// Full name with capitalized first characters (Title Case).
  String? get formattedFullName => fullName?.trim().toTitleCase();

  /// Formatted display name with fallback support.
  String displayName({String fallback = ''}) {
    if (formattedFullName != null && formattedFullName!.isNotEmpty) {
      return formattedFullName!;
    }
    return fallback;
  }

  /// Whether user has non-empty bio.
  bool get hasBio => bio != null && bio!.trim().isNotEmpty;

  /// Trimmed bio or empty string.
  String get cleanBio => bio?.trim() ?? '';

  /// Whether user has non-empty email.
  bool get hasEmail => email != null && email!.trim().isNotEmpty;

  /// Trimmed email or empty string.
  String get cleanEmail => email?.trim() ?? '';

  /// Whether user has a valid city or cityId.
  bool get hasCity =>
      (city != null && city!.trim().isNotEmpty) ||
      (cityId != null && cityId!.isNotEmpty);
}
