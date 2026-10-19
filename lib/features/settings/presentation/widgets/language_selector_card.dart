import 'package:lastspot_app/core/base_import.dart';
import '../bloc/settings_cubit.dart';
import '../bloc/settings_state.dart';
import 'interactive_settings_tile.dart';

class LanguageSelectorCard extends StatelessWidget {
  final SettingsState state;

  const LanguageSelectorCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.surfaceColor,
      borderRadius: BorderRadius.circular(Dimensions.r12),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InteractiveSettingsTile<String>(
            title: context.loc.languageEnglish,
            icon: Icons.language_outlined,
            value: 'en',
            groupValue: state.locale,
            onChanged: (locale) {
              if (locale != null) {
                context.read<SettingsCubit>().updateLocale(locale);
              }
            },
          ),
          const Divider(
            height: 1,
            indent: Dimensions.r16,
            endIndent: Dimensions.r16,
          ),
          InteractiveSettingsTile<String>(
            title: context.loc.languageHindi,
            icon: Icons.translate_rounded,
            value: 'hi',
            groupValue: state.locale,
            onChanged: (locale) {
              if (locale != null) {
                context.read<SettingsCubit>().updateLocale(locale);
              }
            },
          ),
          const Divider(
            height: 1,
            indent: Dimensions.r16,
            endIndent: Dimensions.r16,
          ),
          InteractiveSettingsTile<String>(
            title: context.loc.languageGujarati,
            icon: Icons.g_translate_rounded,
            value: 'gu',
            groupValue: state.locale,
            onChanged: (locale) {
              if (locale != null) {
                context.read<SettingsCubit>().updateLocale(locale);
              }
            },
          ),
        ],
      ),
    );
  }
}
