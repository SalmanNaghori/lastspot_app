import '../../../../features/auth/domain/entities/user_profile.dart';
import '../../../../features/spot/domain/entities/join_request_entity.dart';
import '../../../../features/spot/domain/entities/request_entity.dart';

class MySportsSpaceData {
  final UserProfile profile;
  final List<RequestEntity> allActivities;
  final List<JoinRequestEntity> sentRequests;
  final int hostedCount;
  final int joinedCount;
  final int upcomingCount;
  final int completedCount;
  final List<RequestEntity> upcomingActivities;
  final List<RequestEntity> hostedActivities;
  final List<RequestEntity> joinedActivities;
  final List<RequestEntity> completedActivities;
  final List<RequestEntity> pastActivities;

  const MySportsSpaceData({
    required this.profile,
    required this.allActivities,
    required this.sentRequests,
    required this.hostedCount,
    required this.joinedCount,
    required this.upcomingCount,
    required this.completedCount,
    required this.upcomingActivities,
    required this.hostedActivities,
    required this.joinedActivities,
    required this.completedActivities,
    required this.pastActivities,
  });
}

sealed class MySportsSpaceState {
  const MySportsSpaceState();
}

class MySportsSpaceInitial extends MySportsSpaceState {
  const MySportsSpaceInitial();
}

class MySportsSpaceLoading extends MySportsSpaceState {
  const MySportsSpaceLoading();
}

class MySportsSpaceLoaded extends MySportsSpaceState {
  final MySportsSpaceData data;
  final bool isRefreshing;

  const MySportsSpaceLoaded({required this.data, this.isRefreshing = false});

  MySportsSpaceLoaded copyWith({MySportsSpaceData? data, bool? isRefreshing}) {
    return MySportsSpaceLoaded(
      data: data ?? this.data,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

class MySportsSpaceError extends MySportsSpaceState {
  final String message;
  final bool isNetworkError;

  const MySportsSpaceError({
    required this.message,
    this.isNetworkError = false,
  });
}
