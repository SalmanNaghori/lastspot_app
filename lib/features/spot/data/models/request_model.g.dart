// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$RequestModelToJson(_RequestModel instance) =>
    <String, dynamic>{
      'props': instance.props,
      'id': instance.id,
      'user_id': instance.userId,
      'category_id': instance.categoryId,
      'title': instance.title,
      'description': instance.description,
      'city_id': ?instance.cityId,
      'location_name': instance.locationName,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'event_date_time': instance.eventDateTime.toIso8601String(),
      'max_participants': instance.maxParticipants,
      'current_participants': instance.currentParticipants,
      'price_per_person': instance.pricePerPerson,
      'status': _$RequestStatusEnumMap[instance.status]!,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$RequestStatusEnumMap = {
  RequestStatus.open: 'open',
  RequestStatus.full: 'full',
  RequestStatus.completed: 'completed',
  RequestStatus.cancelled: 'cancelled',
  RequestStatus.expired: 'expired',
  RequestStatus.draft: 'draft',
};
