import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/notifications_repository.dart';

class SubscribeToNotificationsUseCase {
  final NotificationsRepository repository;

  SubscribeToNotificationsUseCase(this.repository);

  Stream<PostgresChangePayload> call(String userId) {
    return repository.subscribeToNotifications(userId);
  }
}
