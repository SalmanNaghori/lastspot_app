import 'package:lastspot_app/core/base_import.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatScreen extends StatelessWidget {
  final String spotId;
  final String? recipientUserId;
  final String? recipientName;

  const ChatScreen({
    super.key,
    required this.spotId,
    this.recipientUserId,
    this.recipientName,
  });

  bool get isDirectMessage => recipientUserId != null;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _SpotChatView(
        key: ValueKey('$spotId:$recipientUserId'),
        spotId: spotId,
        recipientUserId: recipientUserId,
        recipientName: recipientName,
      ),
      tablet: _SpotChatView(
        key: ValueKey('$spotId:$recipientUserId'),
        spotId: spotId,
        recipientUserId: recipientUserId,
        recipientName: recipientName,
      ),
    );
  }
}

class _SpotChatView extends StatefulWidget {
  final String spotId;
  final String? recipientUserId;
  final String? recipientName;

  const _SpotChatView({
    super.key,
    required this.spotId,
    this.recipientUserId,
    this.recipientName,
  });

  @override
  State<_SpotChatView> createState() => _SpotChatViewState();
}

class _SpotChatViewState extends State<_SpotChatView> {
  final _messageController = TextEditingController();
  late final Stream<List<Map<String, dynamic>>> _messageStream;
  bool _sending = false;

  bool get _isDirectMessage => widget.recipientUserId != null;

  @override
  void initState() {
    super.initState();
    final client = Supabase.instance.client;
    final userId = client.auth.currentUser?.id;
    var stream = client
        .from('spot_messages')
        .stream(primaryKey: ['id'])
        .eq('spot_id', widget.spotId);
    if (_isDirectMessage && userId != null) {
      stream = stream
          .inFilter('sender_id', [userId, widget.recipientUserId!])
          .inFilter('recipient_id', [userId, widget.recipientUserId!]);
    } else if (!_isDirectMessage) {
      stream = stream.isFilter('recipient_id', null);
    }
    _messageStream = stream.order('created_at', ascending: true).asyncMap((
      messages,
    ) async {
      if (messages.isEmpty) return messages;
      final senderIds = messages
          .map((message) => message['sender_id'] as String)
          .toSet()
          .toList();
      final profiles = await client
          .from('profiles')
          .select('id, full_name')
          .inFilter('id', senderIds);
      final names = {
        for (final profile in profiles)
          profile['id'] as String: profile['full_name'] as String?,
      };
      return messages
          .map(
            (message) => {
              ...message,
              'sender_name': names[message['sender_id']],
            },
          )
          .toList();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _visibleMessages(
    List<Map<String, dynamic>> messages,
    String userId,
  ) {
    if (!_isDirectMessage) {
      return messages
          .where((message) => message['recipient_id'] == null)
          .toList();
    }
    return messages.where((message) {
      final senderId = message['sender_id'] as String?;
      final recipientId = message['recipient_id'] as String?;
      return (senderId == userId && recipientId == widget.recipientUserId) ||
          (senderId == widget.recipientUserId && recipientId == userId);
    }).toList();
  }

  Future<void> _sendMessage() async {
    final body = _messageController.text.trim();
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (_sending || body.isEmpty || userId == null) return;

    setState(() => _sending = true);
    _messageController.clear();
    try {
      await Supabase.instance.client.from('spot_messages').insert({
        'spot_id': widget.spotId,
        'sender_id': userId,
        'recipient_id': widget.recipientUserId,
        'body': body,
      });
    } catch (_) {
      _messageController.text = body;
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.loc.messageSendFailed)));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final userId = Supabase.instance.client.auth.currentUser?.id;
    final title = _isDirectMessage
        ? (widget.recipientName?.trim().isNotEmpty == true
              ? widget.recipientName!.trim()
              : context.loc.directMessage)
        : context.loc.groupChat;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(title),
      ),
      body: Column(
        children: [
          Expanded(
            child: userId == null
                ? Center(child: Text(context.loc.signInToChat))
                : StreamBuilder<List<Map<String, dynamic>>>(
                    stream: _messageStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            child: Text(
                              snapshot.error.toString(),
                              textAlign: TextAlign.center,
                              style: context.bodyMedium?.copyWith(
                                color: colors.error,
                              ),
                            ),
                          ),
                        );
                      }
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final messages = _visibleMessages(snapshot.data!, userId);
                      if (messages.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.xl),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _isDirectMessage
                                      ? Icons.chat_bubble_outline
                                      : Icons.forum_outlined,
                                  size: 44,
                                  color: colors.onSurfaceVariant,
                                ),
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  context.loc.chatEmpty,
                                  textAlign: TextAlign.center,
                                  style: context.bodyMedium?.copyWith(
                                    color: colors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.all(AppSpacing.md),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[messages.length - 1 - index];
                          return _MessageBubble(
                            message: message,
                            isMine: message['sender_id'] == userId,
                            isGroup: !_isDirectMessage,
                          );
                        },
                      );
                    },
                  ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: colors.surface,
                border: Border(top: BorderSide(color: colors.outlineVariant)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      minLines: 1,
                      maxLines: 5,
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: context.loc.messageHint,
                        filled: true,
                        fillColor: colors.surfaceContainerLow,
                        border: OutlineInputBorder(
                          borderRadius: AppRadius.xlBorderRadius,
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: AppRadius.xlBorderRadius,
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton.filled(
                    tooltip: context.loc.sendMessage,
                    onPressed: _sending ? null : _sendMessage,
                    icon: _sending
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isMine;
  final bool isGroup;

  const _MessageBubble({
    required this.message,
    required this.isMine,
    required this.isGroup,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final timestamp = DateTime.tryParse(
      message['created_at']?.toString() ?? '',
    );
    final bubbleColor = isMine ? colors.primaryContainer : colors.surface;
    final foreground = isMine ? colors.onPrimaryContainer : colors.onSurface;
    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.78,
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.smLg,
          ),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: AppRadius.lgBorderRadius,
            border: isMine ? null : Border.all(color: colors.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isGroup && !isMine) ...[
                Text(
                  message['sender_name']?.toString() ?? context.loc.player,
                  style: context.labelSmall?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
              ],
              Text(
                message['body']?.toString() ?? '',
                style: context.bodyMedium?.copyWith(color: foreground),
              ),
              if (timestamp != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  AppUtils.formatTime(timestamp.toLocal()),
                  style: context.labelSmall?.copyWith(
                    color: foreground.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
