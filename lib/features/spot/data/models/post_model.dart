import '../../../auth/data/models/profile_model.dart';
import '../../domain/entities/spot_entity.dart';

class PostModel extends SpotEntity {
  const PostModel({
    required super.id,
    required super.hostId,
    required super.sportCategory,
    required super.totalSpots,
    required super.neededSpots,
    required super.matchTime,
    required super.venueName,
    super.googleMapsUrl,
    super.additionalNotes,
    super.status = SpotStatus.active,
    required super.createdAt,
    super.hostProfile,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    SpotStatus parseStatus(String? statusStr) {
      switch (statusStr?.toLowerCase()) {
        case 'full':
          return SpotStatus.full;
        case 'completed':
          return SpotStatus.completed;
        case 'cancelled':
          return SpotStatus.cancelled;
        case 'expired':
          return SpotStatus.expired;
        case 'draft':
          return SpotStatus.draft;
        case 'active':
        default:
          return SpotStatus.active;
      }
    }

    return PostModel(
      id: json['id'] as String,
      hostId: json['host_id'] as String,
      sportCategory: json['sport_category'] as String,
      totalSpots: json['total_spots'] as int,
      neededSpots: json['needed_spots'] as int,
      matchTime: DateTime.parse(json['match_time'] as String),
      venueName: json['venue_name'] as String,
      googleMapsUrl: json['google_maps_url'] as String?,
      additionalNotes: json['additional_notes'] as String?,
      status: parseStatus(json['status'] as String?),
      createdAt: DateTime.parse(json['created_at'] as String),
      hostProfile: json['profiles'] != null
          ? ProfileModel.fromJson(json['profiles'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'host_id': hostId,
      'sport_category': sportCategory,
      'total_spots': totalSpots,
      'needed_spots': neededSpots,
      'match_time': matchTime.toIso8601String(),
      'venue_name': venueName,
      'google_maps_url': googleMapsUrl,
      'additional_notes': additionalNotes,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
