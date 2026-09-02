import 'package:flutter/material.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/dimensions.dart';
import '../../domain/entities/spot_entity.dart';
import 'package:lastspot_app/core/l10n/app_localizations.dart';

class PostCard extends StatelessWidget {
  final SpotEntity post;
  final VoidCallback onTap;
  final VoidCallback onMapTap;

  const PostCard({
    super.key,
    required this.post,
    required this.onTap,
    required this.onMapTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isUrgent = post.matchTime.difference(DateTime.now()).inHours < 24;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: Dimensions.r16.dynamicH),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
          border: Border.all(
            color: context.borderColor,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.blackColor.withValues(alpha: 0.04),
              blurRadius: Dimensions.r12.dynamicR,
              offset: const Offset(0, 4),
            )
          ],
        ),
        padding: EdgeInsets.all(Dimensions.r16.dynamicW),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${post.sportCategory} - ${post.venueName}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.textPrimary,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.r8.dynamicW,
                    vertical: Dimensions.r4.dynamicH,
                  ),
                  decoration: BoxDecoration(
                    color: isUrgent 
                        ? AppColor.errorColor.withValues(alpha: 0.1)
                        : AppColor.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Dimensions.r8.dynamicR),
                  ),
                  child: Text(
                    post.neededSpots == 1 
                        ? l10n.spotNeeded(post.neededSpots) 
                        : l10n.spotsNeeded(post.neededSpots),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isUrgent ? AppColor.errorColor : AppColor.primaryColor,
                        ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.r8.dynamicH),
            Row(
              children: [
                Icon(Icons.calendar_today, size: Dimensions.r16.dynamicH, color: context.textSecondary),
                SizedBox(width: Dimensions.r8.dynamicW),
                Text(
                  '${post.matchTime.day}/${post.matchTime.month}/${post.matchTime.year} • ${post.matchTime.hour}:${post.matchTime.minute.toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: context.textSecondary,
                      ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.r4.dynamicH),
            if (post.hostProfile != null)
              Row(
                children: [
                  Icon(Icons.person, size: Dimensions.r16.dynamicH, color: context.textSecondary),
                  SizedBox(width: Dimensions.r8.dynamicW),
                  Text(
                    l10n.hostPrefix(post.hostProfile!.fullName ?? 'Anonymous'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: context.textSecondary,
                        ),
                  ),
                ],
              ),
            SizedBox(height: Dimensions.r16.dynamicH),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: onMapTap,
                  icon: Icon(Icons.map, size: Dimensions.r16.dynamicH, color: AppColor.primaryColor),
                  label: Text(
                    l10n.openGroundMap,
                    style: TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.surfaceColor,
                    foregroundColor: AppColor.primaryColor,
                    elevation: 0,
                    side: BorderSide(color: AppColor.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.r8.dynamicR),
                    ),
                  ),
                  child: Text(l10n.viewSpot),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
