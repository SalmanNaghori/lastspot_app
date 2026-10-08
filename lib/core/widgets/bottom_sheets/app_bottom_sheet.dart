import '../../base_import.dart';
import '../../theme/app_motion.dart';

class AppBottomSheet {
  AppBottomSheet._();

  static bool _isSheetOpen = false;

  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool isScrollControlled = true,
  }) async {
    if (_isSheetOpen) return null;
    _isSheetOpen = true;

    try {
      return await showModalBottomSheet<T>(
        context: context,
        isScrollControlled: isScrollControlled,
        useSafeArea: true,
        showDragHandle: true,
        sheetAnimationStyle: AnimationStyle(
          duration: AppMotion.duration(context, AppMotion.standard),
          reverseDuration: AppMotion.duration(context, AppMotion.quick),
        ),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: SafeArea(top: false, child: builder(context)),
          );
        },
      );
    } finally {
      _isSheetOpen = false;
    }
  }
}
