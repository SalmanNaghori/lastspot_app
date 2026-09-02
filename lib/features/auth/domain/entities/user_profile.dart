import 'package:equatable/equatable.dart';

enum AccountStatus { active, suspended, banned }

class UserProfile extends Equatable {
  final String id;
  final String? fullName;
  final String? profilePhotoUrl;
  final String? bio;
  final String? city;
  final AccountStatus status;
  final List<String> sportsInterests;
  final double rating;
  final DateTime createdAt;

  const UserProfile({
    required this.id,
    this.fullName,
    this.profilePhotoUrl,
    this.bio,
    this.city,
    this.status = AccountStatus.active,
    this.sportsInterests = const [],
    this.rating = 0.0,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        fullName,
        profilePhotoUrl,
        bio,
        city,
        status,
        sportsInterests,
        rating,
        createdAt,
      ];
}
