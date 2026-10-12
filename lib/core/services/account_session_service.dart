import 'package:supabase_flutter/supabase_flutter.dart';

import 'installation_id_service.dart';

enum AccountSessionStatus {
  active,
  inactiveOrUninitialized,
  noSession,
  credentialsExpired,
  unavailable,
}

/// Coordinates the verified session RPCs for the current Supabase session.
///
/// A false validation result cannot distinguish an account with no session
/// history from one whose session was replaced. Callers must fail closed
/// without claiming which of those cases occurred.
class AccountSessionService {
  final SupabaseClient _client;
  final InstallationIdService _installationIdService;

  AccountSessionService({
    required SupabaseClient client,
    required InstallationIdService installationIdService,
  }) : _client = client,
       _installationIdService = installationIdService;

  Future<AccountSessionStatus> activateFreshSession() async {
    if (_client.auth.currentSession == null) {
      return AccountSessionStatus.noSession;
    }

    try {
      final installationId = await _installationIdService.getId();
      final result = await _client.rpc(
        'activate_my_session',
        params: {'p_device_identifier': installationId},
      );
      return result == true
          ? AccountSessionStatus.active
          : AccountSessionStatus.inactiveOrUninitialized;
    } catch (error) {
      return _classifyError(error);
    }
  }

  Future<AccountSessionStatus> validateCurrentSession() async {
    if (_client.auth.currentSession == null) {
      return AccountSessionStatus.noSession;
    }

    try {
      final installationId = await _installationIdService.getId();
      final sessionActive = await _client.rpc('is_my_session_active');
      final deviceActive = await _client.rpc(
        'is_my_active_device',
        params: {'p_device_identifier': installationId},
      );
      return sessionActive == true && deviceActive == true
          ? AccountSessionStatus.active
          : AccountSessionStatus.inactiveOrUninitialized;
    } catch (error) {
      return _classifyError(error);
    }
  }

  /// Clears only this app's local Supabase credentials. It does not call a
  /// backend session deactivation RPC and cannot invalidate another device.
  Future<void> clearLocalSession() async {
    await _client.auth.signOut(scope: SignOutScope.local);
  }

  Future<String> get installationId => _installationIdService.getId();

  AccountSessionStatus _classifyError(Object error) {
    if (error is AuthException &&
        (error.statusCode == '400' ||
            error.statusCode == '401' ||
            error.code == 'invalid_jwt')) {
      return AccountSessionStatus.credentialsExpired;
    }
    if (error is PostgrestException &&
        (error.code == '401' || error.code == 'PGRST301')) {
      return AccountSessionStatus.credentialsExpired;
    }
    return AccountSessionStatus.unavailable;
  }
}
