abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final int unreadCount;
  NotificationsLoaded(this.unreadCount);
}

class NotificationsError extends NotificationsState {
  final String message;
  NotificationsError(this.message);
}
