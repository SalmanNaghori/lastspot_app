import '../../../auth/domain/entities/user_profile.dart';
import '../../domain/entities/join_request_entity.dart';
import 'request_model.dart';

class JoinRequestModel extends JoinRequestEntity {
  const JoinRequestModel({
    required super.id,
    required super.requestId,
    required super.userId,
    super.status = JoinRequestStatus.pending,
    super.message,
    required super.createdAt,
    super.userProfile,
    super.request,
  });

  factory JoinRequestModel.fromJson(Map<String, dynamic> json) {
    JoinRequestStatus parseStatus(String? statusStr) {
      switch (statusStr?.toLowerCase()) {
        case 'accepted':
          return JoinRequestStatus.accepted;
        case 'rejected':
          return JoinRequestStatus.rejected;
        case 'cancelled':
          return JoinRequestStatus.cancelled;
        case 'pending':
        default:
          return JoinRequestStatus.pending;
      }
    }

    return JoinRequestModel(
      id: json['id'] as String,
      requestId: json['request_id'] as String,
      userId: json['user_id'] as String,
      status: parseStatus(json['status'] as String?),
      message: json['message'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      userProfile: json['profiles'] != null
          ? UserProfile.fromJson(json['profiles'])
          : null,
      request: json['requests'] != null
          ? RequestModel.fromJson(json['requests'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'request_id': requestId,
      'user_id': userId,
      'status': status.name,
      'message': message,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
