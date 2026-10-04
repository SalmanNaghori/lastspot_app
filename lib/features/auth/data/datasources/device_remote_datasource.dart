import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lastspot_app/core/utils/fcm_token_util.dart';

abstract class DeviceRemoteDataSource {
  Future<void> registerDevice(String userId);
  Future<void> unregisterDevice(String userId);
  Future<void> updateFcmToken(String userId, String token);
}

class SupabaseDeviceDataSourceImpl implements DeviceRemoteDataSource {
  final SupabaseClient _client;
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  SupabaseDeviceDataSourceImpl({required SupabaseClient client})
    : _client = client;

  @override
  Future<void> registerDevice(String userId) async {
    final packageInfo = await PackageInfo.fromPlatform();

    String deviceId = '';
    String osVersion = '';
    String deviceName = '';
    final String platform = Platform.isIOS
        ? 'ios'
        : (Platform.isAndroid ? 'android' : 'web');

    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfoPlugin.androidInfo;
      deviceId = androidInfo.id;
      osVersion =
          'Android ${androidInfo.version.release} (API ${androidInfo.version.sdkInt})';
      deviceName = androidInfo.model;
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfoPlugin.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? 'unknown_ios_id';
      osVersion = '${iosInfo.systemName} ${iosInfo.systemVersion}';
      deviceName = iosInfo.name;
    }

    // Guard: do not proceed if we could not determine a device ID.
    if (deviceId.isEmpty) return;

    String fcmTokenStr = '';
    try {
      final fcmToken = await FcmTokenUtil.getToken();
      fcmTokenStr = fcmToken ?? '';
    } catch (e) {
      // Ignore if push notifications are not set up or fail
    }

    final deviceData = {
      'user_id': userId,
      'device_identifier': deviceId,
      'device_model': deviceName,
      'platform': platform,
      'os_version': osVersion,
      'app_version': packageInfo.version,
      'build_number': packageInfo.buildNumber,
      'fcm_token': fcmTokenStr,
      'last_active_at': DateTime.now().toIso8601String(),
    };

    await _client
        .from('user_devices')
        .upsert(deviceData, onConflict: 'user_id, device_identifier');
  }

  @override
  Future<void> unregisterDevice(String userId) async {
    String deviceId = '';
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfoPlugin.androidInfo;
      deviceId = androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfoPlugin.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? 'unknown_ios_id';
    }

    if (deviceId.isEmpty) return;

    try {
      await _client.from('user_devices').update({'fcm_token': null}).match({
        'user_id': userId,
        'device_identifier': deviceId,
      });

      await FcmTokenUtil.deleteToken();
    } catch (e) {
      // Ignore if it fails during logout
    }
  }

  @override
  Future<void> updateFcmToken(String userId, String token) async {
    String deviceId = '';
    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfoPlugin.androidInfo;
      deviceId = androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfoPlugin.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? 'unknown_ios_id';
    }

    if (deviceId.isEmpty) return;

    try {
      await _client.from('user_devices').update({
        'fcm_token': token,
        'updated_at': DateTime.now().toIso8601String(),
      }).match({
        'user_id': userId,
        'device_identifier': deviceId,
      });
    } catch (e) {
      // Ignore
    }
  }
}
