import 'package:flutter/material.dart';

import '../../constants/dimensions.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_motion.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../buttons/app_button.dart';

/// Theme-aware overlays with consistent motion and accessible dismissal.
class AppDialog {
  AppDialog._();

  static Future<T?> showOverlay<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool fullscreen = false,
  }) {
    final themes = InheritedTheme.capture(
      from: context,
      to: Navigator.of(context, rootNavigator: true).context,
    );
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: !fullscreen,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Theme.of(context).colorScheme.scrim.withValues(alpha: 0.6),
      transitionDuration: AppMotion.duration(context, AppMotion.standard),
      pageBuilder: (context, animation, secondaryAnimation) =>
          themes.wrap(Builder(builder: builder)),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final eased = animation.drive(CurveTween(curve: AppMotion.curve));
        return FadeTransition(
          opacity: eased,
          child: SlideTransition(
            position: eased.drive(
              Tween(begin: AppMotion.dialogSlideOffset, end: Offset.zero),
            ),
            child: ScaleTransition(
              scale: eased.drive(
                Tween(begin: AppMotion.dialogStartScale, end: 1.0),
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }

  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmLabel,
    String? cancelLabel,
    bool isDestructive = false,
  }) {
    final loc = AppLocalizations.of(context)!;
    return showOverlay<bool>(
      context: context,
      builder: (context) {
        final colors = Theme.of(context).colorScheme;
        final type = Theme.of(context).textTheme;
        final accent = isDestructive ? colors.error : colors.primary;
        return SafeArea(
          child: Dialog(
            constraints: const BoxConstraints(
              maxWidth: Dimensions.dialogMaxWidth,
            ),
            clipBehavior: Clip.antiAlias,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    color: isDestructive
                        ? colors.errorContainer
                        : colors.primaryContainer,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: AppRadius.xlBorderRadius,
                          ),
                          child: Icon(
                            isDestructive
                                ? Icons.warning_amber_rounded
                                : Icons.check_circle_outline_rounded,
                            color: accent,
                            size: AppSpacing.xl,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          tooltip: MaterialLocalizations.of(
                            context,
                          ).closeButtonTooltip,
                          style: IconButton.styleFrom(
                            foregroundColor: isDestructive
                                ? colors.onErrorContainer
                                : colors.onPrimaryContainer,
                          ),
                          onPressed: () => Navigator.of(context).pop(false),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Semantics(
                          namesRoute: true,
                          header: true,
                          child: Text(
                            title,
                            style: type.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.smLg),
                        Text(
                          message,
                          style: type.bodyLarge?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        AppButton(
                          label: confirmLabel ?? loc.confirmAction,
                          type: isDestructive
                              ? AppButtonType.danger
                              : AppButtonType.primary,
                          onPressed: () => Navigator.of(context).pop(true),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        AppButton.text(
                          label: cancelLabel ?? loc.cancel,
                          isFullWidth: true,
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
