import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/core/constants/date_formats.dart';
import 'package:lastspot_app/features/spot/domain/entities/request_entity.dart';

import 'spot_hero_image.dart';
import 'spot_host_avatar.dart';

class ActivityCard extends StatefulWidget {
  final RequestEntity spot;
  final String categoryName;
  final String categoryIcon;
  final String? heroTagPrefix;
  final VoidCallback onTap;
  final double? width;

  const ActivityCard({
    super.key,
    required this.spot,
    required this.categoryName,
    required this.categoryIcon,
    this.heroTagPrefix,
    required this.onTap,
    this.width,
  });

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  final ValueNotifier<bool> _isPressed = ValueNotifier(false);
  bool _isTapped = false;

  void _handleTap() {
    if (_isTapped) return;
    _isTapped = true;
    widget.onTap();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _isTapped = false;
    });
  }

  @override
  void dispose() {
    _isPressed.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final spotsLeft = widget.spot.maxParticipants - widget.spot.currentParticipants;
    final isFull = spotsLeft <= 0;

    // Logic for spots left badge on image
    String spotsLeftBadge = '';
    if (isFull) {
      spotsLeftBadge = AppString.full;
    } else if (spotsLeft == 1) {
      spotsLeftBadge = loc.oneSpotLeft;
    } else {
      spotsLeftBadge = loc.spotsLeft(spotsLeft);
    }

    return GestureDetector(
      onTapDown: (_) => _isPressed.value = true,
      onTapUp: (_) => _isPressed.value = false,
      onTapCancel: () => _isPressed.value = false,
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: ValueListenableBuilder<bool>(
        valueListenable: _isPressed,
        builder: (context, isPressed, child) => AnimatedScale(
          scale: isPressed ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          child: child,
        ),
        child: Container(
          width: widget.width,
          margin: EdgeInsets.only(bottom: Dimensions.r16.dynamicH),
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
            border: Border.all(color: context.borderColor, width: 0.5),
            boxShadow: [
              BoxShadow(
                color: AppColor.blackColor.withValues(alpha: 0.04),
                blurRadius: Dimensions.r12.dynamicR,
                offset: Offset(0, Dimensions.r4.dynamicH),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Hero Image with badges
              SpotHeroImage(
                spot: widget.spot,
                isUrgent: false,
                spotsLeftText: spotsLeftBadge,
                perPersonLabel: loc.perPerson,
                heroTagPrefix: widget.heroTagPrefix,
              ),

              Padding(
                padding: EdgeInsets.all(Dimensions.r16.dynamicW),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.r10.dynamicW,
                        vertical: Dimensions.r6.dynamicH,
                      ),
                      decoration: BoxDecoration(
                        color: context.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
                      ),
                      child: Text(
                        '${widget.categoryIcon} ${widget.categoryName}',
                        style: TextStyle(
                          color: context.primaryColor,
                          fontSize: Dimensions.r13.dynamicSP,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.r12.dynamicH),

                    // Title
                    Text(
                      widget.spot.title.trim().isNotEmpty
                          ? widget.spot.title.trim()
                          : AppUtils.getDisplayLocation(context, widget.spot.locationName),
                      style: TextStyle(
                        fontSize: Dimensions.r18.dynamicSP,
                        fontWeight: FontWeight.w800,
                        color: context.textPrimary,
                        height: 1.2,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: Dimensions.r12.dynamicH),

                    // Date / Time / Players row
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: Dimensions.r14.dynamicH,
                          color: context.textSecondary,
                        ),
                        SizedBox(width: Dimensions.r6.dynamicW),
                        Text(
                          '${AppConstants.formatActivityDate(widget.spot.eventDateTime)} • ${AppUtils.formatTime(widget.spot.eventDateTime)}',
                          style: TextStyle(
                            fontSize: Dimensions.r13.dynamicSP,
                            color: context.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: Dimensions.r16.dynamicW),
                        Icon(Icons.people_outline, size: Dimensions.r14.dynamicH, color: context.textSecondary),
                        SizedBox(width: Dimensions.r4.dynamicW),
                        Text(
                          '${widget.spot.maxParticipants - spotsLeft} ${AppString.ofText} ${widget.spot.maxParticipants} ${AppString.spots}',
                          style: TextStyle(
                            fontSize: Dimensions.r13.dynamicSP,
                            color: context.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.r8.dynamicH),

                    // Location
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on_outlined, size: Dimensions.r14.dynamicH, color: context.textSecondary),
                        SizedBox(width: Dimensions.r6.dynamicW),
                        Expanded(
                          child: Text(
                            AppUtils.getDisplayLocation(context, widget.spot.locationName),
                            style: TextStyle(
                              fontSize: Dimensions.r13.dynamicSP,
                              color: context.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    // Description Snippet
                    if (widget.spot.description != null && widget.spot.description!.isNotEmpty) ...[
                      SizedBox(height: Dimensions.r12.dynamicH),
                      Text(
                        widget.spot.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: Dimensions.r13.dynamicSP, color: context.textSecondary, height: 1.4),
                      ),
                    ],

                    SizedBox(height: Dimensions.r16.dynamicH),
                    Divider(height: 1, color: context.borderColor),
                    SizedBox(height: Dimensions.r12.dynamicH),

                    // Host row + View button
                    Row(
                      children: [
                        SpotHostAvatar(
                          name: widget.spot.hostProfile?.fullName ?? AppString.host,
                          photoUrl: widget.spot.hostProfile?.avatarUrl,
                        ),
                        SizedBox(width: Dimensions.r10.dynamicW),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      widget.spot.hostProfile?.fullName ?? AppString.host,
                                      style: TextStyle(
                                        fontSize: Dimensions.r14.dynamicSP,
                                        color: context.textPrimary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: Dimensions.r2.dynamicH),
                              Text(
                                AppString.host,
                                style: TextStyle(fontSize: Dimensions.r12.dynamicSP, color: context.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.r16.dynamicW,
                            vertical: Dimensions.r10.dynamicH,
                          ),
                          decoration: BoxDecoration(
                            color: context.primaryColor,
                            borderRadius: BorderRadius.circular(Dimensions.r24.dynamicR),
                            boxShadow: [
                              BoxShadow(
                                color: context.primaryColor.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            loc.viewSpot,
                            style: TextStyle(
                              fontSize: Dimensions.r14.dynamicSP,
                              color: AppColor.whiteColor,
                              fontWeight: FontWeight.w600,
                            ),
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
