import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String icon;
  final String? description;
  final bool isActive;
  final int sortOrder;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.slug,
    required this.icon,
    this.description,
    this.isActive = true,
    this.sortOrder = 0,
  });

  @override
  List<Object?> get props => [id, name, slug, icon, description, isActive, sortOrder];
}
