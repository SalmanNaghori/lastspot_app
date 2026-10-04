import '../repositories/notifications_repository.dart';

class DeleteNotificationUseCase {
  final NotificationsRepository repository;

  DeleteNotificationUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteNotification(id);
  }
}
