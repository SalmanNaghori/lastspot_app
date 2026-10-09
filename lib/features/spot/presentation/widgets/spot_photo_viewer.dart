import 'package:flutter/material.dart';

import '../../../../core/constants/dimensions.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_cached_network_image.dart';
import '../../../../core/widgets/dialogs/app_dialog.dart';
import '../../domain/entities/request_entity.dart';
import 'spot_photo_page_indicator.dart';

/// Non-addressable photo overlay; keeps the selected image in sync with details.
class SpotPhotoViewer extends StatefulWidget {
  final RequestEntity post;
  final int initialPage;
  final ValueChanged<int> onPageChanged;

  const SpotPhotoViewer({
    super.key,
    required this.post,
    required this.initialPage,
    required this.onPageChanged,
  });

  static Future<void> show({
    required BuildContext context,
    required RequestEntity post,
    required int initialPage,
    required ValueChanged<int> onPageChanged,
  }) async {
    if (post.images.isEmpty) return;
    await AppDialog.showOverlay<void>(
      context: context,
      fullscreen: true,
      builder: (context) => SpotPhotoViewer(
        post: post,
        initialPage: initialPage.clamp(0, post.images.length - 1),
        onPageChanged: onPageChanged,
      ),
    );
  }

  @override
  State<SpotPhotoViewer> createState() => _SpotPhotoViewerState();
}

class _SpotPhotoViewerState extends State<SpotPhotoViewer> {
  late final PageController _controller;
  late int _page;
  bool _isZoomed = false;

  @override
  void initState() {
    super.initState();
    _page = widget.initialPage;
    _controller = PageController(initialPage: _page);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectPage(int page) async {
    final duration = AppMotion.duration(context, AppMotion.standard);
    if (duration == Duration.zero) {
      _controller.jumpToPage(page);
      return;
    }
    await _controller.animateToPage(
      page,
      duration: duration,
      curve: AppMotion.curve,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    return Dialog.fullscreen(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Row(
                children: [
                  const CloseButton(),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      widget.post.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  const SizedBox(width: AppSpacing.sm),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                physics: _isZoomed
                    ? const NeverScrollableScrollPhysics()
                    : null,
                itemCount: widget.post.images.length,
                onPageChanged: (page) {
                  setState(() {
                    _page = page;
                    _isZoomed = false;
                  });
                  widget.onPageChanged(page);
                },
                itemBuilder: (context, index) => _ZoomablePhoto(
                  key: ValueKey(widget.post.images[index].id),
                  imageUrl: widget.post.images[index].storagePath,
                  label: loc.detailsPhotoLabel(
                    index + 1,
                    widget.post.images.length,
                  ),
                  isActive: _page == index,
                  onZoomChanged: (zoomed) {
                    if (mounted && index == _page && _isZoomed != zoomed) {
                      setState(() => _isZoomed = zoomed);
                    }
                  },
                ),
              ),
            ),
            if (widget.post.images.length > 1)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: SpotPhotoPageIndicator(
                  page: _page,
                  count: widget.post.images.length,
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  IconButton.filledTonal(
                    tooltip: loc.galleryPrevious,
                    onPressed: _page > 0 ? () => _selectPage(_page - 1) : null,
                    icon: const Icon(Icons.chevron_left_rounded),
                  ),
                  Expanded(
                    child: Text(
                      loc.galleryZoomHint,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  IconButton.filledTonal(
                    tooltip: loc.galleryNext,
                    onPressed: _page < widget.post.images.length - 1
                        ? () => _selectPage(_page + 1)
                        : null,
                    icon: const Icon(Icons.chevron_right_rounded),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ZoomablePhoto extends StatefulWidget {
  final String imageUrl;
  final String label;
  final bool isActive;
  final ValueChanged<bool> onZoomChanged;

  const _ZoomablePhoto({
    required this.imageUrl,
    required this.label,
    required this.isActive,
    required this.onZoomChanged,
    super.key,
  });

  @override
  State<_ZoomablePhoto> createState() => _ZoomablePhotoState();
}

class _ZoomablePhotoState extends State<_ZoomablePhoto> {
  final TransformationController _transform = TransformationController();
  bool _zoomed = false;

  @override
  void initState() {
    super.initState();
    _transform.addListener(_onTransform);
  }

  void _onTransform() {
    final zoomed = _transform.value.getMaxScaleOnAxis() > 1.01;
    if (zoomed != _zoomed) {
      setState(() => _zoomed = zoomed);
      widget.onZoomChanged(zoomed);
    }
  }

  @override
  void didUpdateWidget(covariant _ZoomablePhoto oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive && !widget.isActive) {
      _transform.value = Matrix4.identity();
    }
  }

  @override
  void dispose() {
    _transform.removeListener(_onTransform);
    _transform.dispose();
    super.dispose();
  }

  void _toggleZoom() {
    final size = context.size;
    if (_zoomed || size == null) {
      _transform.value = Matrix4.identity();
    } else {
      _transform.value = Matrix4.identity()
        ..translateByDouble(-size.width / 2, -size.height / 2, 0, 1)
        ..scaleByDouble(2, 2, 1, 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Stack(
      fit: StackFit.expand,
      children: [
        Semantics(
          image: true,
          label: widget.label,
          child: GestureDetector(
            onDoubleTap: _toggleZoom,
            child: InteractiveViewer(
              transformationController: _transform,
              minScale: 1,
              maxScale: Dimensions.galleryMaxScale,
              child: SizedBox.expand(
                child: AppCachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  fit: BoxFit.contain,
                  memCacheWidth: Dimensions.galleryImageCacheWidth,
                ),
              ),
            ),
          ),
        ),
        PositionedDirectional(
          end: AppSpacing.md,
          bottom: AppSpacing.md,
          child: IconButton.filledTonal(
            tooltip: _zoomed ? loc.galleryZoomOut : loc.galleryZoomIn,
            onPressed: _toggleZoom,
            icon: Icon(
              _zoomed ? Icons.zoom_out_rounded : Icons.zoom_in_rounded,
            ),
          ),
        ),
      ],
    );
  }
}
