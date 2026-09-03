import 'package:lastspot_app/core/base_import.dart';
import '../bloc/settings_cubit.dart';
import '../bloc/settings_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
              _buildSectionTitle(context, context.loc.themeTitle),
              _buildThemeSelector(context, state),
              const SizedBox(height: Dimensions.r24),
              _buildSectionTitle(context, context.loc.languageTitle),
              _buildLanguageSelector(context, state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.r8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: context.textSecondary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context, SettingsState state) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(Dimensions.r12),
      ),
      child: Column(
        children: [
          _buildRadioListTile<ThemeMode>(
            context,
            title: context.loc.themeSystem,
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
          _buildRadioListTile<ThemeMode>(
            context,
            title: context.loc.themeLight,
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
          _buildRadioListTile<ThemeMode>(
            context,
            title: context.loc.themeDark,
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

  Widget _buildLanguageSelector(BuildContext context, SettingsState state) {
    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(Dimensions.r12),
      ),
      child: Column(
        children: [
          _buildRadioListTile<String>(
            context,
            title: context.loc.languageEnglish,
            value: 'en',
            groupValue: state.locale,
            onChanged: (locale) {
              if (locale != null) {
                context.read<SettingsCubit>().updateLocale(locale);
              }
            },
          ),
          // Add more languages here as needed, e.g., French
          // const Divider(height: 1, indent: Dimensions.r16, endIndent: Dimensions.r16),
          // _buildRadioListTile<String>(
          //   context,
          //   title: context.loc.languageFrench,
          //   value: 'fr',
          //   groupValue: state.locale,
          //   onChanged: (locale) {
          //     if (locale != null) {
          //       context.read<SettingsCubit>().updateLocale(locale);
          //     }
          //   },
          // ),
        ],
      ),
    );
  }

  Widget _buildRadioListTile<T>(
    BuildContext context, {
    required String title,
    required T value,
    required T groupValue,
    required ValueChanged<T?> onChanged,
  }) {
    return RadioListTile<T>(
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: AppColor.primaryColor,
      controlAffinity: ListTileControlAffinity.trailing,
      contentPadding: const EdgeInsets.symmetric(horizontal: Dimensions.r16),
    );
  }
}
