class AppSettingsModel {
  final VersionControl versionControl;
  final MaintenanceMode maintenanceMode;

  AppSettingsModel({
    required this.versionControl,
    required this.maintenanceMode,
  });

  factory AppSettingsModel.fromJson(
    Map<String, dynamic> vcJson,
    Map<String, dynamic> mmJson,
    String platform,
  ) {
    return AppSettingsModel(
      versionControl: VersionControl.fromJson(vcJson[platform] ?? {}),
      maintenanceMode: MaintenanceMode.fromJson(mmJson),
    );
  }
}

class VersionControl {
  final String latestVersion;
  final String minSupportedVersion;
  final String storeUrl;
  final List<String> blockedVersions;
  final Map<String, VersionMessage> versionMessages;

  VersionControl({
    required this.latestVersion,
    required this.minSupportedVersion,
    required this.storeUrl,
    required this.blockedVersions,
    required this.versionMessages,
  });

  factory VersionControl.fromJson(Map<String, dynamic> json) {
    final messagesJson =
        json['version_messages'] as Map<String, dynamic>? ?? {};
    final messages = messagesJson.map(
      (key, value) =>
          MapEntry(key, VersionMessage.fromJson(value as Map<String, dynamic>)),
    );

    return VersionControl(
      latestVersion: json['latest_version'] ?? '1.0.0',
      minSupportedVersion: json['min_supported_version'] ?? '1.0.0',
      storeUrl: json['store_url'] ?? '',
      blockedVersions: List<String>.from(json['blocked_versions'] ?? []),
      versionMessages: messages,
    );
  }
}

class VersionMessage {
  final String title;
  final String message;
  final List<String> releaseNotes;

  VersionMessage({
    required this.title,
    required this.message,
    required this.releaseNotes,
  });

  factory VersionMessage.fromJson(Map<String, dynamic> json) {
    return VersionMessage(
      title: json['title'] ?? 'New Version Available',
      message: json['message'] ?? 'Please update the app.',
      releaseNotes: List<String>.from(json['release_notes'] ?? []),
    );
  }
}

class MaintenanceMode {
  final bool globalMaintenance;
  final String globalTitle;
  final String globalMessage;
  final String? estimatedEndTime;
  final List<TargetedRule> targetedRules;

  MaintenanceMode({
    required this.globalMaintenance,
    required this.globalTitle,
    required this.globalMessage,
    this.estimatedEndTime,
    required this.targetedRules,
  });

  factory MaintenanceMode.fromJson(Map<String, dynamic> json) {
    final rulesList = json['targeted_rules'] as List<dynamic>? ?? [];
    return MaintenanceMode(
      globalMaintenance: json['global_maintenance'] ?? false,
      globalTitle: json['global_title'] ?? 'Scheduled Maintenance',
      globalMessage: json['global_message'] ?? 'We are currently offline.',
      estimatedEndTime: json['estimated_end_time'],
      targetedRules: rulesList
          .map((e) => TargetedRule.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class TargetedRule {
  final String id;
  final String platform;
  final List<String> affectedVersions;
  final String title;
  final String message;
  final bool isActive;

  TargetedRule({
    required this.id,
    required this.platform,
    required this.affectedVersions,
    required this.title,
    required this.message,
    required this.isActive,
  });

  factory TargetedRule.fromJson(Map<String, dynamic> json) {
    return TargetedRule(
      id: json['id'] ?? '',
      platform: json['platform'] ?? 'all',
      affectedVersions: List<String>.from(json['affected_versions'] ?? []),
      title: json['title'] ?? 'Maintenance',
      message: json['message'] ?? 'App is undergoing maintenance.',
      isActive: json['is_active'] ?? false,
    );
  }
}
