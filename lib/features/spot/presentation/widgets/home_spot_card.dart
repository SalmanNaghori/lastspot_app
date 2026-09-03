import 'package:intl/intl.dart';
import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/features/spot/domain/entities/request_entity.dart';

/// Premium home-screen spot card matching the design:
/// - Full-bleed hero gradient with overlaid badges
/// - Location, title, date/players meta, notes, host row + View Spot CTA
class HomeSpotCard extends StatelessWidget {
  final RequestEntity spot;
  final VoidCallback onTap;
  final VoidCallback? onMapTap;

  const HomeSpotCard({
    super.key,
    required this.spot,
    required this.onTap,
    this.onMapTap,
  });

  String _formatDate(DateTime dt) => DateFormat('d MMM yyyy').format(dt);
  String _formatTime(DateTime dt) => DateFormat('h:mm a').format(dt);

  String _spotsLeftText(AppLocalizations loc) {
    if (spot.currentParticipants == 1) return loc.oneSpotLeft;
    return loc.spotsLeft(spot.currentParticipants);
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final isUrgent = spot.eventDateTime.difference(DateTime.now()).inHours < 24;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: Dimensions.r20.dynamicH),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
          border: Border.all(color: context.borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColor.blackColor.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero image ──────────────────────────────────────
            _HeroImage(
              spot: spot,
              isUrgent: isUrgent,
              spotsLeftText: _spotsLeftText(loc),
              perPersonLabel: loc.perPerson,
            ),

            // ── Location row ────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.r16.dynamicW,
                vertical: Dimensions.r8.dynamicH,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: Dimensions.r14.dynamicH,
                    color: context.textSecondary,
                  ),
                  SizedBox(width: Dimensions.r4.dynamicW),
                  Expanded(
                    child: Text(
                      spot.locationName,
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
                    spot.title.trim().isNotEmpty ? spot.title.trim() : spot.locationName,
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
                        '${_formatDate(spot.eventDateTime)} • ${_formatTime(spot.eventDateTime)}',
                        style: TextStyle(
                          fontSize: Dimensions.r12.dynamicSP,
                          color: context.textSecondary,
                        ),
                      ),
                      SizedBox(width: Dimensions.r16.dynamicW),
                      Icon(
                        Icons.people_outline,
                        size: Dimensions.r14.dynamicH,
                        color: context.textSecondary,
                      ),
                      SizedBox(width: Dimensions.r4.dynamicW),
                      Text(
                        '${spot.maxParticipants - spot.currentParticipants}/${spot.maxParticipants} players',
                        style: TextStyle(
                          fontSize: Dimensions.r12.dynamicSP,
                          color: context.textSecondary,
                        ),
                      ),
                    ],
                  ),

                  // Notes / description
                  if (spot.description != null &&
                      spot.description!.isNotEmpty) ...[
                    SizedBox(height: Dimensions.r10.dynamicH),
                    Text(
                      spot.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: Dimensions.r13.dynamicSP,
                        color: context.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],

                  SizedBox(height: Dimensions.r14.dynamicH),

                  // Host row + View Spot button
                  Row(
                    children: [
                      _HostAvatar(
                        name: spot.hostProfile?.fullName ?? 'Host',
                        photoUrl: spot.hostProfile?.avatarUrl,
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
                                    spot.hostProfile?.fullName ?? 'Host',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: Dimensions.r13.dynamicSP,
                                      fontWeight: FontWeight.w600,
                                      color: context.textPrimary,
                                    ),
                                  ),
                                ),
                                SizedBox(width: Dimensions.r4.dynamicW),
                                Icon(
                                  Icons.verified,
                                  size: Dimensions.r14.dynamicH,
                                  color: AppColor.primaryColor,
                                ),
                              ],
                            ),
                            Text(
                              loc.verifiedHost,
                              style: TextStyle(
                                fontSize: Dimensions.r11.dynamicSP,
                                color: context.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _ViewSpotButton(onTap: onTap, label: loc.viewSpot),
                    ],
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

// ─────────────────────────────────────────────────────────────────────────────

class _HeroImage extends StatelessWidget {
  final RequestEntity spot;
  final bool isUrgent;
  final String spotsLeftText;
  final String perPersonLabel;

  const _HeroImage({
    required this.spot,
    required this.isUrgent,
    required this.spotsLeftText,
    required this.perPersonLabel,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(Dimensions.r16.dynamicR),
        topRight: Radius.circular(Dimensions.r16.dynamicR),
      ),
      child: SizedBox(
        height: Dimensions.r64.dynamicH * 2.8,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Hero image or gradient background
            if (spot.images.isNotEmpty)
              AppCachedNetworkImage(
                imageUrl: spot.images.first.storagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorWidget:
                    _SportGradientBackground(categoryId: spot.categoryId),
              )
            else
              _SportGradientBackground(categoryId: spot.categoryId),

            // Gradient scrim
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColor.blackColor.withValues(alpha: 0.15),
                    AppColor.blackColor.withValues(alpha: 0.45),
                  ],
                ),
              ),
            ),

            // Top badges
            Positioned(
              top: Dimensions.r12.dynamicH,
              left: Dimensions.r12.dynamicW,
              right: Dimensions.r12.dynamicW,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Spots Left badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.r10.dynamicW,
                      vertical: Dimensions.r5.dynamicH,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.primaryColor,
                      borderRadius: BorderRadius.circular(
                        Dimensions.r8.dynamicR,
                      ),
                    ),
                    child: Text(
                      spotsLeftText,
                      style: TextStyle(
                        color: AppColor.whiteColor,
                        fontSize: Dimensions.r11.dynamicSP,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  // Price badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.r10.dynamicW,
                      vertical: Dimensions.r5.dynamicH,
                    ),
                    decoration: BoxDecoration(
                      color: context.surfaceColor.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(
                        Dimensions.r8.dynamicR,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          spot.pricePerPerson > 0
                              ? '₹${spot.pricePerPerson.toStringAsFixed(spot.pricePerPerson.truncateToDouble() == spot.pricePerPerson ? 0 : 2)}'
                              : 'FREE',
                          style: TextStyle(
                            color: AppColor.primaryColor,
                            fontSize: Dimensions.r12.dynamicSP,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          perPersonLabel,
                          style: TextStyle(
                            color: AppColor.textSecondaryLight,
                            fontSize: Dimensions.r9.dynamicSP,
                          ),
                        ),
                      ],
                    ),
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

class _SportGradientBackground extends StatelessWidget {
  final String categoryId;

  const _SportGradientBackground({required this.categoryId});

  (Color, Color, IconData) get _style {
    switch (categoryId.toLowerCase()) {
      case 'cricket':
        return (
          const Color(0xFF064E3B),
          const Color(0xFF10B981),
          Icons.sports_cricket,
        );
      case 'football':
        return (
          const Color(0xFF1E3A8A),
          const Color(0xFF3B82F6),
          Icons.sports_soccer,
        );
      case 'basketball':
        return (
          const Color(0xFF7C2D12),
          const Color(0xFFF97316),
          Icons.sports_basketball,
        );
      case 'tennis':
        return (
          const Color(0xFF4C1D95),
          const Color(0xFF8B5CF6),
          Icons.sports_tennis,
        );
      case 'badminton':
        return (
          const Color(0xFF713F12),
          const Color(0xFFF59E0B),
          Icons.sports_tennis,
        );
      default:
        return (const Color(0xFF0F172A), const Color(0xFF334155), Icons.sports);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (darkColor, lightColor, icon) = _style;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [darkColor, lightColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          size: Dimensions.r64.dynamicH * 1.25,
          color: AppColor.whiteColor.withValues(alpha: 0.12),
        ),
      ),
    );
  }
}

