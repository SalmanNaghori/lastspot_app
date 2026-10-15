import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../auth/domain/entities/user_profile.dart';
import '../../domain/entities/request_entity.dart';
import 'request_image_model.dart';

part 'request_model.freezed.dart';
part 'request_model.g.dart';

@Freezed(fromJson: false, toJson: true)
abstract class RequestModel extends Equatable
    with _$RequestModel
    implements RequestEntity {
  const RequestModel._() : super();

  const factory RequestModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'category_id') required String categoryId,
    required String title,
    String? description,
    @JsonKey(name: 'city_id', includeIfNull: false) String? cityId,
    @JsonKey(name: 'location_name') required String locationName,
    required double latitude,
    required double longitude,
    @JsonKey(name: 'event_date_time') required DateTime eventDateTime,
    @JsonKey(name: 'max_participants') required int maxParticipants,
    @JsonKey(name: 'current_participants') required int currentParticipants,
    @JsonKey(name: 'price_per_person') required double pricePerPerson,
    @Default(RequestStatus.open) RequestStatus status,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @JsonKey(includeToJson: false, includeFromJson: false)
    UserProfile? hostProfile,
    @JsonKey(includeToJson: false, includeFromJson: false)
    @Default([])
    List<RequestImageEntity> images,
  }) = _RequestModel;

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    final maxParticipants = _intValue(json['max_participants']);
    final currentParticipants = json['spots_needed'] != null
        ? maxParticipants - _intValue(json['spots_needed'])
        : _intValue(json['current_participants']);
    final status = _parseStatus(
      json['status']?.toString(),
      maxParticipants: maxParticipants,
      currentParticipants: currentParticipants,
    );
    final images = (json['request_images'] as List<dynamic>? ?? [])
        .map(
          (image) => RequestImageModel.fromJson(image as Map<String, dynamic>),
        )
        .toList();

    return RequestModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      categoryId: json['category_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      cityId: json['city_id'] as String?,
      locationName: json['location_name'] as String,
      latitude: _doubleValue(json['latitude']),
      longitude: _doubleValue(json['longitude']),
      eventDateTime: _dateValue(json['event_date_time']),
      maxParticipants: maxParticipants,
      currentParticipants: currentParticipants,
      pricePerPerson: _doubleValue(json['price_per_person']),
      status: status,
      createdAt: _dateValue(json['created_at']),
      updatedAt: _dateValue(json['updated_at']),
      hostProfile: json['profiles'] == null
          ? null
          : UserProfile.fromJson(json['profiles'] as Map<String, dynamic>),
      images: images,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    categoryId,
    title,
    description,
    cityId,
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

  @JsonKey(includeToJson: false, includeFromJson: false)
  @override
  bool? get stringify => true;
}

int _intValue(Object? value) => int.tryParse(value?.toString() ?? '') ?? 0;

double _doubleValue(Object? value) =>
    double.tryParse(value?.toString() ?? '') ?? 0;

DateTime _dateValue(Object? value) {
  if (value == null) return DateTime.now().toUtc();
  final parsed = DateTime.tryParse(value.toString());
  return parsed?.toUtc() ?? DateTime.now().toUtc();
}

RequestStatus _parseStatus(
  String? value, {
  required int maxParticipants,
  required int currentParticipants,
}) {
  if (maxParticipants > 0 && currentParticipants >= maxParticipants) {
    return RequestStatus.full;
  }
  return switch (value?.toLowerCase()) {
    'full' => RequestStatus.full,
    'completed' => RequestStatus.completed,
    'cancelled' => RequestStatus.cancelled,
    'expired' => RequestStatus.expired,
    'draft' => RequestStatus.draft,
    _ => RequestStatus.open,
  };
}
