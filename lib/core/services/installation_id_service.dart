import 'dart:math';

import '../utils/shared_prefs_util.dart';

/// Provides a stable, random identifier for this app installation.
///
/// The value is deliberately unrelated to hardware identifiers so it remains
/// stable across app sessions without identifying the physical device.
class InstallationIdService {
  final SharedPrefsUtil _prefs;
  Future<String>? _pendingId;

  InstallationIdService(this._prefs);

  Future<String> getId() {
    return _pendingId ??= _loadOrCreate().catchError((Object error) {
      _pendingId = null;
      throw error;
    });
  }

  Future<String> _loadOrCreate() async {
    await _prefs.reload();
    final existing = _prefs.getString(SharedPrefsKeys.installationId);
    if (existing != null && existing.isNotEmpty) return existing;

    final id = _createUuidV4();
    final saved = await _prefs.setString(SharedPrefsKeys.installationId, id);
    if (!saved) {
      throw StateError('Could not persist the installation identifier.');
    }
    return id;
  }

  String _createUuidV4() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0'));
    final value = hex.join();
    return '${value.substring(0, 8)}-${value.substring(8, 12)}-'
        '${value.substring(12, 16)}-${value.substring(16, 20)}-'
        '${value.substring(20)}';
  }
}
