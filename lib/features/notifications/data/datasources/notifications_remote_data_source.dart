import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/notification_model.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<NotificationModel>> getNotifications({
    required int limit,
    int? offset,
  });
  Future<int> getUnreadNotificationCount();
  Future<void> markAllNotificationsRead();
  Future<void> markNotificationRead(String id);
  Future<void> deleteNotification(String id);
  Stream<PostgresChangePayload> subscribeToNotifications(String userId);
}

class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  final SupabaseClient _supabaseClient;

  NotificationsRemoteDataSourceImpl(this._supabaseClient);

  @override
  Future<List<NotificationModel>> getNotifications({
    required int limit,
    int? offset,
  }) async {
    final query = _supabaseClient
        .from('notifications')
        .select()
        .order('created_at', ascending: false)
        .limit(limit);

    if (offset != null) {
      query.range(offset, offset + limit - 1);
    }

    final response = await query;
    return response.map((e) => NotificationModel.fromJson(e)).toList();
  }

  @override
  Future<int> getUnreadNotificationCount() async {
    final response = await _supabaseClient.rpc('get_unread_notification_count');
    return response as int;
  }

  @override
  Future<void> markAllNotificationsRead() async {
    await _supabaseClient.rpc('mark_all_notifications_read');
  }

  @override
  Future<void> markNotificationRead(String id) async {
    await _supabaseClient
        .from('notifications')
        .update({'is_read': true})
        .eq('id', id);
  }

  @override
  Future<void> deleteNotification(String id) async {
    await _supabaseClient.from('notifications').delete().eq('id', id);
  }

  @override
  Stream<PostgresChangePayload> subscribeToNotifications(String userId) {
    final controller = StreamController<PostgresChangePayload>.broadcast();
    final channel = _supabaseClient.channel(
      'public:notifications:user_$userId',
    );

    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            if (!controller.isClosed) {
              controller.add(payload);
            }
          },
        )
        .subscribe();

    controller.onCancel = () {
      _supabaseClient.removeChannel(channel);
    };

    return controller.stream;
  }
}
