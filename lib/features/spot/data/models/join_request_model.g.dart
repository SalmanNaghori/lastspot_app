// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$JoinRequestModelToJson(_JoinRequestModel instance) =>
    <String, dynamic>{
      'props': instance.props,
      'id': instance.id,
      'request_id': instance.requestId,
      'user_id': instance.userId,
      'status': _$JoinRequestStatusEnumMap[instance.status]!,
      'message': instance.message,
      'created_at': instance.createdAt.toIso8601String(),
    };

const _$JoinRequestStatusEnumMap = {
  JoinRequestStatus.pending: 'pending',
  JoinRequestStatus.accepted: 'accepted',
  JoinRequestStatus.rejected: 'rejected',
  JoinRequestStatus.cancelled: 'cancelled',
};
