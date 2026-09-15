import 'package:lastspot_app/core/base_import.dart';
import '../bloc/activities_bloc.dart';
import '../bloc/activities_state.dart';
import '../../../spot/presentation/widgets/home_spot_card.dart';

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
          child: BlocBuilder<ActivitiesBloc, ActivitiesState>(
            builder: (context, state) {
              if (state is ActivitiesLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ActivitiesLoaded) {
                if (state.activities.isEmpty) {
                  return EmptyState(
                    message: loc.activitiesEmptyMessage,
                    actionLabel: loc.exploreActivitiesAction,
                    onActionPressed: () {
                      context.go(AppRoutes.explore);
                    },
                  );
                }
                return GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: Dimensions.r16.dynamicW,
                    mainAxisSpacing: Dimensions.r16.dynamicH,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: state.activities.length,
                  itemBuilder: (context, index) {
                    return HomeSpotCard(
                      spot: state.activities[index],
                      heroTagPrefix: 'activities',
                      onTap: () {
                        context.safePush(AppRoutes.spotDetailsPath(state.activities[index].id));
                      },
                    );
                  },
                );
              } else if (state is ActivitiesError) {
                return Center(child: Text(state.message, style: TextStyle(color: context.errorColor)));
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
