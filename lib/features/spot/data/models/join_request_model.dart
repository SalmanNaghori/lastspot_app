import '../../../auth/data/models/profile_model.dart';
import '../../domain/entities/join_request_entity.dart';
import 'request_model.dart';

class JoinRequestModel extends JoinRequestEntity {
  const JoinRequestModel({
    required super.id,
    required super.postId,
    required super.userId,
    super.status = JoinRequestStatus.pending,
    super.message,
    required super.createdAt,
    super.userProfile,
    super.post,
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
      postId: json['post_id'] as String,
      userId: json['user_id'] as String,
      status: parseStatus(json['status'] as String?),
      message: json['message'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      userProfile: json['profiles'] != null
          ? ProfileModel.fromJson(json['profiles'])
          : null,
      post: json['posts'] != null ? RequestModel.fromJson(json['posts']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_id': postId,
      'user_id': userId,
      'status': status.name,
      'message': message,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
