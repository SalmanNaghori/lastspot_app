import '../base_import.dart';

/// App-wide standard error state widget supporting network and server failure states.
class AppErrorState extends StatelessWidget {
  final String message;
  final String? title;
  final String? actionLabel;
  final VoidCallback? onRetry;
  final bool isNetwork;

  const AppErrorState({
    super.key,
    required this.message,
    this.title,
    this.actionLabel,
    this.onRetry,
    this.isNetwork = false,
  });

  const AppErrorState.network({
    super.key,
    required this.message,
    this.title,
    this.actionLabel,
    this.onRetry,
  }) : isNetwork = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(Dimensions.r24.dynamicW),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: Dimensions.r72.dynamicW,
              height: Dimensions.r72.dynamicH,
              decoration: BoxDecoration(
                color: context.errorColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isNetwork
                    ? Icons.wifi_off_rounded
                    : Icons.error_outline_rounded,
                size: Dimensions.r36.dynamicH,
                color: context.errorColor,
              ),
            ),
            SizedBox(height: Dimensions.r16.dynamicH),
            if (title != null) ...[
              Text(
                title!,
                textAlign: TextAlign.center,
                style: context.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.textPrimary,
                ),
              ),
              SizedBox(height: Dimensions.r8.dynamicH),
            ],
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.bodyLarge?.copyWith(
                color: context.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (onRetry != null) ...[
              SizedBox(height: Dimensions.r20.dynamicH),
              AppButton(
                label: actionLabel ?? context.loc.retry,
                onPressed: onRetry,
                type: AppButtonType.primary,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Backwards-compatibility alias
typedef ErrorState = AppErrorState;
