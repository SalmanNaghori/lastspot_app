import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/features/spot/domain/entities/request_entity.dart';

import 'spot_hero_image.dart';

class CompactSpotCard extends StatefulWidget {
  final RequestEntity spot;
  final String? heroTagPrefix;
  final VoidCallback onTap;

  const CompactSpotCard({
    super.key,
    required this.spot,
    this.heroTagPrefix,
    required this.onTap,
  });

  @override
  State<CompactSpotCard> createState() => _CompactSpotCardState();
}

class _CompactSpotCardState extends State<CompactSpotCard> {
  final ValueNotifier<bool> _isPressed = ValueNotifier(false);

  @override
  void dispose() {
    _isPressed.dispose();
    super.dispose();
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
          margin: EdgeInsets.only(bottom: Dimensions.r16.dynamicH),
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
            border: Border.all(color: context.borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: AppColor.blackColor.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Left Image
              SizedBox(
                width: Dimensions.r24.dynamicW * 4.5,
                height: Dimensions.r24.dynamicH * 4.5,
                child: ClipRRect(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(Dimensions.r12.dynamicR - 1),
                  ),
                  child: SpotHeroImage(
                    spot: widget.spot,
                    isUrgent: false,
                    spotsLeftText: '',
                    perPersonLabel: '/ person',
                    heroTagPrefix: widget.heroTagPrefix,
                  ),
                ),
              ),
              // Right Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.r12.dynamicW),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.spot.title.trim().isNotEmpty
                            ? widget.spot.title.trim()
                            : AppUtils.getDisplayLocation(
                                context,
                                widget.spot.locationName,
                              ),
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
                            Icons.calendar_today_outlined,
                            size: Dimensions.r14.dynamicH,
                            color: context.textSecondary,
                          ),
                          SizedBox(width: Dimensions.r4.dynamicW),
                          Text(
                            '${AppUtils.formatDateShort(widget.spot.eventDateTime)}, ${AppUtils.formatTime(widget.spot.eventDateTime)}',
                            style: TextStyle(
                              fontSize: Dimensions.r12.dynamicSP,
                              color: context.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.r8.dynamicH),
                      Row(
                        children: [
                          Container(
                            width: Dimensions.r20.dynamicW,
                            height: Dimensions.r20.dynamicH,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColor.primaryColor.withValues(
                                alpha: 0.1,
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: widget.spot.hostProfile?.avatarUrl != null
                                ? AppCachedNetworkImage(
                                    imageUrl:
                                        widget.spot.hostProfile!.avatarUrl,
                                    fit: BoxFit.cover,
                                    memCacheWidth: 100,
                                    memCacheHeight: 100,
                                  )
                                : Icon(
                                    Icons.person,
                                    size: Dimensions.r14.dynamicH,
                                    color: AppColor.primaryColor,
                                  ),
                          ),
                          SizedBox(width: Dimensions.r6.dynamicW),
                          Expanded(
                            child: Text(
                              widget.spot.hostProfile?.fullName ??
                                  context.loc.verifiedHost,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
