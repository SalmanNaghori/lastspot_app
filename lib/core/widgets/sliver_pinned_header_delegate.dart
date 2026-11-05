import '../base_import.dart';

/// Lightweight persistent header delegate for pinning subheaders, segmented controls,
/// or filter bars smoothly in a [CustomScrollView].
class SliverPinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget child;
  final Color? backgroundColor;

  const SliverPinnedHeaderDelegate({
    required this.height,
    required this.child,
    this.backgroundColor,
  });

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: height,
      color: backgroundColor ?? context.backgroundColor,
      alignment: Alignment.center,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPinnedHeaderDelegate oldDelegate) {
    return oldDelegate.height != height ||
        oldDelegate.child != child ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}

