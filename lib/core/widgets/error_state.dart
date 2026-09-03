import '../base_import.dart';

class ErrorState extends StatelessWidget {
  final String message;
  final String? actionLabel;
  final VoidCallback? onRetry;

  const ErrorState({
    super.key,
    required this.message,
    this.actionLabel,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.r24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: Dimensions.r48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: Dimensions.r16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: Dimensions.r24),
              FilledButton.tonal(
                onPressed: onRetry,
                child: Text(actionLabel ?? 'Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
