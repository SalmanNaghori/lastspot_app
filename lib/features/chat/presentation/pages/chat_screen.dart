import '../../../../core/base_import.dart';

import '../bloc/chat_cubit.dart';
import '../bloc/chat_state.dart';
import '../../../../core/services/chat_visibility_tracker.dart';
import '../../../../core/services/in_app_feedback_manager.dart';
import 'chat_screen_mobile.dart';
import 'chat_screen_tablet.dart';

class ChatScreen extends StatefulWidget {
  final String id;
  final bool isConversationId;
  final bool? isDirect;
  final String? recipientUserId;
  final String? recipientName;
  final String? recipientAvatarUrl;
  final String? category;
  final String? activityTitle;
  final String? requestId;

  const ChatScreen({
    super.key,
    required this.id,
    this.isConversationId = false,
    this.isDirect,
    this.recipientUserId,
    this.recipientName,
    this.recipientAvatarUrl,
    this.category,
    this.activityTitle,
    this.requestId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  InAppFeedbackManager? _feedbackManager;
  String? _openedConversationId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _feedbackManager = context.read<InAppFeedbackManager>();
    _feedbackManager?.clearTransient();
    _feedbackManager?.dismissConversation(widget.id);
    final requestId =
        widget.requestId ?? (widget.isConversationId ? null : widget.id);
    if (widget.isConversationId) {
      _feedbackManager?.openConversation(widget.id, requestId: requestId);
      if (sl.isRegistered<ChatVisibilityTracker>()) {
        sl<ChatVisibilityTracker>().enterConversation(
          conversationId: widget.id,
          chatType: widget.isDirect == true ? 'direct' : 'group',
          requestId: requestId,
        );
      }
    } else {
      _feedbackManager?.openConversationRequest(requestId!);
    }
  }

  @override
  void dispose() {
    final convId = _openedConversationId ?? widget.id;
    if (sl.isRegistered<ChatVisibilityTracker>()) {
      sl<ChatVisibilityTracker>().leaveConversation(convId);
    }
    _feedbackManager?.closeConversation(
      _openedConversationId ?? '',
      requestId:
          widget.requestId ?? (widget.isConversationId ? null : widget.id),
    );
    _feedbackManager?.clearTransient();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final direct = widget.isDirect ?? (widget.recipientUserId != null);
    return BlocProvider(
      create: (context) {
        final cubit = sl<ChatCubit>();
        if (widget.isConversationId) {
          cubit.initialize(
            conversationId: widget.id,
            requestId: widget.requestId,
            isDirect: direct,
            recipientName: widget.recipientName,
            activityTitle: widget.activityTitle,
          );
        } else {
          cubit.initialize(
            requestId: widget.id,
            isDirect: direct,
            recipientName: widget.recipientName,
            activityTitle: widget.activityTitle,
          );
        }
        return cubit;
      },
      child: BlocListener<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state is ChatLoaded) {
            _openedConversationId = state.conversationId;
            if (sl.isRegistered<ChatVisibilityTracker>()) {
              sl<ChatVisibilityTracker>().enterConversation(
                conversationId: state.conversationId,
                chatType: state.isDirect ? 'direct' : 'group',
                requestId: state.requestId,
              );
            }
            _feedbackManager?.openConversation(
              state.conversationId,
              requestId:
                  state.requestId ??
                  (widget.isConversationId ? null : widget.id),
            );
          }
        },
        child: ResponsiveLayout(
          mobile: ChatScreenMobile(
            avatarUrl: widget.recipientAvatarUrl,
            category: widget.category,
          ),
          tablet: ChatScreenTablet(
            avatarUrl: widget.recipientAvatarUrl,
            category: widget.category,
          ),
        ),
      ),
    );
  }
}
