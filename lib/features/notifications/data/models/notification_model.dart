import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/notification_entity.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
abstract class NotificationModel
    with _$NotificationModel
    implements NotificationEntity {
  const NotificationModel._();

  const factory NotificationModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String title,
    required String body,
    required String type,
    @Default(<String, dynamic>{}) Map<String, dynamic> data,
    @JsonKey(name: 'is_read') @Default(false) bool isRead,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(_normalizeNotificationJson(json));
}

Map<String, dynamic> _normalizeNotificationJson(Map<String, dynamic> json) {
  final copy = Map<String, dynamic>.from(json);
  copy['id'] = json['id']?.toString() ?? '';
  copy['user_id'] = (json['user_id'] ?? json['userId'])?.toString() ?? '';
  copy['title'] = json['title']?.toString() ?? '';
  copy['body'] = json['body']?.toString() ?? '';
  copy['type'] = json['type']?.toString() ?? 'general';
  copy['data'] = json['data'] is Map<String, dynamic>
      ? json['data']
      : (json['data'] is Map
            ? Map<String, dynamic>.from(json['data'] as Map)
            : <String, dynamic>{});
  copy['is_read'] = json['is_read'] ?? json['isRead'] ?? false;

  final rawCreatedAt = json['created_at'] ?? json['createdAt'];
  if (rawCreatedAt != null) {
    final parsed = DateTime.tryParse(rawCreatedAt.toString());
    copy['created_at'] = (parsed?.toUtc() ?? DateTime.now().toUtc())
        .toIso8601String();
  } else {
    copy['created_at'] = DateTime.now().toUtc().toIso8601String();
  }
  return copy;
}
