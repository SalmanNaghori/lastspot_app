import 'package:lastspot_app/core/base_import.dart';

class ActivitiesScreenMobile extends StatelessWidget {
  const ActivitiesScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        title: Text(loc.navActivities),
        backgroundColor: context.backgroundColor,
        systemOverlayStyle: AppTheme.systemUiOverlayStyle(context),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.r24),
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
