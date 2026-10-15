import '../../../../core/base_import.dart';

/// Floating button to jump to the latest message when scrolled up.
class JumpToBottomButton extends StatelessWidget {
  final bool isVisible;
  final bool hasNewMessage;
  final VoidCallback onTap;

  const JumpToBottomButton({
    super.key,
    required this.isVisible,
    required this.hasNewMessage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    final colors = context.colorScheme;

    return Positioned(
      bottom: AppSpacing.md,
      right: AppSpacing.md,
      child: AnimatedScale(
        scale: isVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Material(
          color: colors.surfaceContainerHighest,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimensions.r20),
            side: BorderSide(
              color: colors.outlineVariant.withValues(alpha: 0.5),
              width: 0.5,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(Dimensions.r20),
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: hasNewMessage ? AppSpacing.md : AppSpacing.sm,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: colors.primary,
                  ),
                  if (hasNewMessage) ...[
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      context.loc.newMessage,
                      style: context.labelSmall?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
