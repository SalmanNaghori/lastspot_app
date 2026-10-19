import '../base_import.dart';
import '../../features/categories/domain/entities/category.dart';

/// Reusable sports discovery and selection card featuring 3D equipment illustration.
///
/// Designed per the KhelBhai design system:
/// - Rounded container with soft category-specific tint
/// - High-performance cached 3D equipment asset decoding
/// - Accessible semantics and tactile tap feedback
/// - Support for active selection state with primary brand border
class CategoryCard extends StatelessWidget {
  final CategoryEntity category;
  final bool isSelected;
  final VoidCallback onTap;
  final double? width;
  final double? height;
  final String? countText;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
    this.isSelected = false,
    this.width,
    this.height,
    this.countText,
  });

  @override
  Widget build(BuildContext context) {
    return SportCategoryTile(
      category: category,
      isSelected: isSelected,
      onTap: onTap,
      width: width,
      height: height,
    );
  }
}
