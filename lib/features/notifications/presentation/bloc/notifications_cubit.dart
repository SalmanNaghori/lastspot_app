import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'notifications_state.dart';
import '../../domain/usecases/get_unread_notification_count_usecase.dart';
import '../../domain/usecases/subscribe_to_notifications_usecase.dart';
import '../../data/models/notification_model.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final GetUnreadNotificationCountUseCase getUnreadCountUseCase;
  final SubscribeToNotificationsUseCase subscribeUseCase;

  StreamSubscription<PostgresChangePayload>? _subscription;

  final _newNotificationController =
      StreamController<NotificationModel>.broadcast();
  Stream<NotificationModel> get onNewNotification =>
      _newNotificationController.stream;

  NotificationsCubit({
    required this.getUnreadCountUseCase,
    required this.subscribeUseCase,
  }) : super(NotificationsInitial());

  void initialize(String userId) {
    _fetchUnreadCount();
    _subscription?.cancel();
    _subscription = subscribeUseCase(userId).listen((payload) {
      if (payload.eventType == PostgresChangeEvent.insert) {
        final newRecord = payload.newRecord;
        try {
          final model = NotificationModel.fromJson(newRecord);
          _newNotificationController.add(model);
        } catch (_) {}
      }
      _fetchUnreadCount();
    });
  }

  Future<void> _fetchUnreadCount() async {
    try {
      final count = await getUnreadCountUseCase();
      emit(NotificationsLoaded(count));
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }

  void refreshCount() {
    _fetchUnreadCount();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _newNotificationController.close();
    return super.close();
  }
}
