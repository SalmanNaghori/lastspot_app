import '../../domain/entities/user_profile.dart';

class ProfileModel extends UserProfile {
  const ProfileModel({
    required super.id,
    super.fullName,
    super.avatarUrl,
    super.phone,
    super.email,
    super.status = AccountStatus.active,
    super.isProfileCompleted = false,
    required super.createdAt,
    super.deletedAt,
    super.bio,
    super.city,
    super.sportsInterests = const [],
    super.rating = 0.0,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    AccountStatus parseStatus(String? statusStr) {
      switch (statusStr?.toLowerCase()) {
        case 'suspended':
          return AccountStatus.suspended;
        case 'banned':
          return AccountStatus.banned;
        case 'active':
        default:
          return AccountStatus.active;
      }
    }

    return ProfileModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String?,
      avatarUrl: json['avatar_url'] as String?, // live DB column: avatar_url
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      status: parseStatus(json['status'] as String?), // live DB column: status
      isProfileCompleted: json['is_profile_completed'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'] as String)
          : null,
      // Extended fields — present after SQL migration; graceful fallback until then
      bio: json['bio'] as String?,
      city: json['city'] as String?,
      sportsInterests:
          (json['sports_interests'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'avatar_url': avatarUrl, // live DB column: avatar_url
      'phone': phone,
      'email': email,
      'status': status.name, // live DB column: status
      'is_profile_completed': isProfileCompleted,
      // Extended fields — only included if present (no-op if column missing in DB)
      if (bio != null) 'bio': bio,
      if (city != null) 'city': city,
      'sports_interests': sportsInterests,
      'rating': rating,
    };
  }
}
