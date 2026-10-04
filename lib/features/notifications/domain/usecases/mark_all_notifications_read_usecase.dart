import '../repositories/notifications_repository.dart';

class MarkAllNotificationsReadUseCase {
  final NotificationsRepository repository;

  MarkAllNotificationsReadUseCase(this.repository);

  Future<void> call() async {
    return await repository.markAllNotificationsRead();
  }
}
