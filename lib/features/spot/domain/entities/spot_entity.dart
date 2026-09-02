import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user_profile.dart';

enum SpotStatus { active, full, completed, cancelled, expired, draft }

class SpotEntity extends Equatable {
  final String id;
  final String hostId;
  final String sportCategory;
  final int totalSpots;
  final int neededSpots;
  final DateTime matchTime;
  final String venueName;
  final String? googleMapsUrl;
  final String? additionalNotes;
  final SpotStatus status;
  final DateTime createdAt;
  final UserProfile? hostProfile;

  const SpotEntity({
    required this.id,
    required this.hostId,
    required this.sportCategory,
    required this.totalSpots,
    required this.neededSpots,
    required this.matchTime,
    required this.venueName,
    this.googleMapsUrl,
    this.additionalNotes,
    this.status = SpotStatus.active,
    required this.createdAt,
    this.hostProfile,
  });

  @override
  List<Object?> get props => [
        id,
        hostId,
        sportCategory,
        totalSpots,
        neededSpots,
        matchTime,
        venueName,
        googleMapsUrl,
        additionalNotes,
        status,
        createdAt,
        hostProfile,
      ];
}
