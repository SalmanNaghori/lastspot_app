import 'package:lastspot_app/core/base_import.dart';

import 'activities_screen_mobile.dart';
import 'activities_screen_tablet.dart';

class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: ActivitiesScreenMobile(),
      tablet: ActivitiesScreenTablet(),
    );
  }
}
