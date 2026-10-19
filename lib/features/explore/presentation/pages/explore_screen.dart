import 'package:lastspot_app/core/base_import.dart';

import 'explore_screen_mobile.dart';
import 'explore_screen_tablet.dart';

class ExploreScreen extends StatelessWidget {
  final String? initialCategoryId;

  const ExploreScreen({super.key, this.initialCategoryId});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: ExploreScreenMobile(initialCategoryId: initialCategoryId),
      tablet: ExploreScreenTablet(initialCategoryId: initialCategoryId),
    );
  }
}
