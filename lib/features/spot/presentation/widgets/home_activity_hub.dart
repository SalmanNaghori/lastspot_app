import 'package:intl/intl.dart';
import 'package:lastspot_app/core/base_import.dart';

import '../../domain/entities/request_entity.dart';
import '../bloc/home_state.dart';

class HomeActivityHub extends StatelessWidget {
  final HomeSuccess state;
  final ValueChanged<String> onReviewRequests;
  final ValueChanged<RequestEntity> onViewActivity;
  final ValueChanged<RequestEntity> onManageActivity;
  final ValueChanged<RequestEntity> onOpenGroupChat;
  final VoidCallback onCreateActivity;
  final VoidCallback onRetry;

  const HomeActivityHub({
    super.key,
    required this.state,
    required this.onReviewRequests,
    required this.onViewActivity,
    required this.onManageActivity,
    required this.onOpenGroupChat,
    required this.onCreateActivity,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final isDark = context.isDarkMode;
    final requests = state.pendingJoinRequests;
    final joined = state.upcomingJoinedActivity;
    final hosted = state.upcomingHostedActivity;
    final recommendation = state.recommendation;

    // Sports design palette
    final hubAccent = context.primaryColor;
    final hubSurface = isDark
        ? context.surfaceContainer
        : AppColor.surfaceContainerLight;
    final hubBorder = isDark
        ? context.borderColor.withValues(alpha: 0.6)
        : AppColor.cardBorderLight;
    final hubBadgeBg = isDark
        ? context.primaryColor.withValues(alpha: 0.15)
        : AppColor.successContainerLight;

    late final String message;
    late final IconData icon;
    String? badgeText;
    String? activityTitle;
    String? eventTime;
    String primaryLabel;
    VoidCallback primaryAction;
    String? secondaryLabel;
    VoidCallback? secondaryAction;

    if (state.hasActivityHubError) {
      message = loc.homeActivityHubError;
      icon = Icons.sync_problem_outlined;
      primaryLabel = loc.retry;
      primaryAction = onRetry;
    } else if (requests.isNotEmpty) {
      final request = requests.first;
      activityTitle = request.request?.title ?? 'Activity';
      badgeText = requests.length == 1
          ? '1 request needs attention'
          : '${requests.length} requests need attention';
      message = loc.homeActivityHubPending(requests.length);
      icon = Icons.mark_email_unread_outlined;
      primaryLabel = loc.homeReviewRequests;
      primaryAction = () => onReviewRequests(request.requestId);
    } else if (joined != null) {
      activityTitle = joined.title;
      badgeText = 'Joined activity';
      message = loc.homeActivityHubJoined;
      eventTime = _formatEventTime(joined.eventDateTime);
      icon = Icons.event_available_outlined;
      primaryLabel = loc.homeViewActivity;
      primaryAction = () => onViewActivity(joined);
      if (state.canOpenJoinedGroupChat) {
        secondaryLabel = loc.homeGroupChat;
        secondaryAction = () => onOpenGroupChat(joined);
      }
    } else if (hosted != null) {
      activityTitle = hosted.title;
      badgeText = 'Hosting match';
      message = loc.homeActivityHubHosted;
      eventTime = _formatEventTime(hosted.eventDateTime);
      icon = Icons.sports_outlined;
      primaryLabel = loc.homeManageActivity;
      primaryAction = () => onManageActivity(hosted);
    } else {
      activityTitle = recommendation?.title;
      eventTime = recommendation == null
          ? null
          : _formatEventTime(recommendation.eventDateTime);
      badgeText = recommendation != null ? 'Suggested for you' : null;
      message = recommendation == null
          ? loc.homeActivityHubEmpty
          : loc.homeActivityHubRecommendation;
      icon = Icons.event_note_outlined;
      primaryLabel = loc.homeCreateActivity;
      primaryAction = onCreateActivity;
      if (recommendation != null) {
        secondaryLabel = loc.homeViewActivity;
        secondaryAction = () => onViewActivity(recommendation);
      }
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.r16.dynamicW),
      child: Container(
        decoration: BoxDecoration(
          color: hubSurface,
          borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
          border: Border.all(color: hubBorder, width: 1.2),
        ),
        padding: EdgeInsets.all(Dimensions.r14.dynamicH),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Section: Category Label + Badge
            Row(
              children: [
                Expanded(
                  child: Text(
                    loc.yourActivityHub,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: Dimensions.r11.dynamicSP,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: hubAccent,
                    ),
                  ),
                ),
                if (badgeText != null) ...[
                  SizedBox(width: Dimensions.r8.dynamicW),
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.r8.dynamicW,
                        vertical: Dimensions.r2.dynamicH,
                      ),
                      decoration: BoxDecoration(
                        color: hubBadgeBg,
                        borderRadius: BorderRadius.circular(
                          Dimensions.r12.dynamicR,
                        ),
                      ),
                      child: Text(
                        badgeText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: Dimensions.r11.dynamicSP,
                          fontWeight: FontWeight.w700,
                          color: hubAccent,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: Dimensions.r10.dynamicH),

            // Content Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: primaryAction,
                  child: Container(
                    width: Dimensions.r48.dynamicH,
                    height: Dimensions.r48.dynamicH,
                    decoration: BoxDecoration(
                      color: hubAccent.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: requests.isNotEmpty
                          ? Assets.icons.joinRequest3d.image(
                              width: Dimensions.r36.dynamicW,
                              height: Dimensions.r36.dynamicH,
                              fit: BoxFit.contain,
                              cacheWidth: 160,
                              cacheHeight: 160,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                    icon,
                                    size: Dimensions.r20.dynamicH,
                                    color: hubAccent,
                                  ),
                            )
                          : joined != null
                          ? Category3DIcon(
                              category: joined.categoryId,
                              size: Dimensions.r32.dynamicH,
                            )
                          : hosted != null
                          ? Category3DIcon(
                              category: hosted.categoryId,
                              size: Dimensions.r32.dynamicH,
                            )
                          : recommendation != null
                          ? Category3DIcon(
                              category: recommendation.categoryId,
                              size: Dimensions.r32.dynamicH,
                            )
                          : !state.hasActivityHubError
                          ? Assets.images.onboarding.welcomeSportsCollection
                                .image(
                                  width: Dimensions.r32.dynamicW,
                                  height: Dimensions.r32.dynamicH,
                                  fit: BoxFit.contain,
                                  cacheWidth: 160,
                                  cacheHeight: 160,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(
                                        icon,
                                        size: Dimensions.r20.dynamicH,
                                        color: hubAccent,
                                      ),
                                )
                          : Icon(
                              icon,
                              size: Dimensions.r20.dynamicH,
                              color: hubAccent,
                            ),
                    ),
                  ),
                ),
                SizedBox(width: Dimensions.r12.dynamicW),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (activityTitle != null) ...[
                        Text(
                          activityTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: Dimensions.r15.dynamicSP,
                            fontWeight: FontWeight.w700,
                            color: context.textPrimary,
                          ),
                        ),
                        SizedBox(height: Dimensions.r2.dynamicH),
                      ],
                      if (eventTime != null) ...[
                        Text(
                          eventTime,
                          style: TextStyle(
                            fontSize: Dimensions.r12.dynamicSP,
                            color: context.textSecondary,
                          ),
                        ),
                        SizedBox(height: Dimensions.r2.dynamicH),
                      ],
                      Text(
                        message,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: Dimensions.r12.dynamicSP,
                          color: context.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.r12.dynamicH),

            // Action Buttons
            Wrap(
              spacing: Dimensions.r8.dynamicW,
              runSpacing: Dimensions.r8.dynamicH,
              children: [
                FilledButton(
                  onPressed: primaryAction,
                  style: FilledButton.styleFrom(
                    backgroundColor: hubAccent,
                    foregroundColor: AppColor.whiteColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.r14.dynamicW,
                      vertical: Dimensions.r6.dynamicH,
                    ),
                    minimumSize: Size(0, Dimensions.r32.dynamicH),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        Dimensions.r8.dynamicR,
                      ),
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        primaryLabel,
                        style: TextStyle(
                          fontSize: Dimensions.r12.dynamicSP,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: Dimensions.r4.dynamicW),
                      Icon(Icons.arrow_forward, size: Dimensions.r14.dynamicH),
                    ],
                  ),
                ),
                if (secondaryLabel != null && secondaryAction != null)
                  OutlinedButton(
                    onPressed: secondaryAction,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.r12.dynamicW,
                        vertical: Dimensions.r6.dynamicH,
                      ),
                      minimumSize: Size(0, Dimensions.r32.dynamicH),
                      visualDensity: VisualDensity.compact,
                      side: BorderSide(color: hubBorder),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          Dimensions.r8.dynamicR,
                        ),
                      ),
                    ),
                    child: Text(
                      secondaryLabel,
                      style: TextStyle(
                        fontSize: Dimensions.r12.dynamicSP,
                        fontWeight: FontWeight.w600,
                        color: hubAccent,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatEventTime(DateTime value) =>
      DateFormat.yMMMd().add_jm().format(value.toLocal());
}
