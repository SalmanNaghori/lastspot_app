import '../entities/notification_entity.dart';
import '../repositories/notifications_repository.dart';

class GetNotificationsUseCase {
  final NotificationsRepository repository;

  GetNotificationsUseCase(this.repository);

  Future<List<NotificationEntity>> call({
    required int limit,
    int? offset,
  }) async {
    return await repository.getNotifications(limit: limit, offset: offset);
  }
}
