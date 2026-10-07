import 'package:lastspot_app/core/base_import.dart';

import '../../../spot/domain/entities/join_request_entity.dart';
import '../bloc/activities_bloc.dart';
import '../bloc/activities_event.dart';

class ReceivedRequestCard extends StatelessWidget {
  final JoinRequestEntity request;

  const ReceivedRequestCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final profile = request.userProfile;
    final profileName = profile?.fullName ?? 'Unknown User';
    final avatar = profile?.avatarUrl;
    final rating = profile?.rating ?? 0.0;
    final spot = request.request; // The activity they want to join

    return Container(
      decoration: BoxDecoration(
        color: context.surfaceColor,
        borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
        border: Border.all(color: context.dividerColor.withValues(alpha: 0.5), width: 1),
        boxShadow: [
          BoxShadow(color: AppColor.blackColor.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Activity Context
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
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.event_note, size: Dimensions.r16.dynamicH, color: context.primaryColor),
                      SizedBox(width: Dimensions.r6.dynamicW),
                      Expanded(
                        child: Text(
                          spot?.title?.capitalizeFirst() ?? 'Activity',
                          style: TextStyle(
                            fontSize: Dimensions.r14.dynamicSP,
                            fontWeight: FontWeight.w600,
                            color: context.primaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: Dimensions.r8.dynamicW),
                Text(
                  AppUtils.timeAgo(request.createdAt),
                  style: TextStyle(fontSize: Dimensions.r12.dynamicSP, color: context.textSecondary),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: context.dividerColor.withValues(alpha: 0.3)),

          // Body: User Profile & Message
          Padding(
            padding: EdgeInsets.all(Dimensions.r16.dynamicW),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: Dimensions.r48.dynamicW,
                      height: Dimensions.r48.dynamicH,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: context.primaryColor.withValues(alpha: 0.1),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: avatar != null
                          ? AppCachedNetworkImage(imageUrl: avatar, fit: BoxFit.cover)
                          : Icon(Icons.person, color: context.primaryColor),
                    ),
                    SizedBox(width: Dimensions.r12.dynamicW),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profileName,
                            style: TextStyle(
                              fontSize: Dimensions.r16.dynamicSP,
                              fontWeight: FontWeight.w700,
                              color: context.textPrimary,
                            ),
                          ),
                          SizedBox(height: Dimensions.r4.dynamicH),
                          Row(
                            children: [
                              Icon(Icons.star, size: Dimensions.r14.dynamicH, color: context.warningColor),
                              SizedBox(width: Dimensions.r4.dynamicW),
                              Text(
                                rating.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: Dimensions.r13.dynamicSP,
                                  color: context.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (request.message != null && request.message!.isNotEmpty) ...[
                  SizedBox(height: Dimensions.r16.dynamicH),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(Dimensions.r12.dynamicW),
                    decoration: BoxDecoration(
                      color: context.backgroundColor,
                      borderRadius: BorderRadius.circular(Dimensions.r8.dynamicR),
                      border: Border.all(color: context.dividerColor.withValues(alpha: 0.3), width: 1),
                    ),
                    child: Text(
                      '"${request.message!}"',
                      style: TextStyle(
                        fontSize: Dimensions.r13.dynamicSP,
                        fontStyle: FontStyle.italic,
                        color: context.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Footer: Actions
          if (request.status == JoinRequestStatus.pending) ...[
            Divider(height: 1, color: context.dividerColor.withValues(alpha: 0.3)),
            Padding(
              padding: EdgeInsets.all(Dimensions.r16.dynamicW),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        context.read<ActivitiesBloc>().add(RejectJoinRequestEvent(request.id));
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.errorColor,
                        side: BorderSide(color: context.errorColor.withValues(alpha: 0.5)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.r999.dynamicR)),
                        padding: EdgeInsets.symmetric(vertical: Dimensions.r12.dynamicH),
                      ),
                      child: Text(context.loc.reject, style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  SizedBox(width: Dimensions.r12.dynamicW),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        context.read<ActivitiesBloc>().add(AcceptJoinRequestEvent(request.id));
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: context.primaryColor,
                        foregroundColor: AppColor.whiteColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.r999.dynamicR)),
                        padding: EdgeInsets.symmetric(vertical: Dimensions.r12.dynamicH),
                      ),
                      child: Text(context.loc.accept, style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
