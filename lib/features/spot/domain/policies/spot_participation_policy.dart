import 'dart:math' as math;

import '../entities/join_request_entity.dart';
import '../entities/request_entity.dart';

/// Centralizes the existing participation rules for detail presentation.
/// The backend remains authoritative when a request is submitted.
abstract final class SpotParticipationPolicy {
  static const joiningCutoff = Duration(minutes: 15);

  static int remainingSpots(RequestEntity post) =>
      math.max(0, post.maxParticipants - post.currentParticipants);

  static double occupancy(RequestEntity post) => post.maxParticipants > 0
      ? (post.currentParticipants / post.maxParticipants).clamp(0.0, 1.0)
      : 0;

  static bool canEdit(RequestEntity post, {required bool isHost}) =>
      isHost &&
      (post.status == RequestStatus.open ||
          post.status == RequestStatus.full ||
          post.status == RequestStatus.draft);

  static SpotJoinAvailability availability({
    required RequestEntity post,
    JoinRequestEntity? request,
    required DateTime now,
  }) {
    switch (post.status) {
      case RequestStatus.cancelled:
        return SpotJoinAvailability.activityCancelled;
      case RequestStatus.completed:
        return SpotJoinAvailability.completed;
      case RequestStatus.expired:
        return SpotJoinAvailability.expired;
      case RequestStatus.draft:
        return SpotJoinAvailability.draft;
      case RequestStatus.open:
      case RequestStatus.full:
        break;
    }
    if (!post.eventDateTime.isAfter(now)) return SpotJoinAvailability.expired;
    if (request != null) {
      return switch (request.status) {
        JoinRequestStatus.pending => SpotJoinAvailability.pending,
        JoinRequestStatus.accepted => SpotJoinAvailability.accepted,
        JoinRequestStatus.rejected => SpotJoinAvailability.rejected,
        JoinRequestStatus.cancelled => SpotJoinAvailability.requestCancelled,
      };
    }
    if (post.status == RequestStatus.full || remainingSpots(post) == 0) {
      return SpotJoinAvailability.full;
    }
    if (post.eventDateTime.difference(now) < joiningCutoff) {
      return SpotJoinAvailability.closed;
    }
    return SpotJoinAvailability.available;
  }
}

/// Participation outcomes, independent of UI or asynchronous loading state.
enum SpotJoinAvailability {
  available,
  full,
  closed,
  pending,
  accepted,
  rejected,
  requestCancelled,
  activityCancelled,
  completed,
  expired,
  draft,
}
