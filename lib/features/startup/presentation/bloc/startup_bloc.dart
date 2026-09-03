import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/shared_prefs_util.dart';
import 'startup_event.dart';
import 'startup_state.dart';
import '../../data/models/app_settings_model.dart';

class StartupBloc extends Bloc<StartupEvent, StartupState> {
  final SupabaseClient _supabaseClient;
  final SharedPrefsUtil _prefs;

  StartupBloc({
    required SupabaseClient supabaseClient,
    required SharedPrefsUtil prefs,
  }) : _supabaseClient = supabaseClient,
       _prefs = prefs,
       super(StartupInitial()) {
    on<StartupInitialCheckRequested>(_onInitialCheckRequested);
    on<StartupUpdateSkipped>(_onUpdateSkipped);
  }

  Future<void> _onInitialCheckRequested(
    StartupInitialCheckRequested event,
    Emitter<StartupState> emit,
  ) async {
    emit(StartupLoading());

    try {
      // 1. Fetch remote settings
      final response = await _supabaseClient
          .from('app_settings')
          .select('key, value')
          .inFilter('key', ['version_control', 'maintenance_mode']);

      Map<String, dynamic> vcJson = {};
      Map<String, dynamic> mmJson = {};

      for (var row in response) {
        if (row['key'] == 'version_control') {
          vcJson = row['value'] as Map<String, dynamic>;
        } else if (row['key'] == 'maintenance_mode') {
          mmJson = row['value'] as Map<String, dynamic>;
        }
      }

      final String platform = Platform.isIOS ? 'ios' : 'android';
      final appSettings = AppSettingsModel.fromJson(vcJson, mmJson, platform);

      // Get current app version
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersionString = packageInfo.version;

      // Basic fallback if semver parsing fails
      Version currentVersion;
      try {
        currentVersion = Version.parse(currentVersionString);
      } catch (e) {
        currentVersion = Version(1, 0, 0); // fallback
      }

      // 2. Check Global Maintenance
      if (appSettings.maintenanceMode.globalMaintenance) {
        emit(
          StartupMaintenanceMode(
            title: appSettings.maintenanceMode.globalTitle,
            message: appSettings.maintenanceMode.globalMessage,
          ),
        );
        return;
      }

      // 3. Check Targeted Maintenance
      for (var rule in appSettings.maintenanceMode.targetedRules) {
        if (rule.isActive &&
            (rule.platform == 'all' || rule.platform == platform)) {
          if (rule.affectedVersions.contains(currentVersionString)) {
            emit(
              StartupMaintenanceMode(title: rule.title, message: rule.message),
            );
            return;
          }
        }
      }

      // 4. Check Blocked / Forced Update
      final vc = appSettings.versionControl;
      Version minSupportedVersion;
      try {
        minSupportedVersion = Version.parse(vc.minSupportedVersion);
      } catch (e) {
        minSupportedVersion = Version(1, 0, 0);
      }

      bool isBlocked = vc.blockedVersions.contains(currentVersionString);
      bool isBelowMin = currentVersion.compareTo(minSupportedVersion) < 0;

      if (isBlocked || isBelowMin) {
        final messageData =
            vc.versionMessages[currentVersionString] ??
            vc.versionMessages['default'] ??
            VersionMessage(
              title: 'Update Required',
              message: 'Please update.',
              releaseNotes: [],
            );

        emit(
          StartupUpdateRequired(
            messageData: messageData,
            storeUrl: vc.storeUrl,
            isForced: true,
          ),
        );
        return;
      }

      // 5. Check Soft / Optional Update
      Version latestVersion;
      try {
        latestVersion = Version.parse(vc.latestVersion);
      } catch (e) {
        latestVersion = Version(1, 0, 0);
      }

      // In debug mode during local development, do not show soft update dialog
      if (!kDebugMode && currentVersion.compareTo(latestVersion) < 0) {
        await _prefs.reload();
        final skippedVersion = _prefs.getSkippedUpdateVersion();

        if (skippedVersion != latestVersion.toString()) {
          final messageData =
              vc.versionMessages[currentVersionString] ??
              vc.versionMessages['default'] ??
              VersionMessage(
                title: 'Update Available',
                message: 'A new version is available.',
                releaseNotes: [],
              );

          emit(
            StartupUpdateRequired(
              messageData: messageData,
              storeUrl: vc.storeUrl,
              isForced: false,
              latestVersion: latestVersion.toString(),
            ),
          );
          return;
        }
      }

      // 6. Success
      emit(StartupSuccess());
    } catch (e) {
      // If offline or error, allow boot but log error (or emit error state based on requirements)
      emit(StartupSuccess()); // Failing open for MVP
    }
  }

  Future<void> _onUpdateSkipped(
    StartupUpdateSkipped event,
    Emitter<StartupState> emit,
  ) async {
    try {
      await _prefs.setSkippedUpdateVersion(event.version);
    } catch (_) {}
    emit(StartupSuccess());
  }
}
