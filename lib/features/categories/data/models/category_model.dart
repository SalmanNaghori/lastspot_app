import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/category.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
abstract class CategoryModel extends Equatable
    with _$CategoryModel
    implements CategoryEntity {
  const CategoryModel._() : super();

  const factory CategoryModel({
    required String id,
    required String name,
    required String slug,
    required String icon,
    String? description,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'display_order') @Default(0) int sortOrder,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  @override
  List<Object?> get props => [
    id,
    name,
    slug,
    icon,
    description,
    isActive,
    sortOrder,
  ];

  @JsonKey(includeToJson: false, includeFromJson: false)
  @override
  bool? get stringify => true;
}
