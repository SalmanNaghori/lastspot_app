import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user_profile.dart';
import 'request_image_entity.dart';

enum RequestStatus { open, full, completed, cancelled, expired, draft }

class RequestEntity extends Equatable {
  final String id;
  final String userId;
  final String categoryId;
  final String title;
  final String? description;
  final String locationName;
  final double latitude;
  final double longitude;
  final DateTime eventDateTime;
  final int maxParticipants;
  final int currentParticipants;
  final double pricePerPerson;
  final RequestStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserProfile? hostProfile;
  final List<RequestImageEntity> images;

  const RequestEntity({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.title,
    this.description,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.eventDateTime,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.pricePerPerson,
    this.status = RequestStatus.open,
    required this.createdAt,
    required this.updatedAt,
    this.hostProfile,
    this.images = const [],
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    categoryId,
    title,
    description,
    locationName,
    latitude,
    longitude,
    eventDateTime,
    maxParticipants,
    currentParticipants,
    pricePerPerson,
    status,
    createdAt,
    updatedAt,
    hostProfile,
    images,
  ];
}
