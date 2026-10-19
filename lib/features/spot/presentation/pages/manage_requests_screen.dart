import 'package:lastspot_app/core/base_import.dart';
import '../bloc/manage_requests_bloc.dart';
import '../widgets/manage_join_request_card.dart';
import '../widgets/manage_spot_summary_card.dart';

class ManageRequestsScreen extends StatefulWidget {
  final String spotId;

  const ManageRequestsScreen({super.key, required this.spotId});

  @override
  State<ManageRequestsScreen> createState() => _ManageRequestsScreenState();
}

class _ManageRequestsScreenState extends State<ManageRequestsScreen> {
  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  void _loadRequests() {
    context.read<ManageRequestsBloc>().add(
      LoadPendingRequestsEvent(spotId: widget.spotId),
    );
  }

  void _updateRequest(String requestId, String status) {
    context.read<ManageRequestsBloc>().add(
      UpdateRequestStatusEvent(requestId: requestId, status: status),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return ResponsiveLayout(
      mobile: _buildScaffold(context, colors),
      tablet: _buildScaffold(context, colors),
    );
  }

  Widget _buildScaffold(BuildContext context, ColorScheme colors) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          context.loc.manageMatchRequests,
          style: TextStyle(
            color: context.textPrimary,
            fontSize: Dimensions.r18.dynamicSP,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: BlocBuilder<ManageRequestsBloc, ManageRequestsState>(
        builder: (context, state) {
          if (state is ManageRequestsLoading ||
              state is ManageRequestsInitial) {
            return const Center(child: AppLoading());
          }

          if (state is ManageRequestsError) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: AppErrorState(
                  message: state.message,
                  onRetry: _loadRequests,
                ),
              ),
            );
          }

          if (state is ManageRequestsLoaded) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.md,
                        AppSpacing.md,
                        AppSpacing.md,
                        AppSpacing.lg,
                      ),
                      sliver: SliverList.list(
                        children: [
                          ManageSpotSummaryCard(post: state.post),
                          const SizedBox(height: AppSpacing.xl),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  context.loc.pendingRequests(
                                    state.pendingRequests.length,
                                  ),
                                  style: context.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          if (state.pendingRequests.isEmpty)
                            AppEmptyState.joinRequests(
                              title: context.loc.noPendingRequests,
                              message: '',
                            )
                          else
                            ...state.pendingRequests.map(
                              (request) => Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSpacing.md,
                                ),
                                child: ManageJoinRequestCard(
                                  request: request,
                                  onAccept: () =>
                                      _updateRequest(request.id, 'accepted'),
                                  onReject: () =>
                                      _updateRequest(request.id, 'rejected'),
                                  onMessage: () => _openDirectMessage(
                                    request.userId,
                                    request.userProfile?.fullName ??
                                        context.loc.player,
                                    activityTitle: state.post.title,
                                  ),
                                ),
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

          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: BlocBuilder<ManageRequestsBloc, ManageRequestsState>(
        builder: (context, state) {
          if (state is! ManageRequestsLoaded) return const SizedBox.shrink();
          return SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: AppButton(
                    label: context.loc.openMatchChat,
                    icon: Icons.forum_outlined,
                    onPressed: () => context.push(
                      AppRoutes.activityGroupChatPath(
                        widget.spotId,
                        title: state.post.title,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _openDirectMessage(
    String recipientId,
    String recipientName, {
    String? activityTitle,
  }) {
    final uri = Uri(
      path: AppRoutes.chatPath(widget.spotId),
      queryParameters: {
        'is_direct': 'true',
        'recipient': recipientId,
        'name': recipientName,
        'request_id': widget.spotId,
        if (activityTitle?.trim().isNotEmpty == true)
          'activity_title': activityTitle!.trim(),
      },
    );
    context.push(uri.toString());
  }
}
