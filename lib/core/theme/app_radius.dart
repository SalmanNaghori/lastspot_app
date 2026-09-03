import 'package:flutter/material.dart';

class AppRadius {
  AppRadius._();

  /// 8.0 - Small UI elements (tags, badges)
  static const double sm = 8.0;

  /// 12.0 - Standard elements (buttons, inputs)
  static const double md = 12.0;

  /// 16.0 - Cards and primary content blocks
  static const double lg = 16.0;

  /// 20.0 - Large containers
  static const double xl = 20.0;

  /// 24.0 - Major sheets, dialogs, bottom sheets
  static const double xxl = 24.0;

  /// 999.0 - Fully rounded (pill shape)
  static const double pill = 999.0;

  // Pre-defined BorderRadius objects for convenience
  static final BorderRadius smBorderRadius = BorderRadius.circular(sm);
  static final BorderRadius mdBorderRadius = BorderRadius.circular(md);
  static final BorderRadius lgBorderRadius = BorderRadius.circular(lg);
  static final BorderRadius xlBorderRadius = BorderRadius.circular(xl);
  static final BorderRadius xxlBorderRadius = BorderRadius.circular(xxl);
  static final BorderRadius pillBorderRadius = BorderRadius.circular(pill);
}
