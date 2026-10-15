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
    final status = switch ((json['status'] as String?)?.toLowerCase()) {
      'accepted' => JoinRequestStatus.accepted,
      'rejected' => JoinRequestStatus.rejected,
      'cancelled' => JoinRequestStatus.cancelled,
      _ => JoinRequestStatus.pending,
    };
    return JoinRequestModel(
      id: json['id'] as String,
      requestId: json['request_id'] as String,
      userId: json['user_id'] as String,
      status: status,
      message: json['message'] as String?,
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '')?.toUtc() ??
          DateTime.now().toUtc(),
      userProfile: json['profiles'] == null
          ? null
          : UserProfile.fromJson(json['profiles'] as Map<String, dynamic>),
      request: json['requests'] == null
          ? null
          : RequestModel.fromJson(json['requests'] as Map<String, dynamic>),
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
