import 'package:lastspot_app/core/base_import.dart';
import '../bloc/notifications_list_cubit.dart';
import '../bloc/notifications_list_state.dart';
import '../widgets/notification_item.dart';
import '../../domain/entities/notification_entity.dart';
import '../../../../core/services/in_app_feedback_manager.dart';

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

    if (InAppFeedbackManager.isChatMessage(
      notification.data,
      type: notification.type,
    )) {
      final conversationId = InAppFeedbackManager.conversationIdFrom(
        notification.data,
      );
      if (conversationId == null ||
          !InAppFeedbackManager.isSafeRouteIdentifier(conversationId)) {
        return;
      }
      context.push(
        AppRoutes.conversationChatPath(
          conversationId,
          isDirect:
              notification.data['is_direct']?.toString() == 'true' ||
              notification.data['chat_type']?.toString().toLowerCase() ==
                  'direct',
          name: InAppFeedbackManager.senderNameFrom(notification.data),
          activityTitle: InAppFeedbackManager.activityNameFrom(
            notification.data,
          ),
          requestId: notification.data['request_id']?.toString(),
        ),
      );
      return;
    }

    // Activity notifications carry one of the existing activity identifiers.
    // The backend might send 'request_id', 'activity_id', or 'spot_id' depending on the event.
    final String targetId =
        notification.data['request_id']?.toString() ??
        notification.data['activity_id']?.toString() ??
        notification.data['spot_id']?.toString() ??
        '';

    if (targetId.isEmpty) {
      return;
    }

    if (notification.type == 'join_request') {
      context.push(AppRoutes.manageRequestsPath(targetId));
    } else if ([
      'join_accepted',
      'join_rejected',
      'broadcast',
      'spot_updated',
      'spot_cancelled',
    ].contains(notification.type)) {
      context.push(AppRoutes.spotDetailsPath(targetId));
    } else {
      // Fallback for general activity notifications
      context.push(AppRoutes.spotDetailsPath(targetId));
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
            return const Center(child: AppLoading());
          } else if (state is NotificationsListError) {
            return Center(
              child: AppErrorState(
                message: state.message,
                onRetry: () => context
                    .read<NotificationsListCubit>()
                    .fetchNotifications(refresh: true),
              ),
            );
          } else if (state is NotificationsListLoaded) {
            if (state.notifications.isEmpty) {
              return Center(
                child: AppEmptyState.notifications(
                  title: context.loc.notifications,
                  message: '',
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
                      child: const Center(child: AppLoading(size: 24)),
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
