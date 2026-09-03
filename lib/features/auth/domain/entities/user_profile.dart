import 'package:equatable/equatable.dart';

enum AccountStatus { active, suspended, banned }

class UserProfile extends Equatable {
  final String id;
  final String? fullName;
  final String? avatarUrl; // live DB: avatar_url
  final String? phone; // live DB: phone
  final String? email; // live DB: email
  final AccountStatus status; // live DB: status (NOT NULL)
  final bool isProfileCompleted; // live DB: is_profile_completed (NOT NULL)
  final DateTime createdAt;
  final DateTime? deletedAt;

  // Extended profile fields — stored in live DB after migration
  final String? bio;
  final String? city;
  final List<String> sportsInterests;
  final double rating;

  const UserProfile({
    required this.id,
    this.fullName,
    this.avatarUrl,
    this.phone,
    this.email,
    this.status = AccountStatus.active,
    this.isProfileCompleted = false,
    required this.createdAt,
    this.deletedAt,
    this.bio,
    this.city,
    this.sportsInterests = const [],
    this.rating = 0.0,
  });

  @override
  List<Object?> get props => [
    id,
    fullName,
    avatarUrl,
    phone,
    email,
    status,
    isProfileCompleted,
    createdAt,
    deletedAt,
    bio,
    city,
    sportsInterests,
    rating,
  ];
}
