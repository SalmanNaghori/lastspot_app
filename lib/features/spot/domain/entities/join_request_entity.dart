import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user_profile.dart';
import 'request_entity.dart';

enum JoinRequestStatus { pending, accepted, rejected, cancelled }

class JoinRequestEntity extends Equatable {
  final String id;
  final String postId;
  final String userId;
  final JoinRequestStatus status;
  final String? message;
  final DateTime createdAt;
  final UserProfile? userProfile;
  final RequestEntity? post;

  const JoinRequestEntity({
    required this.id,
    required this.postId,
    required this.userId,
    this.status = JoinRequestStatus.pending,
    this.message,
    required this.createdAt,
    this.userProfile,
    this.post,
  });

  @override
  List<Object?> get props => [
    id,
    postId,
    userId,
    status,
    message,
    createdAt,
    userProfile,
    post,
  ];
}
