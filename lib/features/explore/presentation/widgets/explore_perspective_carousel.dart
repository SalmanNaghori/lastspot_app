import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/features/spot/domain/entities/request_entity.dart';

import 'explore_carousel_card.dart';

/// Center-focused, perspective-based 3D activity carousel.
///
/// Features:
/// - One prominent center activity card (scale 1.0, highest z-index)
/// - Left & right side cards layered progressively behind with controlled overlap
/// - True 3D perspective rotation via Matrix4 (facing subtly toward center)
/// - Smooth horizontal swiping with native PageView drag inertia and snapping
/// - Tapping a side card smoothly animates it to center
/// - Tapping the center card or View Spot opens the activity details
/// - Depth-based render sorting (Stack sorted by distance descending)
/// - Handles empty, 1-item, 2-item, and 3+ item states gracefully
class ExplorePerspectiveCarousel extends StatefulWidget {
  final List<RequestEntity> spots;
  final ValueChanged<RequestEntity> onSpotTap;
  final VoidCallback? onEndReached;
  final String? heroTagPrefix;

  const ExplorePerspectiveCarousel({
    super.key,
    required this.spots,
    required this.onSpotTap,
    this.onEndReached,
    this.heroTagPrefix = 'explore',
  });

  @override
  State<ExplorePerspectiveCarousel> createState() =>
      _ExplorePerspectiveCarouselState();
}

class _ExplorePerspectiveCarouselState
    extends State<ExplorePerspectiveCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  double _viewportFraction = 0.76;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _currentPage,
      viewportFraction: _viewportFraction,
    );
  }

  @override
  void didUpdateWidget(ExplorePerspectiveCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.spots.length != oldWidget.spots.length) {
      final maxIndex = (widget.spots.length - 1)
          .clamp(0, double.infinity)
          .toInt();
      if (_currentPage > maxIndex) {
        _currentPage = maxIndex;
        if (_pageController.hasClients) {
          _pageController.jumpToPage(maxIndex);
        }
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
    if (index >= widget.spots.length - 2) {
      widget.onEndReached?.call();
    }
  }

  void _handleCardTap(int index) {
    if (index == _currentPage) {
      widget.onSpotTap(widget.spots[index]);
    } else {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.spots.isEmpty) {
      return const SizedBox.shrink();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth * 0.76).clamp(270.0, 320.0);
    final cardHeight = Dimensions.h(400);

    // Update viewportFraction dynamically to match card width
    final computedFraction = (cardWidth / screenWidth).clamp(0.65, 0.85);
    if ((computedFraction - _viewportFraction).abs() > 0.01) {
      _viewportFraction = computedFraction;
      final currentPos = _pageController.hasClients
          ? _pageController.page?.round() ?? _currentPage
          : _currentPage;
      _pageController.dispose();
      _pageController = PageController(
        initialPage: currentPos,
        viewportFraction: _viewportFraction,
      );
    }

    // 1-item state: Single centered card without fake neighbors
    if (widget.spots.length == 1) {
      return Center(
        child: SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: ExploreCarouselCard(
            spot: widget.spots.first,
            heroTagPrefix: widget.heroTagPrefix,
            width: cardWidth,
            height: cardHeight,
            onTap: () => widget.onSpotTap(widget.spots.first),
          ),
        ),
      );
    }

    return SizedBox(
      height: cardHeight + Dimensions.r20.dynamicH,
      width: screenWidth,
      child: AnimatedBuilder(
        animation: _pageController,
        builder: (context, _) {
          final double page = _pageController.hasClients
              ? (_pageController.page ?? _currentPage.toDouble())
              : _currentPage.toDouble();

          // Gather nearby visible indices (|index - page| < 2.5)
          final visibleIndices = <int>[];
          for (int i = 0; i < widget.spots.length; i++) {
            if ((i - page).abs() < 2.5) {
              visibleIndices.add(i);
            }
          }

          // Sort descending by distance from center:
          // Farthest card paints FIRST (at bottom of Stack)
          // Closest card paints LAST (on TOP of Stack)
          visibleIndices.sort((a, b) {
            final distA = (a - page).abs();
            final distB = (b - page).abs();
            return distB.compareTo(distA);
          });

          return Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // 1. Perspective Visual Cards Layer
              ...visibleIndices.map((index) {
                final d = index - page;
                final absD = d.abs();

                // Scale: 1.0 at center, ~0.86 at dist 1, ~0.72 at dist 2
                final scale = (1.0 - 0.14 * absD).clamp(0.68, 1.0);

                // Horizontal translation with controlled overlap
                final double translateX;
                if (absD <= 1.0) {
                  translateX = d * (cardWidth * 0.48);
                } else {
                  final sign = d.sign;
                  translateX =
                      sign *
                      ((cardWidth * 0.48) + (absD - 1.0) * (cardWidth * 0.22));
                }

                // Subtle 3D perspective rotation (facing slightly toward center)
                final matrix = Matrix4.identity()
                  ..setEntry(3, 2, 0.0012)
                  ..translateByDouble(translateX, 0.0, 0.0, 1.0)
                  ..scaleByDouble(scale, scale, 1.0, 1.0)
                  ..rotateY(-d.clamp(-2.0, 2.0) * 0.10);

                final isCenter = absD < 0.5;

                return Transform(
                  key: ValueKey('explore_3d_card_$index'),
                  alignment: Alignment.center,
                  transform: matrix,
                  child: RepaintBoundary(
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              Dimensions.r20.dynamicR,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColor.blackColor.withValues(
                                  alpha: isCenter ? 0.12 : 0.05,
                                ),
                                blurRadius: isCenter
                                    ? Dimensions.r18.dynamicR
                                    : Dimensions.r8.dynamicR,
                                offset: Offset(
                                  0,
                                  isCenter
                                      ? Dimensions.r8.dynamicH
                                      : Dimensions.r4.dynamicH,
                                ),
                              ),
                            ],
                          ),
                          child: ExploreCarouselCard(
                            spot: widget.spots[index],
                            heroTagPrefix: isCenter
                                ? widget.heroTagPrefix
                                : 'inactive_${widget.spots[index].id}',
                            width: cardWidth,
                            height: cardHeight,
                            onTap: () => _handleCardTap(index),
                          ),
                        ),

                        // Subtle depth dimming overlay on side cards
                        if (absD > 0.05)
                          Positioned.fill(
                            child: IgnorePointer(
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      (context.isDarkMode
                                              ? AppColor.blackColor
                                              : context.backgroundColor)
                                          .withValues(
                                            alpha: (0.16 * absD).clamp(
                                              0.0,
                                              0.35,
                                            ),
                                          ),
                                  borderRadius: BorderRadius.circular(
                                    Dimensions.r20.dynamicR,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),

              // 2. Interactive Gesture Layer (PageView)
              Positioned.fill(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.spots.length,
                  onPageChanged: _onPageChanged,
                  itemBuilder: (context, index) {
                    return Semantics(
                      button: true,
                      label: widget.spots[index].title,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => _handleCardTap(index),
                        child: const ColoredBox(color: Colors.transparent),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
