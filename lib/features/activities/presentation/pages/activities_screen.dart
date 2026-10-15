import 'package:lastspot_app/core/base_import.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../spot/domain/repositories/spot_repository.dart';
import '../bloc/activities_bloc.dart';
import '../bloc/activities_event.dart';
import 'activities_screen_mobile.dart';
import 'activities_screen_tablet.dart';

class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ActivitiesBloc>(
      create: (context) => ActivitiesBloc(
        spotRepository: sl<SpotRepository>(),
        authRepository: sl<AuthRepository>(),
      )..add(const LoadActivitiesEvent()),
      child: const ResponsiveLayout(
        mobile: ActivitiesScreenMobile(),
        tablet: ActivitiesScreenTablet(),
      ),
    );
  }
}
