import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_data_source.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;

  NotificationsRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<NotificationEntity>> getNotifications({
    required int limit,
    int? offset,
  }) async {
    return await remoteDataSource.getNotifications(
      limit: limit,
      offset: offset,
    );
  }

  @override
  Future<int> getUnreadNotificationCount() async {
    return await remoteDataSource.getUnreadNotificationCount();
  }

  @override
  Future<void> markAllNotificationsRead() async {
    await remoteDataSource.markAllNotificationsRead();
  }

  @override
  Future<void> markNotificationRead(String id) async {
    await remoteDataSource.markNotificationRead(id);
  }

  @override
  Future<void> deleteNotification(String id) async {
    await remoteDataSource.deleteNotification(id);
  }

  @override
  Stream<PostgresChangePayload> subscribeToNotifications(String userId) {
    return remoteDataSource.subscribeToNotifications(userId);
  }
}
