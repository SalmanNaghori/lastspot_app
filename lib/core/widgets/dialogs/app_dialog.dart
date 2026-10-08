import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/app_motion.dart';
import '../../theme/app_spacing.dart';
import '../buttons/app_button.dart';

/// Accessible confirmation overlay shared by account and activity actions.
class AppDialog {
  AppDialog._();

  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmLabel,
    String? cancelLabel,
    bool isDestructive = false,
  }) {
    final loc = AppLocalizations.of(context)!;
    final themes = InheritedTheme.capture(
      from: context,
      to: Navigator.of(context, rootNavigator: true).context,
    );
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Theme.of(context).colorScheme.scrim.withValues(alpha: 0.5),
      transitionDuration: AppMotion.duration(context, AppMotion.standard),
      pageBuilder: (dialogContext, animation, secondaryAnimation) =>
          themes.wrap(
            SafeArea(
              child: Builder(
                builder: (context) {
                  final colors = Theme.of(context).colorScheme;
                  return AlertDialog(
                    scrollable: true,
                    icon: Center(
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: isDestructive
                              ? colors.errorContainer
                              : colors.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isDestructive
                              ? Icons.warning_amber_rounded
                              : Icons.check_circle_outline_rounded,
                          color: isDestructive
                              ? colors.onErrorContainer
                              : colors.onPrimaryContainer,
                          size: AppSpacing.xl,
                        ),
                      ),
                    ),
                    title: Text(title, textAlign: TextAlign.center),
                    content: Text(message, textAlign: TextAlign.center),
                    actionsPadding: const EdgeInsets.all(AppSpacing.lg),
                    actions: [
                      AppButton(
                        label: confirmLabel ?? loc.confirmAction,
                        type: isDestructive
                            ? AppButtonType.danger
                            : AppButtonType.primary,
                        onPressed: () => Navigator.of(dialogContext).pop(true),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppButton.text(
                        label: cancelLabel ?? loc.cancel,
                        isFullWidth: true,
                        onPressed: () => Navigator.of(dialogContext).pop(false),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final eased = animation.drive(CurveTween(curve: AppMotion.curve));
        return FadeTransition(
          opacity: eased,
          child: ScaleTransition(
            scale: eased.drive(
              Tween(begin: AppMotion.dialogStartScale, end: 1.0),
            ),
            child: child,
          ),
        );
      },
    );
  }
}
