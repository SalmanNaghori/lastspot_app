import 'dart:developer' as developer;
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../auth/domain/entities/user_profile.dart';
import '../../domain/entities/join_request_entity.dart';
import '../../domain/entities/request_entity.dart';
import 'request_model.dart';

part 'join_request_model.freezed.dart';
part 'join_request_model.g.dart';

@Freezed(fromJson: false, toJson: true)
abstract class JoinRequestModel extends Equatable
    with _$JoinRequestModel
    implements JoinRequestEntity {
  const JoinRequestModel._() : super();

  const factory JoinRequestModel({
    required String id,
    @JsonKey(name: 'request_id') required String requestId,
    @JsonKey(name: 'user_id') required String userId,
    @Default(JoinRequestStatus.pending) JoinRequestStatus status,
    String? message,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(includeToJson: false, includeFromJson: false)
    UserProfile? userProfile,
    @JsonKey(includeToJson: false, includeFromJson: false)
    RequestEntity? request,
  }) = _JoinRequestModel;

  factory JoinRequestModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id']?.toString();
    if (rawId == null || rawId.trim().isEmpty) {
      throw const FormatException('Missing mandatory "id" in JoinRequestModel');
    }
    final rawRequestId =
        json['request_id']?.toString() ?? json['requestId']?.toString();
    if (rawRequestId == null || rawRequestId.trim().isEmpty) {
      throw const FormatException(
        'Missing mandatory "request_id" in JoinRequestModel',
      );
    }
    final rawUserId = json['user_id']?.toString() ?? json['userId']?.toString();
    if (rawUserId == null || rawUserId.trim().isEmpty) {
      throw const FormatException(
        'Missing mandatory "user_id" in JoinRequestModel',
      );
    }

    final status = switch ((json['status'] as String?)?.toLowerCase()) {
      'accepted' => JoinRequestStatus.accepted,
      'rejected' => JoinRequestStatus.rejected,
      'cancelled' => JoinRequestStatus.cancelled,
      _ => JoinRequestStatus.pending,
    };

    UserProfile? userProfile;
    final rawProfile =
        json['profiles'] ?? json['profile'] ?? json['user_profile'];
    if (rawProfile is Map<String, dynamic>) {
      try {
        userProfile = UserProfile.fromJson(rawProfile);
      } catch (e, st) {
        developer.log(
          'Failed to parse user profile for join request $rawId: $e',
          name: 'JoinRequestModel',
          error: e,
          stackTrace: st,
        );
      }
    } else if (rawProfile is List &&
        rawProfile.isNotEmpty &&
        rawProfile.first is Map<String, dynamic>) {
      try {
        userProfile = UserProfile.fromJson(
          rawProfile.first as Map<String, dynamic>,
        );
      } catch (e, st) {
        developer.log(
          'Failed to parse list user profile for join request $rawId: $e',
          name: 'JoinRequestModel',
          error: e,
          stackTrace: st,
        );
      }
    }

    RequestEntity? request;
    final rawRequest = json['requests'] ?? json['request'];
    if (rawRequest is Map<String, dynamic>) {
      try {
        request = RequestModel.fromJson(rawRequest);
      } catch (e, st) {
        developer.log(
          'Failed to parse request entity for join request $rawId: $e',
          name: 'JoinRequestModel',
          error: e,
          stackTrace: st,
        );
      }
    } else if (rawRequest is List &&
        rawRequest.isNotEmpty &&
        rawRequest.first is Map<String, dynamic>) {
      try {
        request = RequestModel.fromJson(
          rawRequest.first as Map<String, dynamic>,
        );
      } catch (e, st) {
        developer.log(
          'Failed to parse list request entity for join request $rawId: $e',
          name: 'JoinRequestModel',
          error: e,
          stackTrace: st,
        );
      }
    }

    return JoinRequestModel(
      id: rawId,
      requestId: rawRequestId,
      userId: rawUserId,
      status: status,
      message: json['message'] as String?,
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '')?.toUtc() ??
          DateTime.now().toUtc(),
      userProfile: userProfile,
      request: request,
    );
  }

  @override
  List<Object?> get props => [
    id,
    requestId,
    userId,
    status,
    message,
    createdAt,
    userProfile,
    request,
  ];

  @JsonKey(includeToJson: false, includeFromJson: false)
  @override
  bool? get stringify => true;
}
