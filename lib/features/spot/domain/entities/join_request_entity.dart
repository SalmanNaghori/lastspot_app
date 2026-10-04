import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user_profile.dart';
import 'request_entity.dart';

enum JoinRequestStatus { pending, accepted, rejected, cancelled }

class JoinRequestEntity extends Equatable {
  final String id;
  final String requestId;
  final String userId;
  final JoinRequestStatus status;
  final String? message;
  final DateTime createdAt;
  final UserProfile? userProfile;
  final RequestEntity? request;

  const JoinRequestEntity({
    required this.id,
    required this.requestId,
    required this.userId,
    this.status = JoinRequestStatus.pending,
    this.message,
    required this.createdAt,
    this.userProfile,
    this.request,
  });

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
}
