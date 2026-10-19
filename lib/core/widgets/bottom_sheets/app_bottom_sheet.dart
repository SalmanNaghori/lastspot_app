import '../../base_import.dart';

class AppBottomSheet {
  AppBottomSheet._();

  static bool _isSheetOpen = false;

  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool isScrollControlled = true,
    bool showDragHandle = true,
  }) async {
    if (_isSheetOpen) return null;
    _isSheetOpen = true;

    try {
      return await showModalBottomSheet<T>(
        context: context,
        isScrollControlled: isScrollControlled,
        useSafeArea: true,
        barrierColor: context.colorScheme.scrim.withValues(alpha: 0.6),
        constraints: const BoxConstraints(
          maxWidth: Dimensions.detailsTabletBreakpoint,
        ),
        showDragHandle: showDragHandle,
        sheetAnimationStyle: AnimationStyle(
          duration: AppMotion.duration(context, AppMotion.standard),
          reverseDuration: AppMotion.duration(context, AppMotion.quick),
        ),
        builder: (context) {
          return AnimatedPadding(
            duration: AppMotion.duration(context, AppMotion.quick),
            curve: AppMotion.curve,
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
