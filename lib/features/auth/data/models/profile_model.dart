import '../../domain/entities/user_profile.dart';

class ProfileModel extends UserProfile {
  const ProfileModel({
    required super.id,
    super.fullName,
    super.profilePhotoUrl,
    super.bio,
    super.city,
    super.status = AccountStatus.active,
    super.sportsInterests = const [],
    super.rating = 0.0,
    required super.createdAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    // Safely parse account status from string
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
      profilePhotoUrl: json['profile_photo_url'] as String?,
      bio: json['bio'] as String?,
      city: json['city'] as String?,
      status: parseStatus(json['account_status'] as String?),
      sportsInterests: (json['sports_interests'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'profile_photo_url': profilePhotoUrl,
      'bio': bio,
      'city': city,
      'account_status': status.name,
      'sports_interests': sportsInterests,
      'rating': rating,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
