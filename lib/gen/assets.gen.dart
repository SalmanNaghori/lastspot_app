// dart format width=80

/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: deprecated_member_use,directives_ordering,implicit_dynamic_list_literal,unnecessary_import

import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart' as _lottie;

class $AssetsAinGen {
  const $AssetsAinGen();

  /// File path: assets/ain/an_congratulation_screen.json
  LottieGenImage get anCongratulationScreen =>
      const LottieGenImage('assets/ain/an_congratulation_screen.json');

  /// File path: assets/ain/an_no_data.json
  LottieGenImage get anNoData =>
      const LottieGenImage('assets/ain/an_no_data.json');

  /// File path: assets/ain/an_splash_screen.json
  LottieGenImage get anSplashScreen =>
      const LottieGenImage('assets/ain/an_splash_screen.json');

  /// List of all assets
  List<LottieGenImage> get values => [
    anCongratulationScreen,
    anNoData,
    anSplashScreen,
  ];
}

class $AssetsAudioGen {
  const $AssetsAudioGen();

  /// File path: assets/audio/activity_created_victory.wav
  String get activityCreatedVictory =>
      'assets/audio/activity_created_victory.wav';

  /// List of all assets
  List<String> get values => [activityCreatedVictory];
}

abstract final class Assets {
  static const $AssetsAinGen ain = $AssetsAinGen();
  static const $AssetsAudioGen audio = $AssetsAudioGen();
}

class LottieGenImage {
  const LottieGenImage(this._assetName, {this.flavors = const {}});

  final String _assetName;
  final Set<String> flavors;

  _lottie.LottieBuilder lottie({
    Animation<double>? controller,
    bool? animate,
    _lottie.FrameRate? frameRate,
    bool? repeat,
    bool? reverse,
    _lottie.LottieDelegates? delegates,
    _lottie.LottieOptions? options,
    void Function(_lottie.LottieComposition)? onLoaded,
    _lottie.LottieImageProviderFactory? imageProviderFactory,
    Key? key,
    AssetBundle? bundle,
    Widget Function(BuildContext, Widget, _lottie.LottieComposition?)?
    frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    double? width,
    double? height,
    BoxFit? fit,
    AlignmentGeometry? alignment,
    String? package,
    bool? addRepaintBoundary,
    FilterQuality? filterQuality,
    void Function(String)? onWarning,
    _lottie.LottieDecoder? decoder,
    _lottie.RenderCache? renderCache,
    bool? backgroundLoading,
  }) {
    return _lottie.Lottie.asset(
      _assetName,
      controller: controller,
      animate: animate,
      frameRate: frameRate,
      repeat: repeat,
      reverse: reverse,
      delegates: delegates,
      options: options,
      onLoaded: onLoaded,
      imageProviderFactory: imageProviderFactory,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      package: package,
      addRepaintBoundary: addRepaintBoundary,
      filterQuality: filterQuality,
      onWarning: onWarning,
      decoder: decoder,
      renderCache: renderCache,
      backgroundLoading: backgroundLoading,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
