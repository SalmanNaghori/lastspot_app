import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'notifications_list_state.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_all_notifications_read_usecase.dart';
import '../../domain/usecases/mark_notification_read_usecase.dart';
import '../../domain/usecases/delete_notification_usecase.dart';
import '../../domain/entities/notification_entity.dart';
import 'notifications_cubit.dart';

class NotificationsListCubit extends Cubit<NotificationsListState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkAllNotificationsReadUseCase markAllReadUseCase;
  final MarkNotificationReadUseCase markReadUseCase;
  final DeleteNotificationUseCase deleteUseCase;
  final NotificationsCubit notificationsCubit;

  static const int _limit = 20;
  StreamSubscription? _newNotifSub;

  NotificationsListCubit({
    required this.getNotificationsUseCase,
    required this.markAllReadUseCase,
    required this.markReadUseCase,
    required this.deleteUseCase,
    required this.notificationsCubit,
  }) : super(NotificationsListInitial()) {
    _newNotifSub = notificationsCubit.onNewNotification.listen((newNotif) {
      if (state is NotificationsListLoaded) {
        final currentState = state as NotificationsListLoaded;
        if (!currentState.notifications.any((e) => e.id == newNotif.id)) {
          emit(
            currentState.copyWith(
              notifications: [newNotif, ...currentState.notifications],
            ),
          );
        }
      }
    });
  }

  Future<void> fetchNotifications({bool refresh = false}) async {
    try {
      if (refresh ||
          state is NotificationsListInitial ||
          state is NotificationsListError) {
        if (!refresh) emit(NotificationsListLoading());
        final items = await getNotificationsUseCase(limit: _limit, offset: 0);
        emit(
          NotificationsListLoaded(items, hasReachedMax: items.length < _limit),
        );
      } else if (state is NotificationsListLoaded) {
        final currentState = state as NotificationsListLoaded;
        if (currentState.hasReachedMax) return;

        final items = await getNotificationsUseCase(
          limit: _limit,
          offset: currentState.notifications.length,
        );
        emit(
          currentState.copyWith(
            notifications: List.of(currentState.notifications)..addAll(items),
            hasReachedMax: items.length < _limit,
          ),
        );
      }
    } catch (e) {
      if (state is! NotificationsListLoaded) {
        emit(NotificationsListError(e.toString()));
      }
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await markReadUseCase(id);
      if (state is NotificationsListLoaded) {
        final currentState = state as NotificationsListLoaded;
        final updated = currentState.notifications.map((n) {
          if (n.id == id && !n.isRead) {
            return _copyWithIsRead(n, true);
          }
          return n;
        }).toList();
        emit(currentState.copyWith(notifications: updated));
        notificationsCubit.refreshCount();
      }
    } catch (_) {}
  }

  Future<void> markAllAsRead() async {
    try {
      await markAllReadUseCase();
      if (state is NotificationsListLoaded) {
        final currentState = state as NotificationsListLoaded;
        final updated = currentState.notifications
            .map((n) => _copyWithIsRead(n, true))
            .toList();
        emit(currentState.copyWith(notifications: updated));
        notificationsCubit.refreshCount();
      }
    } catch (_) {}
  }

  Future<void> deleteNotification(String id) async {
    try {
      await deleteUseCase(id);
      if (state is NotificationsListLoaded) {
        final currentState = state as NotificationsListLoaded;
        final updated = currentState.notifications
            .where((n) => n.id != id)
            .toList();
        emit(currentState.copyWith(notifications: updated));
        notificationsCubit.refreshCount();
      }
    } catch (_) {}
  }

  NotificationEntity _copyWithIsRead(NotificationEntity n, bool isRead) {
    return NotificationEntity(
      id: n.id,
      userId: n.userId,
      title: n.title,
      body: n.body,
      type: n.type,
      data: n.data,
      isRead: isRead,
      createdAt: n.createdAt,
    );
  }

  @override
  Future<void> close() {
    _newNotifSub?.cancel();
    return super.close();
  }
}
