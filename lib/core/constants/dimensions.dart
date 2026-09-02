import 'package:flutter/material.dart';

class Dimensions {
  Dimensions._();

  static late double screenWidth;
  static late double screenHeight;

  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
  }

  // Base constants (can be used directly or multiplied for dynamic sizing)
  static const double r2 = 2.0;
  static const double r4 = 4.0;
  static const double r8 = 8.0;
  static const double r12 = 12.0;
  static const double r16 = 16.0;
  static const double r20 = 20.0;
  static const double r24 = 24.0;
  static const double r32 = 32.0;
  static const double r48 = 48.0;
  static const double r50 = 50.0;
  static const double r64 = 64.0;
}

// Extension to allow dynamic sizing based on screen width/height as per cursorrules
extension DynamicDimensions on double {
  // Assuming a base design width of 375 (iPhone X/11 Pro)
  double get dynamicW => (this / 375.0) * Dimensions.screenWidth;
  
  // Assuming a base design height of 812
  double get dynamicH => (this / 812.0) * Dimensions.screenHeight;
  
  // Use width ratio for font sizes to keep scaling consistent
  double get dynamicSP => (this / 375.0) * Dimensions.screenWidth;
  
  // For radii, using width ratio is standard
  double get dynamicR => (this / 375.0) * Dimensions.screenWidth;
}
