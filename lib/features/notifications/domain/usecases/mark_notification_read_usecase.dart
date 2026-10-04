import '../repositories/notifications_repository.dart';

class MarkNotificationReadUseCase {
  final NotificationsRepository repository;

  MarkNotificationReadUseCase(this.repository);

  Future<void> call(String id) async {
    return await repository.markNotificationRead(id);
  }
}
