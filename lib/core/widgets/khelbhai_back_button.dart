import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/dimensions.dart';
import '../theme/app_color.dart';
import '../theme/app_motion.dart';
import '../theme/app_radius.dart';
import '../utils/context_extensions.dart';

/// Raised, glossy brand navigation with a fixed 48 dp accessible touch target.
///
/// The default action dismisses focus and requests a route-aware pop, preserving
/// PopScope/form guards. Supply [onPressed] only for an in-page back step or an
/// existing route-aware confirmation handler. No action ever exits the app.
class KhelBhaiBackButton extends StatefulWidget {
  const KhelBhaiBackButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  /// Use for app bars that should show a back action only above a root route.
  static Widget? leading(BuildContext context) =>
      ModalRoute.of(context)?.impliesAppBarDismissal == true
      ? const KhelBhaiBackButton()
      : null;

  @override
  State<KhelBhaiBackButton> createState() => _KhelBhaiBackButtonState();
}

class _KhelBhaiBackButtonState extends State<KhelBhaiBackButton> {
  bool _pressed = false;

  void _activate() {
    FocusManager.instance.primaryFocus?.unfocus();
    final action = widget.onPressed;
    if (action != null) {
      action();
    } else {
      unawaited(context.requestBack());
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final label = MaterialLocalizations.of(context).backButtonTooltip;
    final radius = AppRadius.mdBorderRadius;
    return Center(
      widthFactor: 1,
      heightFactor: 1,
      child: Tooltip(
        message: label,
        excludeFromSemantics: true,
        child: Semantics(
          container: true,
          label: label,
          button: true,
          onTap: _activate,
          child: Material(
            color: AppColor.transparentColor,
            child: InkWell(
              onTap: _activate,
              onHighlightChanged: (value) => setState(() => _pressed = value),
              borderRadius: radius,
              excludeFromSemantics: true,
              child: SizedBox.square(
                dimension: Dimensions.r48,
                child: Center(
                  child: AnimatedScale(
                    scale: _pressed ? AppMotion.dialogStartScale : 1,
                    duration: AppMotion.duration(context, AppMotion.quick),
                    curve: AppMotion.curve,
                    child: AnimatedContainer(
                      duration: AppMotion.duration(context, AppMotion.quick),
                      width: Dimensions.backButtonSurfaceSize,
                      height: Dimensions.backButtonSurfaceSize,
                      decoration: BoxDecoration(
                        borderRadius: radius,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: dark
                              ? [
                                  AppColor.surfaceContainerHighDark,
                                  AppColor.surfaceDark,
                                ]
                              : [
                                  AppColor.surfaceLight,
                                  AppColor.surfaceContainerHighLight,
                                ],
                        ),
                        border: Border.all(
                          color: dark
                              ? AppColor.cardBorderDark
                              : AppColor.surfaceLight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColor.blackColor.withValues(
                              alpha: dark ? 0.3 : 0.12,
                            ),
                            blurRadius: _pressed
                                ? Dimensions.r2
                                : Dimensions.r6,
                            offset: Offset(
                              0,
                              _pressed
                                  ? Dimensions.backButtonEdgeDepth
                                  : Dimensions.r4,
                            ),
                          ),
                          BoxShadow(
                            color: AppColor.whiteColor.withValues(
                              alpha: dark ? 0.04 : 0.8,
                            ),
                            blurRadius: Dimensions.r2,
                            offset: const Offset(
                              -Dimensions.backButtonEdgeDepth,
                              -Dimensions.backButtonEdgeDepth,
                            ),
                          ),
                        ],
                      ),
                      child: Center(
                        child: CustomPaint(
                          size: const Size.square(Dimensions.r28),
                          painter: const KhelBhaiBackArrowPainter(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Small vector arrow with an extruded edge and an amber specular highlight.
class KhelBhaiBackArrowPainter extends CustomPainter {
  const KhelBhaiBackArrowPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / Dimensions.r28, size.height / Dimensions.r28);
    final arrow = Path()
      ..moveTo(14, 3)
      ..quadraticBezierTo(13, 2, 12, 3)
      ..lineTo(2, 12)
      ..quadraticBezierTo(0, 14, 2, 16)
      ..lineTo(12, 25)
      ..quadraticBezierTo(15, 27, 17, 24)
      ..quadraticBezierTo(18, 22, 16, 20)
      ..lineTo(12, 17)
      ..lineTo(24, 17)
      ..quadraticBezierTo(27, 17, 27, 14)
      ..quadraticBezierTo(27, 11, 24, 11)
      ..lineTo(12, 11)
      ..lineTo(16, 8)
      ..quadraticBezierTo(18, 5, 14, 3)
      ..close();
    canvas.drawPath(
      arrow.shift(const Offset(0, 2)),
      Paint()..color = AppColor.primaryDarkColor,
    );
    canvas.drawPath(
      arrow,
      Paint()
        ..shader =
            const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColor.accentHighlight,
                AppColor.primaryColor,
                AppColor.primaryDarkColor,
              ],
              stops: [0, 0.45, 1],
            ).createShader(
              const Rect.fromLTWH(0, 0, Dimensions.r28, Dimensions.r28),
            ),
    );
    canvas.drawPath(
      Path()
        ..moveTo(13, 5)
        ..lineTo(4, 13)
        ..quadraticBezierTo(3, 14, 4, 15),
      Paint()
        ..color = AppColor.accentLight.withValues(alpha: 0.85)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 1.2,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(KhelBhaiBackArrowPainter oldDelegate) => false;
}
