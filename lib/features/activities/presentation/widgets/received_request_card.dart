import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/core/constants/date_formats.dart';
import '../../../spot/domain/entities/join_request_entity.dart';
import '../bloc/activities_bloc.dart';
import '../bloc/activities_event.dart';

class ReceivedRequestCard extends StatelessWidget {
  final JoinRequestEntity request;

  const ReceivedRequestCard({
    super.key,
    required this.request,
  });

  @override
  Widget build(BuildContext context) {
    final profile = request.userProfile;
    final profileName = profile?.fullName ?? 'Unknown User';
    final avatar = profile?.avatarUrl;
    final rating = profile?.rating ?? 0.0;

    return Card(
      elevation: 0,
      color: context.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
        side: BorderSide(color: context.dividerColor, width: 0.5),
      ),
      child: Padding(
        padding: EdgeInsets.all(Dimensions.r16.dynamicW),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                avatar != null
                    ? AppCachedNetworkImage(
                        imageUrl: avatar,
                        width: Dimensions.rad40, // 2 * radius
                        height: Dimensions.rad40,
                        isCircle: true,
                        errorWidget: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                      )
                    : CircleAvatar(
                        radius: Dimensions.r20.dynamicR,
                        child: const Icon(Icons.person),
                      ),
                SizedBox(width: Dimensions.r12.dynamicW),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profileName,
                        style: context.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: Dimensions.r12.dynamicH,
                            color: context.warningColor,
                          ),
                          SizedBox(width: Dimensions.r4.dynamicW),
                          Text(
                            rating.toStringAsFixed(1),
                            style: context.bodySmall?.copyWith(
                              color: context.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  formatDate(request.createdAt, DateFormats.dateFormatWithDateAndTime),
                  style: context.bodySmall?.copyWith(
                    color: context.textSecondary,
                  ),
                ),
              ],
            ),
            if (request.message != null && request.message!.isNotEmpty) ...[
              SizedBox(height: Dimensions.r12.dynamicH),
              Container(
                padding: EdgeInsets.all(Dimensions.r8.dynamicW),
                decoration: BoxDecoration(
                  color: context.backgroundColor,
                  borderRadius: BorderRadius.circular(Dimensions.r8.dynamicR),
                ),
                child: Text(
                  request.message!,
                  style: context.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
            SizedBox(height: Dimensions.r16.dynamicH),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.read<ActivitiesBloc>().add(
                        RejectJoinRequestEvent(request.id),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: context.errorColor,
                      side: BorderSide(color: context.errorColor),
                    ),
                    child: Text(context.loc.reject),
                  ),
                ),
                SizedBox(width: Dimensions.r12.dynamicW),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      context.read<ActivitiesBloc>().add(
                        AcceptJoinRequestEvent(request.id),
                      );
                    },
                    child: Text(context.loc.accept),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
