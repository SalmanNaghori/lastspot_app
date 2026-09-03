import '../../base_import.dart';

enum AppButtonType { primary, secondary, outline, text, danger }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
  });

  const AppButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
  }) : type = AppButtonType.primary;

  const AppButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
  }) : type = AppButtonType.secondary;

  const AppButton.outline({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
  }) : type = AppButtonType.outline;

  const AppButton.text({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
  }) : type = AppButtonType.text;

  const AppButton.danger({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.icon,
  }) : type = AppButtonType.danger;

  @override
  Widget build(BuildContext context) {
    final semantics = context.semantics;

    final isFilledPrimary = type == AppButtonType.primary || type == AppButtonType.danger;
    final spinnerColor = isFilledPrimary ? Colors.white : AppColor.primaryColor;

    final Widget child = AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      child: isLoading
          ? SizedBox(
              key: const ValueKey('btn_loading'),
              height: Dimensions.r20.dynamicH,
              width: Dimensions.r20.dynamicW,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: spinnerColor,
              ),
            )
          : Row(
              key: const ValueKey('btn_content'),
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: Dimensions.r20.dynamicH),
                  SizedBox(width: Dimensions.r8.dynamicW),
                ],
                Text(label),
              ],
            ),
    );

    Widget button;

    switch (type) {
      case AppButtonType.primary:
        button = FilledButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        );
        break;
      case AppButtonType.secondary:
        button = FilledButton.tonal(
          onPressed: isLoading ? null : onPressed,
          child: child,
        );
        break;
      case AppButtonType.outline:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        );
        break;
      case AppButtonType.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          child: child,
        );
        break;
      case AppButtonType.danger:
        button = FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor:
                semantics.warning, // Or use error color if preferred
            foregroundColor: Colors.white,
          ),
          onPressed: isLoading ? null : onPressed,
          child: child,
        );
        break;
    }

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}
