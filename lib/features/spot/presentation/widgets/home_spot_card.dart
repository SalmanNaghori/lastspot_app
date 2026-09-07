import 'package:intl/intl.dart';
import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/features/spot/domain/entities/request_entity.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'spot_hero_image.dart';
import 'spot_host_avatar.dart';
import 'view_spot_button.dart';

/// Premium home-screen spot card matching the design:
/// - Full-bleed hero gradient with overlaid badges
/// - Location, title, date/players meta, notes, host row + View Spot CTA
class HomeSpotCard extends StatefulWidget {
  final RequestEntity spot;
  final VoidCallback onTap;
  final VoidCallback? onMapTap;

  const HomeSpotCard({super.key, required this.spot, required this.onTap, this.onMapTap});

  @override
  State<HomeSpotCard> createState() => _HomeSpotCardState();
}

class _HomeSpotCardState extends State<HomeSpotCard> {
  final ValueNotifier<bool> _isPressed = ValueNotifier(false);

  @override
  void dispose() {
    _isPressed.dispose();
    super.dispose();
  }

  String _formatDate(DateTime dt) => DateFormat('d MMM yyyy').format(dt);
  String _formatTime(DateTime dt) => DateFormat('h:mm a').format(dt);

  String _spotsLeftText(AppLocalizations loc) {
    if (widget.spot.currentParticipants == 1) return loc.oneSpotLeft;
    return loc.spotsLeft(widget.spot.currentParticipants);
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final isUrgent = widget.spot.eventDateTime.difference(DateTime.now()).inHours < 24;

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
          margin: EdgeInsets.only(bottom: Dimensions.r20.dynamicH),
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
            border: Border.all(color: context.borderColor, width: 1),
            boxShadow: [
              BoxShadow(color: AppColor.blackColor.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Hero image ──────────────────────────────────────
              SpotHeroImage(
                spot: widget.spot,
                isUrgent: isUrgent,
                spotsLeftText: _spotsLeftText(loc),
                perPersonLabel: loc.perPerson,
              ),

              // ── Location row ────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.r16.dynamicW, vertical: Dimensions.r8.dynamicH),
                child: Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: Dimensions.r14.dynamicH, color: context.textSecondary),
                    SizedBox(width: Dimensions.r4.dynamicW),
                    Expanded(
                      child: Text(
                        widget.spot.locationName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: Dimensions.r12.dynamicSP,
                          color: context.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Divider ─────────────────────────────────────────
              Divider(height: 1, color: context.borderColor),

              // ── Card body ────────────────────────────────────────
              Padding(
                padding: EdgeInsets.all(Dimensions.r16.dynamicW),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      widget.spot.title.trim().isNotEmpty ? widget.spot.title.trim() : widget.spot.locationName,
                      style: TextStyle(
                        fontSize: Dimensions.r16.dynamicSP,
                        fontWeight: FontWeight.w800,
                        color: context.textPrimary,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: Dimensions.r8.dynamicH),

                    // Date / Players meta row
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: Dimensions.r14.dynamicH,
                          color: context.textSecondary,
                        ),
                        SizedBox(width: Dimensions.r4.dynamicW),
                        Text(
                          '${_formatDate(widget.spot.eventDateTime)} • ${_formatTime(widget.spot.eventDateTime)}',
                          style: TextStyle(fontSize: Dimensions.r12.dynamicSP, color: context.textSecondary),
                        ),
                        SizedBox(width: Dimensions.r16.dynamicW),
                        Icon(Icons.people_outline, size: Dimensions.r14.dynamicH, color: context.textSecondary),
                        SizedBox(width: Dimensions.r4.dynamicW),
                        Text(
                          '${widget.spot.maxParticipants - widget.spot.currentParticipants}/${widget.spot.maxParticipants} players',
                          style: TextStyle(fontSize: Dimensions.r12.dynamicSP, color: context.textSecondary),
                        ),
                      ],
                    ),

                    // Notes / description
                    if (widget.spot.description != null && widget.spot.description!.isNotEmpty) ...[
                      SizedBox(height: Dimensions.r10.dynamicH),
                      Text(
                        widget.spot.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: Dimensions.r13.dynamicSP, color: context.textSecondary, height: 1.4),
                      ),
                    ],

                    SizedBox(height: Dimensions.r14.dynamicH),

                    // Host row + View Spot button
                    Row(
                      children: [
                        SpotHostAvatar(
                          name: widget.spot.hostProfile?.fullName ?? 'Host',
                          photoUrl: widget.spot.hostProfile?.avatarUrl,
                        ),
                        SizedBox(width: Dimensions.r8.dynamicW),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      widget.spot.hostProfile?.fullName ?? 'Host',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: Dimensions.r13.dynamicSP,
                                        fontWeight: FontWeight.w600,
                                        color: context.textPrimary,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: Dimensions.r4.dynamicW),
                                  Icon(Icons.verified, size: Dimensions.r14.dynamicH, color: context.primaryColor),
                                ],
                              ),
                              Text(
                                loc.verifiedHost,
                                style: TextStyle(fontSize: Dimensions.r11.dynamicSP, color: context.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        ViewSpotButton(onTap: widget.onTap, label: loc.viewSpot),
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

