import 'package:lastspot_app/core/base_import.dart';
import '../../domain/entities/request_entity.dart';
import 'sport_gradient_background.dart';
import 'spot_photo_viewer.dart';
import 'spot_photo_page_indicator.dart';

class SpotDetailsGallery extends StatefulWidget {
  final RequestEntity post;
  final String? heroTag;

  const SpotDetailsGallery({super.key, required this.post, this.heroTag});

  @override
  State<SpotDetailsGallery> createState() => _SpotDetailsGalleryState();
}

class _SpotDetailsGalleryState extends State<SpotDetailsGallery> {
  int _page = 0;
  final PageController _controller = PageController(keepPage: false);
  bool _viewerOpen = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openViewer() async {
    if (_viewerOpen || widget.post.images.isEmpty) return;
    _viewerOpen = true;
    final post = widget.post;
    try {
      await SpotPhotoViewer.show(
        context: context,
        post: post,
        initialPage: _page,
        onPageChanged: (page) {
          if (!mounted || widget.post != post) return;
          setState(() => _page = page);
          if (_controller.hasClients) _controller.jumpToPage(page);
        },
      );
    } finally {
      _viewerOpen = false;
    }
  }

  @override
  void didUpdateWidget(covariant SpotDetailsGallery oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post.id != widget.post.id ||
        oldWidget.post.images != widget.post.images) {
      _page = 0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _controller.hasClients) _controller.jumpToPage(0);
      });
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
                  controller: _controller,
                  itemCount: post.images.length,
                  onPageChanged: (page) => setState(() => _page = page),
                  itemBuilder: (context, index) => Semantics(
                    label: context.loc.detailsPhotoLabel(
                      index + 1,
                      post.images.length,
                    ),
                    image: true,
                    button: true,
                    onTap: _openViewer,
                    child: GestureDetector(
                      onTap: _openViewer,
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
                ),
              if (post.images.isNotEmpty)
                PositionedDirectional(
                  top: AppSpacing.smLg,
                  end: AppSpacing.smLg,
                  child: IconButton.filledTonal(
                    tooltip: context.loc.galleryOpen,
                    onPressed: _openViewer,
                    icon: const Icon(Icons.open_in_full_rounded),
                  ),
                ),
              if (post.images.length > 1)
                PositionedDirectional(
                  start: AppSpacing.md,
                  bottom: AppSpacing.md,
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: context.colorScheme.surface,
                      borderRadius: AppRadius.pillBorderRadius,
                    ),
                    child: SpotPhotoPageIndicator(
                      page: _page,
                      count: post.images.length,
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
