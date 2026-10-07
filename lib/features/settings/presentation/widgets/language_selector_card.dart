import 'package:lastspot_app/core/base_import.dart';
import '../bloc/settings_cubit.dart';
import '../bloc/settings_state.dart';
import 'interactive_settings_tile.dart';

class LanguageSelectorCard extends StatelessWidget {
  final SettingsState state;

  const LanguageSelectorCard({
    super.key,
    required this.state,
  });

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
        ],
      ),
    );
  }
}
