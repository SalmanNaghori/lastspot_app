import 'package:intl/intl.dart';
import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/features/spot/domain/entities/request_entity.dart';

import 'spot_hero_image.dart';

class RecommendedSpotCard extends StatefulWidget {
  final RequestEntity spot;
  final String? heroTagPrefix;
  final VoidCallback onTap;

  const RecommendedSpotCard({
    super.key,
    required this.spot,
    this.heroTagPrefix,
    required this.onTap,
  });

  @override
  State<RecommendedSpotCard> createState() => _RecommendedSpotCardState();
}

class _RecommendedSpotCardState extends State<RecommendedSpotCard> {
  final ValueNotifier<bool> _isPressed = ValueNotifier(false);

  @override
  void dispose() {
    _isPressed.dispose();
    super.dispose();
  }

  String _formatDate(DateTime dt) => DateFormat('E, MMM d').format(dt);
  String _formatTime(DateTime dt) => DateFormat('h:mm a').format(dt);

  String _getDisplayLocation(String location) {
    final lower = location.toLowerCase();
    if (lower.startsWith('http://') || lower.startsWith('https://')) {
      return 'Map Location';
    }
    return location;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _isPressed.value = true,
      onTapUp: (_) => _isPressed.value = false,
      onTapCancel: () => _isPressed.value = false,
      onTap: widget.onTap,
      child: ValueListenableBuilder<bool>(
        valueListenable: _isPressed,
        builder: (context, isPressed, child) => AnimatedScale(
          scale: isPressed ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          child: child,
        ),
        child: Container(
          width: Dimensions.r24.dynamicW * 11.5,
          margin: EdgeInsets.only(right: Dimensions.r16.dynamicW),
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
            border: Border.all(color: context.borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: AppColor.blackColor.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Image Wrapper
              SizedBox(
                height: Dimensions.r24.dynamicH * 5.5,
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(Dimensions.r16.dynamicR - 1),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      SpotHeroImage(
                        spot: widget.spot,
                        isUrgent: false,
                        spotsLeftText: '',
                        perPersonLabel:
                            '/ person', // Let the card's other logic or SpotHeroImage handle it natively
                        heroTagPrefix: widget.heroTagPrefix,
                      ),
                    ],
                  ),
                ),
              ),
              // Body
              Padding(
                padding: EdgeInsets.all(Dimensions.r12.dynamicW),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.spot.title.trim().isNotEmpty
                          ? widget.spot.title.trim()
                          : _getDisplayLocation(widget.spot.locationName),
                      style: TextStyle(
                        fontSize: Dimensions.r15.dynamicSP,
                        fontWeight: FontWeight.w700,
                        color: context.textPrimary,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: Dimensions.r6.dynamicH),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: Dimensions.r14.dynamicH,
                          color: context.textSecondary,
                        ),
                        SizedBox(width: Dimensions.r4.dynamicW),
                        Expanded(
                          child: Text(
                            _getDisplayLocation(widget.spot.locationName),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: Dimensions.r12.dynamicSP,
                              color: context.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.r4.dynamicH),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: Dimensions.r14.dynamicH,
                          color: context.textSecondary,
                        ),
                        SizedBox(width: Dimensions.r4.dynamicW),
                        Expanded(
                          child: Text(
                            '${_formatDate(widget.spot.eventDateTime)}, ${_formatTime(widget.spot.eventDateTime)}',
                            style: TextStyle(
                              fontSize: Dimensions.r12.dynamicSP,
                              color: context.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
