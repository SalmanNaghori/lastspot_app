import 'package:lastspot_app/core/base_import.dart';
import '../bloc/settings_cubit.dart';
import '../bloc/settings_state.dart';
import 'interactive_settings_tile.dart';

class ThemeSelectorCard extends StatelessWidget {
  final SettingsState state;

  const ThemeSelectorCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.surfaceColor,
      borderRadius: BorderRadius.circular(Dimensions.r12),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InteractiveSettingsTile<ThemeMode>(
            title: context.loc.themeSystem,
            icon: Icons.brightness_auto_outlined,
            value: ThemeMode.system,
            groupValue: state.themeMode,
            onChanged: (mode) {
              if (mode != null) {
                context.read<SettingsCubit>().updateThemeMode(mode);
              }
            },
          ),
          const Divider(
            height: 1,
            indent: Dimensions.r16,
            endIndent: Dimensions.r16,
          ),
          InteractiveSettingsTile<ThemeMode>(
            title: context.loc.themeLight,
            icon: Icons.light_mode_outlined,
            value: ThemeMode.light,
            groupValue: state.themeMode,
            onChanged: (mode) {
              if (mode != null) {
                context.read<SettingsCubit>().updateThemeMode(mode);
              }
            },
          ),
          const Divider(
            height: 1,
            indent: Dimensions.r16,
            endIndent: Dimensions.r16,
          ),
          InteractiveSettingsTile<ThemeMode>(
            title: context.loc.themeDark,
            icon: Icons.dark_mode_outlined,
            value: ThemeMode.dark,
            groupValue: state.themeMode,
            onChanged: (mode) {
              if (mode != null) {
                context.read<SettingsCubit>().updateThemeMode(mode);
              }
            },
          ),
        ],
      ),
    );
  }
}
