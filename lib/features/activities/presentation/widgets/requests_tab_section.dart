import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lastspot_app/core/base_import.dart';
import '../../../spot/domain/entities/join_request_entity.dart';
import 'package:intl/intl.dart';
import '../bloc/activities_bloc.dart';
import '../bloc/activities_event.dart';

class RequestsTabSection extends StatefulWidget {
  final List<JoinRequestEntity> receivedRequests;
  final List<JoinRequestEntity> sentRequests;
  final double horizontalPadding;

  const RequestsTabSection({
    super.key,
    required this.receivedRequests,
    required this.sentRequests,
    this.horizontalPadding = 0.0,
  });

  @override
  State<RequestsTabSection> createState() => _RequestsTabSectionState();
}

class _RequestsTabSectionState extends State<RequestsTabSection> {
  String _selectedSegment = 'received';

  @override
  Widget build(BuildContext context) {
    final isReceived = _selectedSegment == 'received';
    final items = isReceived ? widget.receivedRequests : widget.sentRequests;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'received', label: Text('Received')),
              ButtonSegment(value: 'sent', label: Text('Sent')),
            ],
            selected: {_selectedSegment},
            onSelectionChanged: (Set<String> newSelection) {
              setState(() {
                _selectedSegment = newSelection.first;
              });
            },
          ),
          SizedBox(height: Dimensions.r16.dynamicH),
          if (items.isEmpty)
            Padding(
              padding: EdgeInsets.only(top: Dimensions.r32.dynamicH),
              child: Center(
                child: Text(
                  isReceived
                      ? 'No pending requests received.'
                      : 'No sent requests.',
                  style: context.bodyMedium?.copyWith(
                    color: context.textSecondary,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              separatorBuilder: (context, index) =>
                  SizedBox(height: Dimensions.r12.dynamicH),
              itemBuilder: (context, index) {
                final request = items[index];
                return isReceived
                    ? _buildReceivedCard(context, request)
                    : _buildSentCard(context, request);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildReceivedCard(BuildContext context, JoinRequestEntity request) {
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
                            color: Colors.orange,
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
                  DateFormat('MMM d, h:mm a').format(request.createdAt),
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
                    child: const Text('Reject'),
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
                    child: const Text('Accept'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSentCard(BuildContext context, JoinRequestEntity request) {
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
                  DateFormat('MMM d, h:mm a').format(request.createdAt),
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
                  child: const Text('Cancel Request'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(BuildContext context, JoinRequestStatus status) {
    switch (status) {
      case JoinRequestStatus.pending:
        return Colors.orange;
      case JoinRequestStatus.accepted:
        return Colors.green;
      case JoinRequestStatus.rejected:
      case JoinRequestStatus.cancelled:
        return Colors.red;
    }
  }
}
