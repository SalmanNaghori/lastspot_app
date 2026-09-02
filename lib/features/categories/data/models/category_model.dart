import '../../domain/entities/category.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.icon,
    super.description,
    super.isActive = true,
    super.sortOrder = 0,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      icon: json['icon'] as String,
      description: json['description'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      sortOrder: json['display_order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'icon': icon,
      'description': description,
      'is_active': isActive,
      'display_order': sortOrder,
    };
  }
}
