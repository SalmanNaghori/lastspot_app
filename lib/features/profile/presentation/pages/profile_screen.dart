import 'package:lastspot_app/core/base_import.dart';
import 'my_sports_space_screen.dart';

/// Profile screen entry point displaying the user's personal [MySportsSpaceScreen].
///
/// Features:
/// - Replaces generic profile page with the dedicated sports space dashboard.
/// - Preserves backward compatibility across all existing profile route entries.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MySportsSpaceScreen();
  }
}
