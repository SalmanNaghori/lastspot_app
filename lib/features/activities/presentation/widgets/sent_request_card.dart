import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/core/constants/date_formats.dart';
import '../../../spot/domain/entities/join_request_entity.dart';
import '../bloc/activities_bloc.dart';
import '../bloc/activities_event.dart';

class SentRequestCard extends StatelessWidget {
  final JoinRequestEntity request;

  const SentRequestCard({
    super.key,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = AppConstants.getStatusColor(context, request.status);
    final statusText = request.status.toString().split('.').last.capitalizeFirst();
    final spot = request.request; // The activity requested to join

    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
        border: Border.all(color: context.dividerColor.withValues(alpha: 0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Status and Requested Date
          Padding(
            padding: EdgeInsets.fromLTRB(
              Dimensions.r16.dynamicW,
              Dimensions.r16.dynamicH,
              Dimensions.r16.dynamicW,
              Dimensions.r12.dynamicH,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.r10.dynamicW,
                    vertical: Dimensions.r4.dynamicH,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Dimensions.r999.dynamicR), // Pill shape
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: Dimensions.r12.dynamicSP,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Text(
                  'Sent ${formatDate(request.createdAt, DateFormats.dateFormatWithDateAndTime)}',
                  style: TextStyle(
                    fontSize: Dimensions.r12.dynamicSP,
                    color: context.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          
          Divider(height: 1, color: context.dividerColor.withValues(alpha: 0.3)),

          // Body: Activity Context
          Padding(
            padding: EdgeInsets.all(Dimensions.r16.dynamicW),
            child: spot != null
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Host Avatar
                      Container(
                        width: Dimensions.r48.dynamicW,
                        height: Dimensions.r48.dynamicH,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: context.primaryColor.withValues(alpha: 0.1),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: spot.hostProfile?.avatarUrl != null
                            ? AppCachedNetworkImage(
                                imageUrl: spot.hostProfile!.avatarUrl,
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.person, color: context.primaryColor),
                      ),
                      SizedBox(width: Dimensions.r16.dynamicW),
                      // Activity Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              spot.title.isNotEmpty ? spot.title.capitalizeFirst() : 'Activity',
                              style: TextStyle(
                                fontSize: Dimensions.r16.dynamicSP,
                                fontWeight: FontWeight.w700,
                                color: context.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
                                    AppConstants.formatActivityDate(spot.eventDateTime),
                                    style: TextStyle(
                                      fontSize: Dimensions.r13.dynamicSP,
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
                  )
                : Text(
                    'Activity details unavailable',
                    style: TextStyle(color: context.textSecondary, fontStyle: FontStyle.italic),
                  ),
          ),

          // Footer: Actions
          if (request.status == JoinRequestStatus.pending || request.status == JoinRequestStatus.accepted) ...[
            Divider(height: 1, color: context.dividerColor.withValues(alpha: 0.3)),
            Padding(
              padding: EdgeInsets.all(Dimensions.r16.dynamicW),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    context.read<ActivitiesBloc>().add(CancelJoinRequestEvent(request.id));
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: context.errorColor,
                    side: BorderSide(color: context.errorColor.withValues(alpha: 0.5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.r999.dynamicR),
                    ),
                    padding: EdgeInsets.symmetric(vertical: Dimensions.r12.dynamicH),
                  ),
                  child: Text(context.loc.cancel, style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
