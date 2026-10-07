import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AnimationWrapper extends StatelessWidget {
  final Widget child;
  final int index;
  final Duration duration;
  final double verticalOffset;
  final double horizontalOffset;

  const AnimationWrapper({
    super.key,
    required this.child,
    this.index = 0,
    this.duration = const Duration(milliseconds: 500),
    this.verticalOffset = 50.0,
    this.horizontalOffset = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: duration,
      child: SlideAnimation(
        verticalOffset: verticalOffset,
        horizontalOffset: horizontalOffset,
        child: FadeInAnimation(child: child),
      ),
    );
  }
}
