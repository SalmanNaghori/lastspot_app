import 'package:lastspot_app/core/base_import.dart';
import '../../../../core/theme/app_color.dart';
import '../bloc/settings_cubit.dart';
import '../bloc/settings_state.dart';

class AppColorSelectorCard extends StatelessWidget {
  final SettingsState state;

  const AppColorSelectorCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.surfaceColor,
      borderRadius: BorderRadius.circular(Dimensions.r12),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (final themeColor in AppThemeColor.values) ...[
            if (themeColor != AppThemeColor.values.first)
              const Divider(
                height: 1,
                indent: Dimensions.r16,
                endIndent: Dimensions.r16,
              ),
            _ThemeColorOption(
              themeColor: themeColor,
              isSelected: state.appThemeColor == themeColor,
              onTap: () =>
                  context.read<SettingsCubit>().updateAppThemeColor(themeColor),
            ),
          ],
        ],
      ),
    );
  }
}

class _ThemeColorOption extends StatelessWidget {
  final AppThemeColor themeColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeColorOption({
    required this.themeColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.r16,
          vertical: Dimensions.r14,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? themeColor.primary.withValues(alpha: 0.09)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: Dimensions.r28,
              height: Dimensions.r28,
              decoration: BoxDecoration(
                color: themeColor.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? context.colorScheme.onSurface
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 17)
                  : null,
            ),
            SizedBox(width: Dimensions.r12.dynamicW),
            Expanded(
              child: Text(
                themeColor.label,
                style: context.bodyLarge?.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? context.primaryColor
                      : context.textPrimary,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: context.primaryColor,
                size: Dimensions.r20.dynamicH,
              ),
          ],
        ),
      ),
    );
  }
}
