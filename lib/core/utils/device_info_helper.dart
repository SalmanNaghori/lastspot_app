import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DeviceInfoHelper {
  static Future<void> recordDevice(SupabaseClient supabase) async {
    try {
      final deviceInfoPlugin = DeviceInfoPlugin();
      final packageInfo = await PackageInfo.fromPlatform();
      
      String deviceId = '';
      String deviceName = '';
      String osVersion = '';
      String platform = Platform.isIOS ? 'ios' : (Platform.isAndroid ? 'android' : 'web');

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        deviceId = androidInfo.id; // Unique ID on Android
        deviceName = '${androidInfo.manufacturer} ${androidInfo.model}';
        osVersion = 'Android ${androidInfo.version.release} (API ${androidInfo.version.sdkInt})';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? 'unknown_ios_id';
        deviceName = iosInfo.name;
        osVersion = '${iosInfo.systemName} ${iosInfo.systemVersion}';
      }

      await supabase.rpc('record_user_device', params: {
        'p_device_id': deviceId,
        'p_device_name': deviceName,
        'p_platform': platform,
        'p_os_version': osVersion,
        'p_app_version': packageInfo.version,
        'p_build_number': packageInfo.buildNumber,
        'p_fcm_token': null, // Update this later if Firebase Cloud Messaging is added
      });
    } catch (e, st) {
      // Silently fail for device recording to not block auth flow
      log('Failed to record device info', name: 'DeviceInfoHelper', error: e, stackTrace: st);
    }
  }
}
