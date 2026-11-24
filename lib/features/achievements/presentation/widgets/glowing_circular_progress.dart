import 'dart:math' as math;
import 'package:lastspot_app/core/base_import.dart';

/// Animated circular progress ring with gradient and soft ambient glow.
class GlowingCircularProgress extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final bool isUnlocked;
  final double size;
  final double strokeWidth;
  final Widget child;

  const GlowingCircularProgress({
    super.key,
    required this.progress,
    required this.isUnlocked,
    required this.size,
    required this.strokeWidth,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: clampedProgress),
      duration: AppMotion.duration(context, AppMotion.standard),
      curve: AppMotion.curve,
      builder: (context, animatedValue, _) {
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: isUnlocked
                ? [
                    BoxShadow(
                      color: context.primaryColor.withValues(alpha: 0.28),
                      blurRadius: Dimensions.r12.dynamicR,
                      spreadRadius: Dimensions.r2.dynamicR,
                    ),
                  ]
                : null,
          ),
          child: CustomPaint(
            painter: _GlowingCircularProgressPainter(
              progress: animatedValue,
              isUnlocked: isUnlocked,
              strokeWidth: strokeWidth,
              trackColor: context.isDarkMode
                  ? context.surfaceContainerHigh
                  : context.surfaceContainerLow,
              primaryGradientStart: context.primaryColor,
              primaryGradientEnd: context.accentColor,
              successColor: context.successColor,
            ),
            child: Center(child: child),
          ),
        );
      },
    );
  }
}

class _GlowingCircularProgressPainter extends CustomPainter {
  final double progress;
  final bool isUnlocked;
  final double strokeWidth;
  final Color trackColor;
  final Color primaryGradientStart;
  final Color primaryGradientEnd;
  final Color successColor;

  const _GlowingCircularProgressPainter({
    required this.progress,
    required this.isUnlocked,
    required this.strokeWidth,
    required this.trackColor,
    required this.primaryGradientStart,
    required this.primaryGradientEnd,
    required this.successColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // 1. Background Track
    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    if (progress <= 0.0) return;

    // 2. Animated Progress Arc
    final sweepAngle = 2 * math.pi * progress;
    final startAngle = -math.pi / 2;

    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    if (isUnlocked) {
      progressPaint.color = successColor;
    } else {
      final rect = Rect.fromCircle(center: center, radius: radius);
      progressPaint.shader = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + sweepAngle,
        colors: [primaryGradientStart, primaryGradientEnd],
      ).createShader(rect);
    }

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GlowingCircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isUnlocked != isUnlocked ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.trackColor != trackColor;
  }
}
