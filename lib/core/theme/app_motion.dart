import 'package:flutter/material.dart';

/// Shared motion values, with an immediate path for reduced-motion users.
abstract final class AppMotion {
  static const quick = Duration(milliseconds: 160);
  static const standard = Duration(milliseconds: 280);
  static const entrance = Duration(milliseconds: 400);
  static const tapGuard = Duration(milliseconds: 500);
  static const curve = Curves.easeOutCubic;
  static const pressedScale = 0.98;
  static const dialogStartScale = 0.94;
  static const entranceOffset = 20.0;

  static Duration duration(BuildContext context, Duration value) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : value;
}
