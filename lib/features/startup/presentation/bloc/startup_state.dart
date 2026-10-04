import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/models/app_settings_model.dart';

part 'startup_state.freezed.dart';

@freezed
class StartupState with _$StartupState {
  const factory StartupState.initial() = _Initial;
  const factory StartupState.loading() = _Loading;
  const factory StartupState.maintenanceMode({
    required String title,
    required String message,
  }) = _MaintenanceMode;
  const factory StartupState.updateRequired({
    required VersionMessage messageData,
    required String storeUrl,
    required bool isForced,
    String? latestVersion,
  }) = _UpdateRequired;
  const factory StartupState.success() = _Success;
  const factory StartupState.error({
    required String message,
  }) = _Error;
}
