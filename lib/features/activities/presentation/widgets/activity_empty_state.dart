import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/gen/assets.gen.dart';
import 'package:lottie/lottie.dart';

class ActivityEmptyState extends StatelessWidget {
  final String title;
  final String message;
  final String? actionText;
  final VoidCallback? onAction;

  const ActivityEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(Dimensions.r32.dynamicW),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: Dimensions.r32.dynamicH),
            SizedBox(
              height: Dimensions.h(180),
              child: Lottie.asset(
                Assets.ain.anNoData.path,
                repeat: true,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: Dimensions.r24.dynamicH),
            Text(
              title,
              style: context.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Dimensions.r12.dynamicH),
            Text(
              message,
              style: context.bodyLarge?.copyWith(color: context.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onAction != null) ...[
              SizedBox(height: Dimensions.r32.dynamicH),
              FilledButton(onPressed: onAction, child: Text(actionText!)),
            ],
            SizedBox(height: Dimensions.r64.dynamicH),
          ],
        ),
      ),
    );
  }
}
