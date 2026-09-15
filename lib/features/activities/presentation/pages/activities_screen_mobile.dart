import 'package:lastspot_app/core/base_import.dart';

import '../bloc/activities_bloc.dart';
import '../bloc/activities_state.dart';
import '../../../spot/presentation/widgets/home_spot_card.dart';

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
        child: BlocBuilder<ActivitiesBloc, ActivitiesState>(
          builder: (context, state) {
            if (state is ActivitiesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ActivitiesLoaded) {
              if (state.activities.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(Dimensions.r24),
                  child: EmptyState(
                    message: loc.activitiesEmptyMessage,
                    actionLabel: loc.exploreActivitiesAction,
                    onActionPressed: () {
                      context.go(AppRoutes.explore);
                    },
                  ),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(Dimensions.r16),
                itemCount: state.activities.length,
                separatorBuilder: (context, index) => SizedBox(height: Dimensions.r16.dynamicH),
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
    );
  }
}
