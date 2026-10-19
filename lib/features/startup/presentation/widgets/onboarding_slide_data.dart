import 'package:flutter/widgets.dart';
import '../../../../gen/assets.gen.dart';

/// Data model representing a single slide in the KhelBhai onboarding flow.
class OnboardingSlideData {
  final String title;
  final String? tagline;
  final String description;
  final AssetGenImage image;
  final IconData fallbackIcon;
  final String? readyHeading;

  const OnboardingSlideData({
    required this.title,
    this.tagline,
    required this.description,
    required this.image,
    required this.fallbackIcon,
    this.readyHeading,
  });
}
