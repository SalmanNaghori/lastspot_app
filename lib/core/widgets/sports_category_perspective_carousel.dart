import 'package:lastspot_app/core/base_import.dart';
import '../../features/categories/domain/entities/category.dart';
import 'sports_category_perspective_card.dart';

enum SportsCarouselMode {
  /// Home mode: Center card opens Explore; side cards animate to center without navigating; swiping does not navigate.
  home,

  /// Explore mode: Centered card is active filter; swiping/snapping updates filter; tapping side card centers and updates filter.
  explore,
}

/// Representation of an item within [SportsCategoryPerspectiveCarousel].
class SportsCarouselItem {
  final String? id;
  final String name;
  final String? slug;
  final CategoryEntity? category;
  final bool isAll;

  const SportsCarouselItem({
    this.id,
    this.name = '',
    this.slug,
    this.category,
    this.isAll = false,
  });

  factory SportsCarouselItem.fromCategory(CategoryEntity category) =>
      SportsCarouselItem(
        id: category.id,
        name: category.name,
        slug: category.slug,
        category: category,
        isAll: false,
      );

  factory SportsCarouselItem.all() =>
      const SportsCarouselItem(id: null, name: '', slug: 'all', isAll: true);
}

/// Unified 3D perspective-stack sports category carousel.
///
/// Features:
/// - Prominent center card (scale 1.0, highest elevation, topmost z-index)
/// - Left & right side cards layered progressively behind with natural overlap
/// - Perspective transforms via Matrix4 (facing subtly toward center)
/// - Smooth horizontal drag & natural inertia snapping without autoplay
/// - Tapping side cards animates them to center
/// - Pixel-perfect hit-testing (no invisible blockers intercepting touches)
/// - Performance-isolated state (does not trigger parent screen rebuilds)
class SportsCategoryPerspectiveCarousel extends StatefulWidget {
  final List<CategoryEntity> categories;
  final String? selectedCategoryId;
  final bool includeAllOption;
  final SportsCarouselMode mode;
  final ValueChanged<CategoryEntity>? onCategoryTap;
  final ValueChanged<String?>? onCategorySelected;
  final VoidCallback? onInteraction;
  final double? cardWidth;
  final double? cardHeight;
  final double? carouselHeight;

  const SportsCategoryPerspectiveCarousel({
    super.key,
    required this.categories,
    this.selectedCategoryId,
    this.includeAllOption = false,
    this.mode = SportsCarouselMode.home,
    this.onCategoryTap,
    this.onCategorySelected,
    this.onInteraction,
    this.cardWidth,
    this.cardHeight,
    this.carouselHeight,
  });

  @override
  State<SportsCategoryPerspectiveCarousel> createState() =>
      _SportsCategoryPerspectiveCarouselState();
}

