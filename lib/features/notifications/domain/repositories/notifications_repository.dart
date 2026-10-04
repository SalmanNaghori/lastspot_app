import 'package:supabase_flutter/supabase_flutter.dart';
import '../entities/notification_entity.dart';

abstract class NotificationsRepository {
  Future<List<NotificationEntity>> getNotifications({
    required int limit,
    int? offset,
  });
  Future<int> getUnreadNotificationCount();
  Future<void> markAllNotificationsRead();
  Future<void> markNotificationRead(String id);
  Future<void> deleteNotification(String id);
  Stream<PostgresChangePayload> subscribeToNotifications(String userId);
}
