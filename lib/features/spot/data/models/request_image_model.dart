import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/request_image_entity.dart';
export '../../domain/entities/request_image_entity.dart';

part 'request_image_model.freezed.dart';
part 'request_image_model.g.dart';

@freezed
abstract class RequestImageModel extends Equatable
    with _$RequestImageModel
    implements RequestImageEntity {
  const RequestImageModel._() : super();

  const factory RequestImageModel({
    @JsonKey(defaultValue: '') required String id,
    @JsonKey(name: 'request_id', defaultValue: '') required String requestId,
    @JsonKey(name: 'storage_path', defaultValue: '')
    required String storagePath,
    @JsonKey(name: 'sort_order', fromJson: _intValue) required int sortOrder,
    @JsonKey(name: 'created_at', fromJson: _dateValue)
    required DateTime createdAt,
  }) = _RequestImageModel;

  factory RequestImageModel.fromJson(Map<String, dynamic> json) =>
      _$RequestImageModelFromJson(json);

  @override
  List<Object?> get props => [id, requestId, storagePath, sortOrder, createdAt];

  @JsonKey(includeToJson: false, includeFromJson: false)
  @override
  bool? get stringify => true;
}

int _intValue(Object? value) => int.tryParse(value?.toString() ?? '') ?? 0;

DateTime _dateValue(Object? value) =>
    DateTime.tryParse(value?.toString() ?? '')?.toUtc() ??
    DateTime.now().toUtc();
