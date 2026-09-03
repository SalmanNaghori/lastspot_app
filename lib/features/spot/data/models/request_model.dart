import '../../../auth/data/models/profile_model.dart';
import '../../domain/entities/request_entity.dart';
import 'request_image_model.dart';

class RequestModel extends RequestEntity {
  const RequestModel({
    required super.id,
    required super.userId,
    required super.categoryId,
    required super.title,
    super.description,
    required super.locationName,
    required super.latitude,
    required super.longitude,
    required super.eventDateTime,
    required super.maxParticipants,
    required super.currentParticipants,
    required super.pricePerPerson,
    super.status = RequestStatus.open,
    required super.createdAt,
    required super.updatedAt,
    super.hostProfile,
    super.images = const [],
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    RequestStatus parseStatus(String? statusStr) {
      switch (statusStr?.toLowerCase()) {
        case 'full':
          return RequestStatus.full;
        case 'completed':
          return RequestStatus.completed;
        case 'cancelled':
          return RequestStatus.cancelled;
        case 'expired':
          return RequestStatus.expired;
        case 'draft':
          return RequestStatus.draft;
        case 'open':
        default:
          return RequestStatus.open;
      }
    }

    final imagesJson = json['request_images'] as List<dynamic>? ?? [];
    final parsedImages = imagesJson
        .map((img) => RequestImageModel.fromJson(img as Map<String, dynamic>))
        .toList();

    return RequestModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      categoryId: json['category_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      locationName: json['location_name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      eventDateTime: DateTime.parse(json['event_date_time'] as String),
      maxParticipants: json['max_participants'] as int,
      currentParticipants: json['current_participants'] as int,
      pricePerPerson: (json['price_per_person'] as num).toDouble(),
      status: parseStatus(json['status'] as String?),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      hostProfile: json['profiles'] != null
          ? ProfileModel.fromJson(json['profiles'])
          : null,
      images: parsedImages,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'category_id': categoryId,
      'title': title,
      'description': description,
      'location_name': locationName,
      'latitude': latitude,
      'longitude': longitude,
      'event_date_time': eventDateTime.toIso8601String(),
      'max_participants': maxParticipants,
      'current_participants': currentParticipants,
      'price_per_person': pricePerPerson,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
