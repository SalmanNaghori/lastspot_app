import 'package:lastspot_app/core/base_import.dart';
import '../bloc/settings_cubit.dart';
import '../bloc/settings_state.dart';
import '../widgets/settings_section_title.dart';
import '../widgets/theme_selector_card.dart';
import '../widgets/app_color_selector_card.dart';
import '../widgets/language_selector_card.dart';

class SettingsScreenMobile extends StatelessWidget {
  const SettingsScreenMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: context.textPrimary),
        title: Text(
          context.loc.settingsTitle,
          style: context.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.profile);
            }
          },
        ),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(Dimensions.r16),
            children: [
              SettingsSectionTitle(title: context.loc.themeTitle),
              ThemeSelectorCard(state: state),
              const SizedBox(height: Dimensions.r24),
              const SettingsSectionTitle(title: 'App color'),
              AppColorSelectorCard(state: state),
              const SizedBox(height: Dimensions.r24),
              SettingsSectionTitle(title: context.loc.languageTitle),
              LanguageSelectorCard(state: state),
            ],
          );
        },
      ),
    );
  }
}
