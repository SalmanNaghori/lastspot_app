import '../../domain/entities/request_image_entity.dart';
export '../../domain/entities/request_image_entity.dart';

class RequestImageModel extends RequestImageEntity {
  const RequestImageModel({
    required super.id,
    required super.requestId,
    required super.storagePath,
    required super.sortOrder,
    required super.createdAt,
  });

  factory RequestImageModel.fromJson(Map<String, dynamic> json) {
    return RequestImageModel(
      id: json['id'] as String,
      requestId: json['request_id'] as String,
      storagePath: json['storage_path'] as String,
      sortOrder: json['sort_order'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'request_id': requestId,
      'storage_path': storagePath,
      'sort_order': sortOrder,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
