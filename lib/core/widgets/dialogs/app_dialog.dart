import '../../base_import.dart';

class AppDialog {
  AppDialog._();

  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            AppButton.text(
              label: cancelLabel,
              onPressed: () => Navigator.of(context).pop(false),
            ),
            isDestructive
                ? AppButton.danger(
                    label: confirmLabel,
                    isFullWidth: false,
                    onPressed: () => Navigator.of(context).pop(true),
                  )
                : AppButton(
                    label: confirmLabel,
                    isFullWidth: false,
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
          ],
        );
      },
    );
  }
}
