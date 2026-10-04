import '../repositories/notifications_repository.dart';

class GetUnreadNotificationCountUseCase {
  final NotificationsRepository repository;

  GetUnreadNotificationCountUseCase(this.repository);

  Future<int> call() async {
    return await repository.getUnreadNotificationCount();
  }
}
