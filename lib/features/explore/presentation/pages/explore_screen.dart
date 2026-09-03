import 'package:lastspot_app/core/base_import.dart';

import 'explore_screen_mobile.dart';
import 'explore_screen_tablet.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: ExploreScreenMobile(),
      tablet: ExploreScreenTablet(),
    );
  }
}
