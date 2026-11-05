import '../base_import.dart';

/// Bottom spacer for sliver-based screens inside [AuthenticatedAppShell]
/// or screens with floating bottom navigation bars.
///
/// Ensures the last scrollable item completely clears the floating 3D bottom bar
/// and system navigation insets (e.g. gesture bar, 3-button bar).
class SliverShellBottomSpacer extends StatelessWidget {
  final double extraPadding;

  const SliverShellBottomSpacer({super.key, this.extraPadding = 0});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final totalHeight = Dimensions.r96.dynamicH + bottomInset + extraPadding;
    return SliverToBoxAdapter(child: SizedBox(height: totalHeight));
  }
}

/// Non-sliver bottom spacer for standard scroll views inside [AuthenticatedAppShell].
class ShellBottomSpacer extends StatelessWidget {
  final double extraPadding;

  const ShellBottomSpacer({super.key, this.extraPadding = 0});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final totalHeight = Dimensions.r96.dynamicH + bottomInset + extraPadding;
    return SizedBox(height: totalHeight);
  }
}
