import 'package:lastspot_app/core/base_import.dart';
import '../bloc/spot_details_bloc.dart';
import '../widgets/spot_details_booking_panel.dart';
import '../widgets/spot_details_content.dart';
import '../widgets/spot_details_menu_sheet.dart';

class SpotDetailsScreenMobile extends StatelessWidget {
  final SpotDetailsState state;
  final String? heroTag;
  final VoidCallback onBack;
  final VoidCallback onRetry;

  const SpotDetailsScreenMobile({
    super.key,
    required this.state,
    this.heroTag,
    required this.onBack,
    required this.onRetry,
  });

  Future<void> _showMenu(BuildContext context, SpotDetailsLoaded loaded) async {
    final action = await AppBottomSheet.show<SpotDetailsMenuAction>(
      context: context,
      builder: (_) => SpotDetailsMenuSheet(loadedState: loaded),
    );
    if (!context.mounted || action == null) return;
    switch (action) {
      case SpotDetailsMenuAction.edit:
        await context.push(AppRoutes.editSpot, extra: loaded.post);
        if (context.mounted) onRetry();
      case SpotDetailsMenuAction.report:
        await context.push(AppRoutes.reportActivityPath(loaded.post.id));
      case SpotDetailsMenuAction.copy:
        final post = loaded.post;
        final loc = context.loc;
        final price = post.pricePerPerson > 0
            ? '${AppUtils.formatCurrency(post.pricePerPerson)} ${loc.perPerson}'
            : loc.free;
        try {
          await Clipboard.setData(
            ClipboardData(
              text: [
                post.title,
                AppUtils.formatDateTime(post.eventDateTime.toLocal()),
                post.locationName,
                price,
              ].join('\n'),
            ),
          );
          if (context.mounted) {
            AppUtils.showSnackBar(context, loc.detailsCopied);
          }
        } on PlatformException {
          if (context.mounted) AppUtils.showSnackBar(context, loc.detailsCopyFailed, isError: true);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final loaded = state is SpotDetailsLoaded ? state as SpotDetailsLoaded : null;
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= Dimensions.detailsWideBreakpoint;
        return Scaffold(
          backgroundColor: context.backgroundColor,
          appBar: AppBar(
            leading: IconButton(
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: onBack,
            ),
            title: Text(loc.detailsTitle),
            actions: [
              if (loaded != null)
                IconButton(
                  tooltip: loc.detailsMenu,
                  icon: const Icon(Icons.more_horiz_rounded),
                  onPressed: () => _showMenu(context, loaded),
                ),
              const SizedBox(width: AppSpacing.sm),
            ],
          ),
          body: SafeArea(
            top: false,
            child: loaded == null
                ? state is SpotDetailsError
                      ? SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                          child: ErrorState(message: loc.detailsLoadError, actionLabel: loc.retry, onRetry: onRetry),
                        )
                      : LoadingState.shimmerCard()
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SpotDetailsContent(
                          state: loaded,
                          heroTag: heroTag,
                          onMap: () => AppUtils.launchMap(loaded.post.locationName),
                          onReport: () => context.push(AppRoutes.reportActivityPath(loaded.post.id)),
                        ),
                      ),
                      if (wide)
                        SizedBox(
                          width: Dimensions.detailsSidebarWidth,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(0, AppSpacing.md, AppSpacing.md, AppSpacing.lg),
                            child: SpotDetailsBookingPanel(state: loaded),
                          ),
                        ),
                    ],
                  ),
          ),
          bottomNavigationBar: loaded != null && !wide
              ? SafeArea(
                  top: false,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: constraints.maxHeight * 0.45),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.sm),
                      child: SpotDetailsBookingPanel(state: loaded, compact: true),
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }
}
