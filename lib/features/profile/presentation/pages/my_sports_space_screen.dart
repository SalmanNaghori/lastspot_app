import '../../../../core/base_import.dart';
import '../bloc/my_sports_space_cubit.dart';
import '../bloc/my_sports_space_state.dart';
import 'my_sports_space_screen_mobile.dart';
import 'my_sports_space_screen_tablet.dart';

/// My Sports Space Dashboard screen entry point.
///
/// Provides [MySportsSpaceCubit] and handles responsive layout for mobile and tablet.
class MySportsSpaceScreen extends StatelessWidget {
  const MySportsSpaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MySportsSpaceCubit>(
      create: (context) => sl<MySportsSpaceCubit>()..loadDashboard(),
      child: BlocBuilder<MySportsSpaceCubit, MySportsSpaceState>(
        builder: (context, state) {
          final cubit = context.read<MySportsSpaceCubit>();

          return ResponsiveLayout(
            mobile: MySportsSpaceScreenMobile(
              state: state,
              onRefresh: () => cubit.loadDashboard(isRefresh: true),
            ),
            tablet: MySportsSpaceScreenTablet(
              state: state,
              onRefresh: () => cubit.loadDashboard(isRefresh: true),
            ),
          );
        },
      ),
    );
  }
}
