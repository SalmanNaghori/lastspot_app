import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lastspot_app/core/utils/fcm_token_util.dart';
import '../../../../core/services/installation_id_service.dart';

abstract class DeviceRemoteDataSource {
  Future<void> registerDevice(String userId);
  Future<void> unregisterDevice(String userId);
  Future<void> updateFcmToken(String userId, String token);
}

class SupabaseDeviceDataSourceImpl implements DeviceRemoteDataSource {
  final SupabaseClient _client;
  final InstallationIdService _installationIdService;
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  SupabaseDeviceDataSourceImpl({
    required SupabaseClient client,
    required InstallationIdService installationIdService,
  }) : _client = client,
       _installationIdService = installationIdService;

  @override
  Future<void> registerDevice(String userId) async {
    final packageInfo = await PackageInfo.fromPlatform();

    String osVersion = '';
    String deviceName = '';
    final String platform = Platform.isIOS
        ? 'ios'
        : (Platform.isAndroid ? 'android' : 'web');

    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfoPlugin.androidInfo;
      osVersion =
          'Android ${androidInfo.version.release} (API ${androidInfo.version.sdkInt})';
      deviceName = androidInfo.model;
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfoPlugin.iosInfo;
      osVersion = '${iosInfo.systemName} ${iosInfo.systemVersion}';
      deviceName = iosInfo.name;
    }

    final installationId = await _installationIdService.getId();

    String? fcmTokenStr;
    try {
      fcmTokenStr = await FcmTokenUtil.getToken();
    } catch (_) {
      // Push token availability is optional for device registration.
    }

    final tokenToRegister = (fcmTokenStr != null && fcmTokenStr.isNotEmpty)
        ? fcmTokenStr
        : null;

    await _client.rpc(
      'register_my_device',
      params: {
        'p_device_identifier': installationId,
        'p_platform': platform,
        'p_fcm_token': tokenToRegister,
        'p_device_model': deviceName,
        'p_os_version': osVersion,
        'p_app_version': packageInfo.version,
        'p_build_number': int.tryParse(packageInfo.buildNumber) ?? 0,
      },
    );
  }

  @override
  Future<void> unregisterDevice(String userId) async {
    try {
      final installationId = await _installationIdService.getId();
      await _client.rpc(
        'unregister_my_device',
        params: {'p_device_identifier': installationId},
      );
      await FcmTokenUtil.deleteToken();
    } catch (_) {
      // Ignore if it fails during logout
    }
  }

  @override
  Future<void> updateFcmToken(String userId, String token) async {
    if (token.isEmpty) return;

    try {
      final installationId = await _installationIdService.getId();
      await _client
          .from('user_devices')
          .update({
            'fcm_token': token,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .match({'user_id': userId, 'device_identifier': installationId});
    } catch (e) {
      // Best-effort token update
    }
  }
}
