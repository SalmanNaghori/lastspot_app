import '../../domain/entities/notification_entity.dart';

abstract class NotificationsListState {}

class NotificationsListInitial extends NotificationsListState {}

class NotificationsListLoading extends NotificationsListState {}

class NotificationsListLoaded extends NotificationsListState {
  final List<NotificationEntity> notifications;
  final bool hasReachedMax;

  NotificationsListLoaded(this.notifications, {this.hasReachedMax = false});

  NotificationsListLoaded copyWith({
    List<NotificationEntity>? notifications,
    bool? hasReachedMax,
  }) {
    return NotificationsListLoaded(
      notifications ?? this.notifications,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class NotificationsListError extends NotificationsListState {
  final String message;
  NotificationsListError(this.message);
}
