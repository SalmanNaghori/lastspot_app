import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/features/spot/domain/entities/request_entity.dart';
import 'package:intl/intl.dart';
import 'spot_hero_image.dart';

class ActivityCard extends StatelessWidget {
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

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final localDt = dt.toLocal();
    if (now.year == localDt.year && now.month == localDt.month && now.day == localDt.day) {
      return 'Today';
    } else if (now.year == localDt.year && now.month == localDt.month && now.day == localDt.day - 1) {
      return 'Tomorrow';
    }
    return DateFormat('MMM d').format(localDt);
  }
  
  String _formatTime(DateTime dt) => DateFormat('h:mm a').format(dt.toLocal());

  String _getDisplayLocation(String location) {
    final lower = location.toLowerCase();
    if (lower.startsWith('http://') || lower.startsWith('https://')) {
      return 'Map Location';
    }
    return location;
  }

  @override
  Widget build(BuildContext context) {
    final spotsLeft = spot.maxParticipants - spot.currentParticipants;
    final isFull = spotsLeft <= 0;
    final spotsLeftText = isFull ? 'FULL' : '$spotsLeft spots left';

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: width, // Parent constraints will also work, but explicit width helps horizontal lists
        margin: EdgeInsets.only(
          bottom: Dimensions.r16.dynamicH,
        ),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
          border: Border.all(
            color: context.borderColor,
            width: 0.5,
          ),
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
            // Hero Image with price badge
            SpotHeroImage(
              spot: spot,
              isUrgent: false,
              spotsLeftText: '', // Hide spots left here, per user spec it goes below
              perPersonLabel: '/ person',
              heroTagPrefix: heroTagPrefix,
            ),
            
            Padding(
              padding: EdgeInsets.all(Dimensions.r16.dynamicW),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.r8.dynamicW,
                      vertical: Dimensions.r4.dynamicH,
                    ),
                    decoration: BoxDecoration(
                      color: context.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(Dimensions.r6.dynamicR),
                    ),
                    child: Text(
                      '$categoryIcon $categoryName',
                      style: TextStyle(
                        color: context.primaryColor,
                        fontSize: Dimensions.r12.dynamicSP,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.r12.dynamicH),
                  
                  // Title
                  Text(
                    spot.title.trim().isNotEmpty ? spot.title.trim() : _getDisplayLocation(spot.locationName),
                    style: TextStyle(
                      fontSize: Dimensions.r18.dynamicSP,
                      fontWeight: FontWeight.w800,
                      color: context.textPrimary,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: Dimensions.r12.dynamicH),
                  
                  // Date and Time
                  Text(
                    '📅 ${_formatDate(spot.eventDateTime)} • ${_formatTime(spot.eventDateTime)}',
                    style: TextStyle(
                      fontSize: Dimensions.r14.dynamicSP,
                      color: context.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: Dimensions.r8.dynamicH),
                  
                  // Location
                  Text(
                    '📍 ${_getDisplayLocation(spot.locationName)}',
                    style: TextStyle(
                      fontSize: Dimensions.r14.dynamicSP,
                      color: context.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: Dimensions.r12.dynamicH),
                  
                  // Spots Left
                  Text(
                    '👥 $spotsLeftText',
                    style: TextStyle(
                      fontSize: Dimensions.r14.dynamicSP,
                      color: isFull ? AppColor.errorColor : AppColor.successColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  
                  SizedBox(height: Dimensions.r16.dynamicH),
                  Divider(height: 1, color: context.borderColor),
                  SizedBox(height: Dimensions.r12.dynamicH),
                  
                  // Creator
                  Row(
                    children: [
                      ClipOval(
                        child: spot.hostProfile?.avatarUrl != null
                            ? AppCachedNetworkImage(
                                imageUrl: spot.hostProfile!.avatarUrl!,
                                width: Dimensions.r24.dynamicH,
                                height: Dimensions.r24.dynamicH,
                                fit: BoxFit.cover,
                                memCacheWidth: 100,
                                memCacheHeight: 100,
                              )
                            : Container(
                                width: Dimensions.r24.dynamicH,
                                height: Dimensions.r24.dynamicH,
                                color: context.primaryColor.withValues(alpha: 0.1),
                                child: Icon(
                                  Icons.person,
                                  size: Dimensions.r16.dynamicH,
                                  color: context.primaryColor,
                                ),
                              ),
                      ),
                      SizedBox(width: Dimensions.r8.dynamicW),
                      Expanded(
                        child: Text(
                          spot.hostProfile?.fullName ?? 'Host',
                          style: TextStyle(
                            fontSize: Dimensions.r14.dynamicSP,
                            color: context.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        'View →',
                        style: TextStyle(
                          fontSize: Dimensions.r13.dynamicSP,
                          color: context.primaryColor,
                          fontWeight: FontWeight.w700,
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
    );
  }
}
