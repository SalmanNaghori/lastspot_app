import 'package:lastspot_app/core/base_import.dart';
import '../../domain/entities/request_entity.dart';
import 'sport_gradient_background.dart';

class SpotDetailsGallery extends StatefulWidget {
  final RequestEntity post;
  final String? heroTag;

  const SpotDetailsGallery({super.key, required this.post, this.heroTag});

  @override
  State<SpotDetailsGallery> createState() => _SpotDetailsGalleryState();
}

class _SpotDetailsGalleryState extends State<SpotDetailsGallery> {
  int _page = 0;

  @override
  void didUpdateWidget(covariant SpotDetailsGallery oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post.id != widget.post.id ||
        oldWidget.post.images.length != widget.post.images.length) {
      _page = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    return Hero(
      tag: widget.heroTag ?? 'activity_image_${post.id}',
      child: ClipRRect(
        borderRadius: AppRadius.xxlBorderRadius,
        child: AspectRatio(
          aspectRatio: Dimensions.detailsGalleryRatio,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (post.images.isEmpty)
                ExcludeSemantics(
                  child: SportGradientBackground(categoryId: post.categoryId),
                )
              else
                PageView.builder(
                  key: ValueKey('${post.id}_${post.images.length}'),
                  itemCount: post.images.length,
                  onPageChanged: (page) => setState(() => _page = page),
                  itemBuilder: (context, index) => Semantics(
                    label: context.loc.detailsPhotoLabel(
                      index + 1,
                      post.images.length,
                    ),
                    image: true,
                    child: AppCachedNetworkImage(
                      imageUrl: post.images[index].storagePath,
                      fit: BoxFit.cover,
                      memCacheWidth: Dimensions.detailsImageCacheWidth,
                      errorWidget: SportGradientBackground(
                        categoryId: post.categoryId,
                      ),
                    ),
                  ),
                ),
              if (post.images.length > 1)
                PositionedDirectional(
                  end: AppSpacing.md,
                  bottom: AppSpacing.md,
                  child: Semantics(
                    liveRegion: true,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.smLg,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: context.colorScheme.surface,
                        borderRadius: AppRadius.pillBorderRadius,
                      ),
                      child: Text(
                        context.loc.detailsPhotoCount(
                          _page + 1,
                          post.images.length,
                        ),
                        style: context.labelMedium,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
