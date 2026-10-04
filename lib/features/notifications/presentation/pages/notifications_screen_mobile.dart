import 'package:lastspot_app/core/base_import.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/notifications_list_cubit.dart';
import '../bloc/notifications_list_state.dart';
import '../widgets/notification_item.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationsScreenMobile extends StatefulWidget {
  const NotificationsScreenMobile({super.key});

  @override
  State<NotificationsScreenMobile> createState() =>
      _NotificationsScreenMobileState();
}

class _NotificationsScreenMobileState extends State<NotificationsScreenMobile> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<NotificationsListCubit>().fetchNotifications();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onNotificationTap(NotificationEntity notification) {
    if (!notification.isRead) {
      context.read<NotificationsListCubit>().markAsRead(notification.id);
    }

    if (notification.type == 'join_request') {
      context.push(
        AppRoutes.manageRequestsPath(notification.data['request_id'] ?? ''),
      );
    } else if ([
      'join_accepted',
      'join_rejected',
      'broadcast',
    ].contains(notification.type)) {
      context.push(
        AppRoutes.spotDetailsPath(notification.data['request_id'] ?? ''),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: CustomAppBar.defaultAppBar(
        context: context,
        title: 'Notifications',
        actions: [
          TextButton(
            onPressed: () {
              context.read<NotificationsListCubit>().markAllAsRead();
            },
            child: Text(
              'Mark all read',
              style: TextStyle(
                color: context.primaryColor,
                fontSize: Dimensions.r14.dynamicSP,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<NotificationsListCubit, NotificationsListState>(
        builder: (context, state) {
          if (state is NotificationsListInitial ||
              (state is NotificationsListLoading &&
                  state is! NotificationsListLoaded)) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotificationsListError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: Dimensions.r48.dynamicH,
                    color: context.errorColor,
                  ),
                  SizedBox(height: Dimensions.r16.dynamicH),
                  Text(state.message, style: context.bodyLarge),
                  SizedBox(height: Dimensions.r16.dynamicH),
                  FilledButton(
                    onPressed: () => context
                        .read<NotificationsListCubit>()
                        .fetchNotifications(refresh: true),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          } else if (state is NotificationsListLoaded) {
            if (state.notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none,
                      size: Dimensions.r64.dynamicH,
                      color: context.textSecondary.withValues(alpha: 0.5),
                    ),
                    SizedBox(height: Dimensions.r16.dynamicH),
                    Text(
                      'No notifications yet',
                      style: TextStyle(
                        fontSize: Dimensions.r18.dynamicSP,
                        fontWeight: FontWeight.w600,
                        color: context.textPrimary,
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context
                  .read<NotificationsListCubit>()
                  .fetchNotifications(refresh: true),
              color: context.primaryColor,
              child: ListView.separated(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount:
                    state.notifications.length + (state.hasReachedMax ? 0 : 1),
                separatorBuilder: (context, index) =>
                    Divider(height: 1, color: context.borderColor),
                itemBuilder: (context, index) {
                  if (index >= state.notifications.length) {
                    return Padding(
                      padding: EdgeInsets.all(Dimensions.r16.dynamicH),
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }

                  final notification = state.notifications[index];
                  return NotificationItem(
                    notification: notification,
                    onTap: () => _onNotificationTap(notification),
                    onDismiss: () => context
                        .read<NotificationsListCubit>()
                        .deleteNotification(notification.id),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
