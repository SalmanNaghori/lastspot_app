import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lastspot_app/core/network/supabase_logger.dart';

abstract class DeviceRemoteDataSource {
  Future<void> registerDevice(String userId);
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
    final String platform = Platform.isIOS
        ? 'ios'
        : (Platform.isAndroid ? 'android' : 'web');

    if (Platform.isAndroid) {
      final androidInfo = await _deviceInfoPlugin.androidInfo;
      deviceId = androidInfo.id;
      osVersion =
          'Android ${androidInfo.version.release} (API ${androidInfo.version.sdkInt})';
    } else if (Platform.isIOS) {
      final iosInfo = await _deviceInfoPlugin.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? 'unknown_ios_id';
      osVersion = '${iosInfo.systemName} ${iosInfo.systemVersion}';
    }

    // Guard: do not proceed if we could not determine a device ID.
    if (deviceId.isEmpty) return;

    // Perform direct upsert to match live DB schema which has `device_identifier`.
    // The previous RPC `record_user_device` does not exist in the live DB.
    final params = {
      'user_id': userId,
      'device_identifier': deviceId,
      'platform': platform,
      'os_version': osVersion,
      'app_version': packageInfo.version,
      'build_number': packageInfo.buildNumber,
    };

    return SupabaseLogger.execute(
      operationName: 'Device.registerDevice',
      requestData: params,
      operation: () => _client
          .from('user_devices')
          .upsert(params, onConflict: 'user_id, device_identifier'),
    );
  }
}
