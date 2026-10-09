/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

import 'package:lottie/lottie.dart';
import 'package:flutter/widgets.dart' show BoxFit;

class Assets {
  const Assets._();

  static const $AssetsAinGen ain = $AssetsAinGen();
}

class $AssetsAinGen {
  const $AssetsAinGen();

  LottieGenImage get anCongratulationScreen =>
      const LottieGenImage('assets/ain/an_congratulation_screen.json');

  LottieGenImage get anNoData =>
      const LottieGenImage('assets/ain/an_no_data.json');

  LottieGenImage get anSplashScreen =>
      const LottieGenImage('assets/ain/an_splash_screen.json');
}

class LottieGenImage {
  const LottieGenImage(this.path);

  final String path;

  LottieBuilder lottie({
    bool? animate,
    bool? repeat,
    bool? reverse,
    double? width,
    double? height,
    BoxFit? fit,
  }) => Lottie.asset(
    path,
    animate: animate,
    repeat: repeat,
    reverse: reverse,
    width: width,
    height: height,
    fit: fit,
  );
}
