import 'package:lastspot_app/core/base_import.dart';
import '../../../spot/domain/entities/join_request_entity.dart';
import 'package:lastspot_app/core/widgets/animation/widget_animation.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lastspot_app/core/widgets/custom_segmented_control.dart';
import 'request_shimmer_card.dart';
import 'received_request_card.dart';
import 'sent_request_card.dart';
import 'activity_empty_state.dart';

class RequestsTabSection extends StatefulWidget {
  final List<JoinRequestEntity> receivedRequests;
  final List<JoinRequestEntity> sentRequests;
  final double horizontalPadding;
  final bool isLoading;

  const RequestsTabSection({
    super.key,
    required this.receivedRequests,
    required this.sentRequests,
    this.horizontalPadding = 0.0,
    this.isLoading = false,
  });

  @override
  State<RequestsTabSection> createState() => _RequestsTabSectionState();
}

class _RequestsTabSectionState extends State<RequestsTabSection> {
  int _selectedIndex = 0; // 0 = received, 1 = sent

  @override
  Widget build(BuildContext context) {
    final isReceived = _selectedIndex == 0;
    final items = isReceived ? widget.receivedRequests : widget.sentRequests;

    return SliverMainAxisGroup(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomSegmentedControl(
                  selectedIndex: _selectedIndex,
                  tabs: [context.loc.tabReceived, context.loc.tabSent],
                  onTabChanged: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                ),
                SizedBox(height: Dimensions.r16.dynamicH),
              ],
            ),
          ),
        ),
        if (widget.isLoading)
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
            sliver: AnimationLimiter(
              child: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return AnimationWrapper(
                    index: index,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: Dimensions.r12.dynamicH),
                      child: const RequestShimmerCard(),
                    ),
                  );
                }, childCount: 4),
              ),
            ),
          )
        else if (items.isEmpty)
          ActivityEmptyState(
            title: isReceived
                ? context.loc.noReceivedRequests
                : context.loc.noSentRequests,
            message: isReceived
                ? context.loc.emptyReceivedRequestsDesc
                : context.loc.emptySentRequestsDesc,
          )
        else
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
            sliver: AnimationLimiter(
              child: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final request = items[index];
                  return AnimationWrapper(
                    index: index,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: Dimensions.r12.dynamicH),
                      child: isReceived
                          ? ReceivedRequestCard(request: request)
                          : SentRequestCard(request: request),
                    ),
                  );
                }, childCount: items.length),
              ),
            ),
          ),
      ],
    );
  }
}