class _HostAvatar extends StatelessWidget {
  final String name;
  final String? photoUrl;

  const _HostAvatar({required this.name, this.photoUrl});

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoUrl != null && photoUrl!.trim().isNotEmpty;

    return CircleAvatar(
      radius: Dimensions.r20.dynamicR,
      backgroundColor: AppColor.primaryColor,
      child: hasPhoto
          ? AppCachedNetworkImage(
              imageUrl: photoUrl!.replaceAll('/svg?', '/png?'),
              isCircle: true,
              width: Dimensions.r20.dynamicR * 2,
              height: Dimensions.r20.dynamicR * 2,
              errorWidget: Center(
                child: Text(
                  _initials,
                  style: TextStyle(
                    color: AppColor.whiteColor,
                    fontSize: Dimensions.r13.dynamicSP,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          : Text(
              _initials,
              style: TextStyle(
                color: AppColor.whiteColor,
                fontSize: Dimensions.r13.dynamicSP,
                fontWeight: FontWeight.w700,
              ),
            ),
    );
  }
}

class _ViewSpotButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;

  const _ViewSpotButton({required this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.r16.dynamicW,
          vertical: Dimensions.r10.dynamicH,
        ),
        decoration: BoxDecoration(
          color: AppColor.primaryColor,
          borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
          boxShadow: [
            BoxShadow(
              color: AppColor.primaryColor.withValues(alpha: 0.35),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: AppColor.whiteColor,
                fontSize: Dimensions.r13.dynamicSP,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: Dimensions.r4.dynamicW),
            Icon(
              Icons.arrow_forward,
              color: AppColor.whiteColor,
              size: Dimensions.r14.dynamicH,
            ),
          ],
        ),
      ),
    );
  }
}
