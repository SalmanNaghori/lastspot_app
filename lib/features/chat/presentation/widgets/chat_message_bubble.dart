import 'package:flutter/gestures.dart';

import '../../../../core/base_import.dart';

import '../../domain/entities/chat_message_entity.dart';
import '../utils/chat_text_formatter.dart';

/// WhatsApp-inspired message bubble with formatted text, directional corners,
/// sender labeling in group chats, timestamp, and selectable original text.
class ChatMessageBubble extends StatefulWidget {
  final ChatMessageEntity message;
  final bool isMine;
  final bool isGroup;
  final bool isFirstInStreak;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isMine,
    required this.isGroup,
    this.isFirstInStreak = true,
  });

  @override
  State<ChatMessageBubble> createState() => _ChatMessageBubbleState();
}

class _ChatMessageBubbleState extends State<ChatMessageBubble> {
  final Map<String, TapGestureRecognizer> _urlRecognizers = {};

  void _onUrlTap(String url) => AppUtils.launchWebUrl(url);

  @override
  void didUpdateWidget(covariant ChatMessageBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.message.id != widget.message.id ||
        oldWidget.message.content != widget.message.content) {
      _disposeUrlRecognizers();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final bubbleColor = widget.isMine
        ? colors.primaryContainer.withValues(alpha: 0.9)
        : colors.surfaceContainerLow;
    final foreground = widget.isMine
        ? colors.onPrimaryContainer
        : colors.onSurface;
    final timeColor = foreground.withValues(alpha: 0.65);
    final linkColor = colors.primary;
    final codeBackground = widget.isMine
        ? colors.onPrimaryContainer.withValues(alpha: 0.1)
        : colors.outlineVariant.withValues(alpha: 0.3);

    // Directional WhatsApp-inspired radius
    final borderRadius = BorderRadius.only(
      topLeft: Radius.circular(
        !widget.isMine && widget.isFirstInStreak ? 4 : Dimensions.r16,
      ),
      topRight: Radius.circular(
        widget.isMine && widget.isFirstInStreak ? 4 : Dimensions.r16,
      ),
      bottomLeft: const Radius.circular(Dimensions.r16),
      bottomRight: const Radius.circular(Dimensions.r16),
    );

    final showSenderName =
        widget.isGroup &&
        !widget.isMine &&
        widget.isFirstInStreak &&
        widget.message.senderName != null &&
        widget.message.senderName!.trim().isNotEmpty;

    return Padding(
      padding: EdgeInsets.only(
        top: widget.isFirstInStreak ? AppSpacing.sm : 2,
        bottom: 2,
        left: widget.isMine ? AppSpacing.xxl : AppSpacing.md,
        right: widget.isMine ? AppSpacing.md : AppSpacing.xxl,
      ),
      child: Align(
        alignment: widget.isMine ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * 0.78,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: borderRadius,
            border: Border.all(
              color: widget.isMine
                  ? colors.primary.withValues(alpha: 0.12)
                  : colors.outlineVariant.withValues(alpha: 0.4),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColor.blackColor.withValues(alpha: 0.03),
                blurRadius: 3,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showSenderName) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Text(
                    widget.message.senderName!.trim(),
                    style: context.labelSmall?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
              SelectableText.rich(
                TextSpan(
                  children: ChatTextFormatter.buildSpans(
                    text: widget.message.content,
                    baseStyle: context.bodyMedium!.copyWith(
                      color: foreground,
                      height: 1.35,
                    ),
                    linkColor: linkColor,
                    codeBackground: codeBackground,
                    onUrlTap: _onUrlTap,
                    recognizerForUrl: (url) => _urlRecognizers.putIfAbsent(
                      url,
                      () =>
                          TapGestureRecognizer()..onTap = () => _onUrlTap(url),
                    ),
                  ),
                ),
                contextMenuBuilder: (context, selectableTextState) {
                  return AdaptiveTextSelectionToolbar.buttonItems(
                    anchors: selectableTextState.contextMenuAnchors,
                    buttonItems: [
                      ContextMenuButtonItem(
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(text: widget.message.content),
                          );
                          selectableTextState.hideToolbar();
                        },
                        type: ContextMenuButtonType.copy,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 3),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  AppUtils.formatTime(widget.message.createdAt.toLocal()),
                  style: context.labelSmall?.copyWith(
                    color: timeColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _disposeUrlRecognizers();
    super.dispose();
  }

  void _disposeUrlRecognizers() {
    for (final recognizer in _urlRecognizers.values) {
      recognizer.dispose();
    }
    _urlRecognizers.clear();
  }
}
