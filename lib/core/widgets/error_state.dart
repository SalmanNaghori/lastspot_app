import '../base_import.dart';

class ErrorState extends StatelessWidget {
  final String message;
  final String? actionLabel;
  final VoidCallback? onRetry;
  final bool isNetwork;

  const ErrorState({
    super.key,
    required this.message,
    this.actionLabel,
    this.onRetry,
    this.isNetwork = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(Dimensions.r24.dynamicW),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.bodyLarge?.copyWith(
                color: context.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (onRetry != null) ...[
              SizedBox(height: Dimensions.r20.dynamicH),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: context.primaryColor,
                  foregroundColor: AppColor.whiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      Dimensions.r12.dynamicR,
                    ),
                  ),
                ),
                onPressed: onRetry,
                child: Text(actionLabel ?? context.loc.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
