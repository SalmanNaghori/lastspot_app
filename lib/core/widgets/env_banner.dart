import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../config/app_env.dart';
import '../constants/app_string.dart';
import '../theme/app_color.dart';

/// Displays a dismissible environment label in the top-right corner of the screen.
///
/// Shown when:
///   - [kDebugMode] is true (flutter run), OR
///   - [kProfileMode] is true (flutter run --profile), OR
///   - The compile-time flag `--dart-define=SHOW_BANNER=true` is set, OR
///   - The active environment is not [EnvironmentType.prod]
///
/// Tap the label to temporarily hide it; tap the small arrow to bring it back.
class EnvBanner extends StatefulWidget {
  final Widget child;

  const EnvBanner({super.key, required this.child});

  @override
  State<EnvBanner> createState() => _EnvBannerState();
}

class _EnvBannerState extends State<EnvBanner> {
  final ValueNotifier<bool> _visibleNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<String> _versionNotifier = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  @override
  void dispose() {
    _visibleNotifier.dispose();
    _versionNotifier.dispose();
    super.dispose();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final version = info.version;
      final buildNumber = info.buildNumber;
      if (version.isNotEmpty) {
        _versionNotifier.value = buildNumber.isNotEmpty
            ? 'v$version+$buildNumber'
            : 'v$version';
        return;
      }
    } catch (_) {
      // Platform channels may be unavailable during testing or bootstrap
    }
    _versionNotifier.value = 'v${AppEnv.appVersion}';
  }

  // Reads the compile-time flag --dart-define=SHOW_BANNER=true.
  // In debug mode this is always true; release QA builds pass it explicitly.
  static const bool _showBannerFlag = bool.fromEnvironment(
    'SHOW_BANNER',
    defaultValue: false,
  );

  // Returns null when the banner should not render.
  // Shown when: kDebugMode=true OR kProfileMode=true OR --dart-define=SHOW_BANNER=true OR not prod
  String? _getLabel(String version) {
    if (!kDebugMode && !kProfileMode && !_showBannerFlag && AppEnv.isProd) {
      return null;
    }

    final suffix = version.isNotEmpty ? ' · $version' : '';

    String buildType = '';
    if (kDebugMode) {
      buildType = ' · ${AppString.envBannerDebug}';
    } else if (kProfileMode) {
      buildType = ' · ${AppString.envBannerProfile}';
    }

    switch (AppEnvironment.current.type) {
      case EnvironmentType.local:
        return '${AppString.envBannerLocal}$buildType$suffix';
      case EnvironmentType.dev:
        return '${AppString.envBannerDev}$buildType$suffix';
      case EnvironmentType.staging:
        return '${AppString.envBannerStaging}$buildType$suffix';
      case EnvironmentType.prod:
        return '${AppString.envBannerProd}$buildType$suffix';
    }
  }

  Color get _color {
    switch (AppEnvironment.current.type) {
      case EnvironmentType.local:
        return AppColor.envBannerLocal;
      case EnvironmentType.dev:
        return AppColor.envBannerDev;
      case EnvironmentType.staging:
        return AppColor.envBannerStaging;
      case EnvironmentType.prod:
        return AppColor.envBannerProd;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: _versionNotifier,
      builder: (context, version, _) {
        final label = _getLabel(version);
        if (label == null) return widget.child;

        return Stack(
          children: [
            widget.child,
            Positioned(
              top: MediaQuery.of(context).padding.top + 6,
              right: 0,
              child: ValueListenableBuilder<bool>(
                valueListenable: _visibleNotifier,
                builder: (context, visible, _) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    },
                    layoutBuilder: (currentChild, previousChildren) {
                      return Stack(
                        alignment: Alignment.centerRight,
                        children: <Widget>[...previousChildren, ?currentChild],
                      );
                    },
                    child: visible ? _pill(label) : _collapseTab(),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _pill(String label) {
    return GestureDetector(
      key: const ValueKey('pill'),
      onTap: () => _visibleNotifier.value = false,
      child: Container(
        margin: const EdgeInsets.only(right: 0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: _color,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            bottomLeft: Radius.circular(8),
          ),
          boxShadow: [
            BoxShadow(
              color: _color.withValues(alpha: 0.45),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColor.whiteColor,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.close, color: AppColor.whiteColor, size: 12),
          ],
        ),
      ),
    );
  }

  Widget _collapseTab() {
    return GestureDetector(
      key: const ValueKey('tab'),
      onTap: () => _visibleNotifier.value = true,
      child: Container(
        width: 16,
        height: 40,
        decoration: BoxDecoration(
          color: _color,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            bottomLeft: Radius.circular(8),
          ),
        ),
        alignment: Alignment.centerLeft,
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: AppColor.whiteColor,
          size: 10,
        ),
      ),
    );
  }
}
