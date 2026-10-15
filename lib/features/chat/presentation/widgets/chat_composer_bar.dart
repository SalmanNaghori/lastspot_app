import '../../../../core/base_import.dart';

/// WhatsApp-inspired multiline chat composer.
///
/// Features:
/// - Rounded input expanding from 1 to 5 lines
/// - ValueNotifier-driven send button (no whole-screen rebuild on keystrokes)
/// - Draft preservation when sending fails
/// - Native emoji, unicode, and system keyboard support
/// - Duplicate send prevention
class ChatComposerBar extends StatefulWidget {
  final bool isSending;
  final Future<bool> Function(String text) onSend;

  const ChatComposerBar({
    super.key,
    required this.isSending,
    required this.onSend,
  });

  @override
  State<ChatComposerBar> createState() => _ChatComposerBarState();
}

class _ChatComposerBarState extends State<ChatComposerBar> {
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<bool> _canSend = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final can = _controller.text.trim().isNotEmpty;
    if (_canSend.value != can) {
      _canSend.value = can;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _canSend.dispose();
    super.dispose();
  }

  Future<void> _handleSend() async {
    final text = _controller.text;
    if (text.trim().isEmpty || widget.isSending) return;

    final success = await widget.onSend(text);
    if (success && mounted) {
      _controller.clear();
      _canSend.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(
            top: BorderSide(
              color: colors.outlineVariant.withValues(alpha: 0.5),
              width: 0.5,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.blackColor.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 130),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLow,
                  borderRadius: AppRadius.xxlBorderRadius,
                  border: Border.all(
                    color: colors.outlineVariant.withValues(alpha: 0.4),
                    width: 0.5,
                  ),
                ),
                child: TextField(
                  controller: _controller,
                  minLines: 1,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  style: context.bodyMedium,
                  decoration: InputDecoration(
                    hintText: context.loc.messageHint,
                    hintStyle: context.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.smLg,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            ValueListenableBuilder<bool>(
              valueListenable: _canSend,
              builder: (context, canSend, _) {
                final isEnabled = canSend && !widget.isSending;
                return Material(
                  color: isEnabled
                      ? colors.primary
                      : colors.surfaceContainerHigh,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: isEnabled ? _handleSend : null,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: widget.isSending
                          ? SizedBox.square(
                              dimension: Dimensions.r20.dynamicH,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  colors.onPrimary,
                                ),
                              ),
                            )
                          : Icon(
                              Icons.send_rounded,
                              size: Dimensions.r20.dynamicH,
                              color: isEnabled
                                  ? colors.onPrimary
                                  : colors.onSurfaceVariant.withValues(
                                      alpha: 0.5,
                                    ),
                            ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
