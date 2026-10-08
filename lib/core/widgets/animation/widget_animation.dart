import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../theme/app_motion.dart';

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
    this.duration = AppMotion.entrance,
    this.verticalOffset = AppMotion.entranceOffset,
    this.horizontalOffset = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
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
