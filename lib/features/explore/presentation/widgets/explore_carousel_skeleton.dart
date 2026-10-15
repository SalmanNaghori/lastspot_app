import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/features/spot/domain/entities/request_entity.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'explore_carousel_card.dart';

/// Skeleton placeholder matching the 3D perspective carousel layout while activities load.
class ExploreCarouselSkeleton extends StatelessWidget {
  const ExploreCarouselSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth * 0.76).clamp(270.0, 320.0);
    final cardHeight = Dimensions.h(400);

    final dummySpot = RequestEntity(
      id: 'skeleton_spot',
      userId: 'dummy_user',
      categoryId: 'sports',
      title: 'Loading Activity Title Here',
      description: 'Loading detailed activity description placeholder',
      locationName: 'Loading Location, City',
      latitude: 0,
      longitude: 0,
      eventDateTime: DateTime.now().add(const Duration(days: 1)),
      maxParticipants: 10,
      currentParticipants: 4,
      pricePerPerson: 100,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return Skeletonizer(
      enabled: true,
      child: Skeleton.ignorePointer(
        child: SizedBox(
          height: cardHeight + Dimensions.r20.dynamicH,
          width: screenWidth,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Left background card
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0012)
                  ..translateByDouble(-cardWidth * 0.48, 0.0, 0.0, 1.0)
                  ..scaleByDouble(0.86, 0.86, 1.0, 1.0)
                  ..rotateY(0.10),
                child: Opacity(
                  opacity: 0.6,
                  child: ExploreCarouselCard(
                    spot: dummySpot,
                    categoryName: 'Sport',
                    categoryIcon: '🎯',
                    heroTagPrefix: 'skeleton_left',
                    width: cardWidth,
                    height: cardHeight,
                  ),
                ),
              ),

              // Right background card
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0012)
                  ..translateByDouble(cardWidth * 0.48, 0.0, 0.0, 1.0)
                  ..scaleByDouble(0.86, 0.86, 1.0, 1.0)
                  ..rotateY(-0.10),
                child: Opacity(
                  opacity: 0.6,
                  child: ExploreCarouselCard(
                    spot: dummySpot,
                    categoryName: 'Sport',
                    categoryIcon: '🎯',
                    heroTagPrefix: 'skeleton_right',
                    width: cardWidth,
                    height: cardHeight,
                  ),
                ),
              ),

              // Center foreground card
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity(),
                child: ExploreCarouselCard(
                  spot: dummySpot,
                  categoryName: 'Sport',
                  categoryIcon: '🎯',
                  heroTagPrefix: 'skeleton_center',
                  width: cardWidth,
                  height: cardHeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