class _SportsCategoryPerspectiveCarouselState
    extends State<SportsCategoryPerspectiveCarousel>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  Animation<double>? _snapAnimation;

  List<SportsCarouselItem> _items = const [];
  double _page = 0.0;
  int _lastNotifiedIndex = -1;

  int get _currentIndex =>
      _items.isEmpty ? 0 : _page.round().clamp(0, _items.length - 1);

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _buildItems();
    _initInitialPosition();
  }

  @override
  void didUpdateWidget(SportsCategoryPerspectiveCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    final categoriesChanged =
        widget.categories.length != oldWidget.categories.length ||
        widget.includeAllOption != oldWidget.includeAllOption;

    if (categoriesChanged) {
      _buildItems();
    }

    if (widget.selectedCategoryId != oldWidget.selectedCategoryId ||
        categoriesChanged) {
      _syncToSelectedId(widget.selectedCategoryId);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _buildItems() {
    final List<SportsCarouselItem> items = [];
    if (widget.includeAllOption) {
      items.add(SportsCarouselItem.all());
    }
    for (final cat in widget.categories) {
      items.add(SportsCarouselItem.fromCategory(cat));
    }
    _items = items;
  }

  void _initInitialPosition() {
    if (_items.isEmpty) return;
    int target = 0;
    if (widget.selectedCategoryId != null) {
      final index = _items.indexWhere((i) => i.id == widget.selectedCategoryId);
      if (index != -1) target = index;
    }
    _page = target.toDouble();
    _lastNotifiedIndex = target;
  }

  void _syncToSelectedId(String? selectedId) {
    if (_items.isEmpty) return;
    int targetIndex = 0;
    if (selectedId != null) {
      final index = _items.indexWhere((i) => i.id == selectedId);
      if (index != -1) targetIndex = index;
    } else if (widget.includeAllOption) {
      targetIndex = 0;
    }
    if (targetIndex != _currentIndex && targetIndex < _items.length) {
      _animateToPage(targetIndex);
    }
  }

  void _onDragStart(DragStartDetails details) {
    _animController.stop();
    widget.onInteraction?.call();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_items.isEmpty) return;
    final delta = details.primaryDelta ?? 0.0;
    final effectiveCardWidth = widget.cardWidth ?? Dimensions.r120.dynamicW;
    final dragStep = effectiveCardWidth * 0.92;
    double deltaPages = -delta / dragStep;

    // Boundary damping
    if ((_page <= 0 && deltaPages < 0) ||
        (_page >= _items.length - 1 && deltaPages > 0)) {
      deltaPages *= 0.35;
    }

    setState(() {
      _page = (_page + deltaPages).clamp(-0.5, _items.length - 0.5);
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (_items.isEmpty) return;
    final velocity = details.primaryVelocity ?? 0.0;
    int targetIndex;

    if (velocity < -250) {
      targetIndex = _page.floor() + 1;
    } else if (velocity > 250) {
      targetIndex = _page.ceil() - 1;
    } else {
      targetIndex = _page.round();
    }

    targetIndex = targetIndex.clamp(0, _items.length - 1);
    _animateToPage(targetIndex);
  }

  void _animateToPage(int targetIndex) {
    _animController.stop();
    final startPage = _page;
    final endPage = targetIndex.toDouble();

    if ((startPage - endPage).abs() < 0.001) {
      _onSettledAt(targetIndex);
      return;
    }

    _snapAnimation =
        Tween<double>(begin: startPage, end: endPage).animate(
            CurvedAnimation(
              parent: _animController,
              curve: Curves.easeOutCubic,
            ),
          )
          ..addListener(() {
            setState(() {
              _page = _snapAnimation!.value;
            });
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _onSettledAt(targetIndex);
            }
          });

    _animController.forward(from: 0.0);
  }

  void _onSettledAt(int targetIndex) {
    if (widget.mode == SportsCarouselMode.explore) {
      if (_lastNotifiedIndex != targetIndex) {
        _lastNotifiedIndex = targetIndex;
        final item = _items[targetIndex];
        widget.onCategorySelected?.call(item.id);
      }
    }
  }

  void _handleCardTap(int index) {
    if (_items.isEmpty || index < 0 || index >= _items.length) return;
    widget.onInteraction?.call();

    if (index == _currentIndex) {
      // Tap on centered card
      if (widget.mode == SportsCarouselMode.home) {
        final item = _items[index];
        if (item.category != null) {
          widget.onCategoryTap?.call(item.category!);
        } else if (item.isAll) {
          widget.onCategorySelected?.call(null);
        }
      }
    } else {
      // Tap on side card: smoothly animate to center without navigating
      _animateToPage(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) {
      return const SizedBox.shrink();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final effectiveCardWidth = widget.cardWidth ?? Dimensions.r120.dynamicW;
    final effectiveCardHeight = widget.cardHeight ?? Dimensions.r140.dynamicH;
    final effectiveCarouselHeight =
        widget.carouselHeight ??
        (effectiveCardHeight + Dimensions.r20.dynamicH);

    final step1 = (screenWidth * 0.22).clamp(76.0, 90.0);
    final step2 = (screenWidth * 0.17).clamp(60.0, 72.0);

    // Visible cards within ~2.8 items distance from floating page
    final visibleIndices = <int>[];
    for (int i = 0; i < _items.length; i++) {
      if ((i - _page).abs() < 2.8) {
        visibleIndices.add(i);
      }
    }

    // Sort descending by distance:
    // Farthest card paints FIRST (at bottom of Stack)
    // Closest card paints LAST (on top of Stack)
    visibleIndices.sort((a, b) {
      final distA = (a - _page).abs();
      final distB = (b - _page).abs();
      return distB.compareTo(distA);
    });

    return SizedBox(
      height: effectiveCarouselHeight,
      width: screenWidth,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragStart: _onDragStart,
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: _onDragEnd,
        child: RepaintBoundary(
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: visibleIndices.map((index) {
              final d = index - _page;
              final absD = d.abs();

              // Scale: 1.0 at center, 0.84 at distance 1, 0.70 at distance 2
              final double scale;
              if (absD <= 1.0) {
                scale = 1.0 - 0.16 * absD;
              } else if (absD <= 2.0) {
                scale = 0.84 - 0.14 * (absD - 1.0);
              } else {
                scale = (0.70 - 0.12 * (absD - 2.0)).clamp(0.50, 0.70);
              }

              // Horizontal translation with natural overlap
              final double translateX;
              if (absD <= 1.0) {
                translateX = d * step1;
              } else {
                translateX = d.sign * (step1 + (absD - 1.0) * step2);
              }

              // Subtle perspective rotation around Y-axis
              final rotationY = -d.clamp(-2.0, 2.0) * 0.06;

              final matrix = Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..translateByDouble(translateX, 0.0, 0.0, 1.0)
                ..scaleByDouble(scale, scale, 1.0, 1.0)
                ..rotateY(rotationY);

              final isCenter = absD < 0.5;
              final item = _items[index];
              final isSelected = widget.mode == SportsCarouselMode.explore
                  ? (widget.selectedCategoryId == item.id)
                  : false;

              final opticalDepth = (0.04 * absD).clamp(0.0, 0.12);

              return Transform(
                key: ValueKey('perspective_cat_${item.id ?? "all"}_$index'),
                alignment: Alignment.center,
                transform: matrix,
                child: SportsCategoryPerspectiveCard(
                  name: item.name,
                  slug: item.slug,
                  isAll: item.isAll,
                  isCenter: isCenter,
                  isSelected: isSelected,
                  width: effectiveCardWidth,
                  height: effectiveCardHeight,
                  opticalDepth: opticalDepth,
                  onTap: () => _handleCardTap(index),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
