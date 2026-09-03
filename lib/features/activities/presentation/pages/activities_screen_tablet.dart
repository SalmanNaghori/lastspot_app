import 'package:lastspot_app/core/base_import.dart';

class ActivitiesScreenTablet extends StatelessWidget {
  const ActivitiesScreenTablet({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        title: Text(loc.navActivities),
        backgroundColor: context.backgroundColor,
        systemOverlayStyle: AppTheme.systemUiOverlayStyle(context),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 850),
          margin: const EdgeInsets.all(Dimensions.r24),
          padding: const EdgeInsets.all(Dimensions.r32),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(Dimensions.r20),
            border: Border.all(color: AppColor.helpCardBorderColor, width: 0.5),
            boxShadow: [
              BoxShadow(
                color: AppColor.blackColor.withValues(alpha: 0.04),
                blurRadius: Dimensions.r20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: EmptyState(
            message: loc.activitiesEmptyMessage,
            actionLabel: loc.exploreActivitiesAction,
            onActionPressed: () {
              context.go(AppRoutes.explore);
            },
          ),
        ),
      ),
    );
  }
}
