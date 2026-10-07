import 'package:lastspot_app/core/base_import.dart';
import 'settings_screen_mobile.dart';
import 'settings_screen_tablet.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResponsiveLayout(
      mobile: SettingsScreenMobile(),
      tablet: SettingsScreenTablet(),
    );
  }
}
