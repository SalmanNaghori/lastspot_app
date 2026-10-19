// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfileStats _$ProfileStatsFromJson(Map<String, dynamic> json) =>
    _ProfileStats(
      createdCount: (json['createdCount'] as num?)?.toInt() ?? 0,
      joinedCount: (json['joinedCount'] as num?)?.toInt() ?? 0,
      completedCount: (json['completedCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ProfileStatsToJson(_ProfileStats instance) =>
    <String, dynamic>{
      'createdCount': instance.createdCount,
      'joinedCount': instance.joinedCount,
      'completedCount': instance.completedCount,
    };
