import 'package:equatable/equatable.dart';

class RequestImageEntity extends Equatable {
  final String id;
  final String requestId;
  final String storagePath;
  final int sortOrder;
  final DateTime createdAt;

  const RequestImageEntity({
    required this.id,
    required this.requestId,
    required this.storagePath,
    required this.sortOrder,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, requestId, storagePath, sortOrder, createdAt];
}
