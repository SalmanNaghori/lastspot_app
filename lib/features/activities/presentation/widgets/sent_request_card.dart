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

  Color _getStatusColor(BuildContext context, JoinRequestStatus status) {
    switch (status) {
      case JoinRequestStatus.pending:
        return context.warningColor;
      case JoinRequestStatus.accepted:
        return context.successColor;
      case JoinRequestStatus.rejected:
      case JoinRequestStatus.cancelled:
        return context.errorColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(context, request.status);
    final statusText = request.status.toString().split('.').last.toUpperCase();

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatDate(request.createdAt, DateFormats.dateFormatWithDateAndTime),
                  style: context.bodySmall?.copyWith(
                    color: context.textSecondary,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.r8.dynamicW,
                    vertical: Dimensions.r4.dynamicH,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(Dimensions.r4.dynamicR),
                  ),
                  child: Text(
                    statusText,
                    style: context.labelSmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.r16.dynamicH),
            if (request.status == JoinRequestStatus.pending ||
                request.status == JoinRequestStatus.accepted)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    context.read<ActivitiesBloc>().add(
                      CancelJoinRequestEvent(request.id),
                    );
                  },
                  child: Text(context.loc.cancel),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
