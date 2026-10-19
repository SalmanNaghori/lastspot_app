import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_stats.freezed.dart';
part 'profile_stats.g.dart';

@freezed
abstract class ProfileStats with _$ProfileStats {
  const factory ProfileStats({
    @JsonKey(name: 'createdCount') @Default(0) int createdCount,
    @JsonKey(name: 'joinedCount') @Default(0) int joinedCount,
    @JsonKey(name: 'completedCount') @Default(0) int completedCount,
  }) = _ProfileStats;

  factory ProfileStats.fromJson(Map<String, dynamic> json) =>
      _$ProfileStatsFromJson(_normalizeJson(json));
}

Map<String, dynamic> _normalizeJson(Map<String, dynamic> json) {
  return <String, dynamic>{
    'createdCount': _toInt(json['createdCount'] ?? json['created_count']),
    'joinedCount': _toInt(json['joinedCount'] ?? json['joined_count']),
    'completedCount': _toInt(json['completedCount'] ?? json['completed_count']),
  };
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}
