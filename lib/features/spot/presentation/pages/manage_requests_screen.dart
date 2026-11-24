import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/features/spot/domain/entities/join_request_entity.dart';
import '../../domain/policies/spot_participation_policy.dart';
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
  final ValueNotifier<int> _selectedTabIndex = ValueNotifier<int>(
    1,
  ); // Default to Pending

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  @override
  void dispose() {
    _selectedTabIndex.dispose();
    super.dispose();
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

  Future<void> _onRefresh() async {
    _loadRequests();
  }

  void _onAcceptRequest(String requestId) {
    _updateRequest(requestId, 'accepted');
  }

  void _onRejectRequest(String requestId) {
    _updateRequest(requestId, 'rejected');
  }

  void _onMessageRequest(JoinRequestEntity request, String activityTitle) {
    _openDirectMessage(
      request.userId,
      request.userProfile?.fullName ?? context.loc.player,
      activityTitle: activityTitle,
    );
  }

  void _onOpenMatchChat(String activityTitle) {
    context.push(
      AppRoutes.activityGroupChatPath(widget.spotId, title: activityTitle),
    );
  }

  void _showApplicantProfile(BuildContext context, JoinRequestEntity request) {
    final profile = request.userProfile;
    final displayName = profile?.fullName?.trim() ?? context.loc.player;
    final city = profile?.city?.trim() ?? profile?.cityId?.trim();
    final bio = profile?.bio?.trim();
    final sports = profile?.sportsInterests ?? const <String>[];
    final colors = context.colorScheme;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Dimensions.r24.dynamicR),
        ),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              Dimensions.r20.dynamicW,
              Dimensions.r16.dynamicH,
              Dimensions.r20.dynamicW,
              Dimensions.r20.dynamicH,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: Dimensions.r40.dynamicW,
                  height: Dimensions.r4.dynamicH,
                  decoration: BoxDecoration(
                    color: colors.outlineVariant,
                    borderRadius: BorderRadius.circular(Dimensions.r2.dynamicR),
                  ),
                ),
                SizedBox(height: Dimensions.r16.dynamicH),
                UserAvatar(
                  imageUrl: profile?.avatarUrl,
                  name: displayName,
                  size: 72,
                ),
                SizedBox(height: Dimensions.r12.dynamicH),
                Text(
                  displayName,
                  style: context.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (city != null && city.isNotEmpty) ...[
                  SizedBox(height: Dimensions.r4.dynamicH),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: Dimensions.r16.dynamicH,
                        color: colors.onSurfaceVariant,
                      ),
                      SizedBox(width: Dimensions.r4.dynamicW),
                      Text(
                        city,
                        style: context.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
                if (bio != null && bio.isNotEmpty) ...[
                  SizedBox(height: Dimensions.r16.dynamicH),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(Dimensions.r12.dynamicW),
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(
                        Dimensions.r12.dynamicR,
                      ),
                    ),
                    child: Text(
                      bio,
                      style: context.bodyMedium?.copyWith(
                        color: context.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                if (sports.isNotEmpty) ...[
                  SizedBox(height: Dimensions.r16.dynamicH),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      context.loc.sportsPreferences,
                      style: context.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.r8.dynamicH),
                  Wrap(
                    spacing: Dimensions.r8.dynamicW,
                    runSpacing: Dimensions.r8.dynamicH,
                    children: sports.map((s) {
                      return Chip(
                        label: Text(s.capitalizeFirst()),
                        backgroundColor: context.primaryColor.withValues(
                          alpha: 0.1,
                        ),
                        side: BorderSide.none,
                        labelStyle: context.labelSmall?.copyWith(
                          color: context.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    }).toList(),
                  ),
                ],
                SizedBox(height: Dimensions.r20.dynamicH),
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    label: context.loc.directMessage,
                    icon: Icons.chat_bubble_outline,
                    onPressed: () {
                      Navigator.of(bottomSheetContext).pop();
                      _openDirectMessage(request.userId, displayName);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
        leading: const KhelBhaiBackButton(),
        title: Text(
          context.loc.manageMatchRequests,
          style: TextStyle(
            color: context.textPrimary,
            fontSize: Dimensions.r18.dynamicSP,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: BlocConsumer<ManageRequestsBloc, ManageRequestsState>(
        listener: (context, state) {
          if (state is ManageRequestsActionError) {
            AppUtils.showSnackBar(context, state.message, isError: true);
          }
        },
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

          final loadedState = state is ManageRequestsActionError
              ? state.previousState
              : (state is ManageRequestsLoaded ? state : null);

          if (loadedState != null) {
            return ValueListenableBuilder<int>(
              valueListenable: _selectedTabIndex,
              builder: (context, activeIndex, child) {
                final allRequests = loadedState.allRequests;
                final pendingRequests = loadedState.pendingRequests;
                final acceptedRequests = loadedState.acceptedRequests;
                final rejectedRequests = loadedState.rejectedRequests;

                final List<JoinRequestEntity> displayedRequests;
                switch (activeIndex) {
                  case 0:
                    displayedRequests = allRequests;
                    break;
                  case 1:
                    displayedRequests = pendingRequests;
                    break;
                  case 2:
                    displayedRequests = acceptedRequests;
                    break;
                  case 3:
                    displayedRequests = rejectedRequests;
                    break;
                  default:
                    displayedRequests = pendingRequests;
                }

                final remainingSpots = SpotParticipationPolicy.remainingSpots(
                  loadedState.post,
                );

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 760),
                    child: RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
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
                                // Top Activity Summary Card
                                ManageSpotSummaryCard(
                                  post: loadedState.post,
                                  pendingCount: pendingRequests.length,
                                ),
                                const SizedBox(height: AppSpacing.lg),

                                // Tabs: All / Pending / Accepted / Rejected
                                _buildFilterTabs(
                                  context,
                                  activeIndex: activeIndex,
                                  allCount: allRequests.length,
                                  pendingCount: pendingRequests.length,
                                  acceptedCount: acceptedRequests.length,
                                  rejectedCount: rejectedRequests.length,
                                ),
                                const SizedBox(height: AppSpacing.md),

                                // Swipe Gesture Hint Banner (for pending requests)
                                if (activeIndex == 1 &&
                                    pendingRequests.isNotEmpty) ...[
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                      vertical: Dimensions.r8.dynamicH,
                                      horizontal: Dimensions.r12.dynamicW,
                                    ),
                                    decoration: BoxDecoration(
                                      color: context.primaryColor.withValues(
                                        alpha: 0.08,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        Dimensions.r8.dynamicR,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.swipe_outlined,
                                          size: Dimensions.r16.dynamicH,
                                          color: context.primaryColor,
                                        ),
                                        SizedBox(width: Dimensions.r6.dynamicW),
                                        Text(
                                          context.loc.swipeHint,
                                          style: context.labelSmall?.copyWith(
                                            color: context.primaryColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.md),
                                ],

                                // List of Requests or Empty State
                                if (displayedRequests.isEmpty)
                                  AppEmptyState.joinRequests(
                                    title: activeIndex == 1
                                        ? context.loc.noPendingRequests
                                        : context.loc.noRequestsInTab,
                                    message: '',
                                  )
                                else
                                  ...displayedRequests.map(
                                    (request) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: AppSpacing.md,
                                      ),
                                      child: ManageJoinRequestCard(
                                        request: request,
                                        remainingSpots: remainingSpots,
                                        isProcessing:
                                            loadedState.activeProcessingId ==
                                            request.id,
                                        onAccept: () =>
                                            _onAcceptRequest(request.id),
                                        onReject: () =>
                                            _onRejectRequest(request.id),
                                        onMessage: () => _onMessageRequest(
                                          request,
                                          loadedState.post.title,
                                        ),
                                        onViewProfile: () =>
                                            _showApplicantProfile(
                                              context,
                                              request,
                                            ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: SizedBox(height: Dimensions.r32.dynamicH),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: BlocBuilder<ManageRequestsBloc, ManageRequestsState>(
        builder: (context, state) {
          final loadedState = state is ManageRequestsActionError
              ? state.previousState
              : (state is ManageRequestsLoaded ? state : null);
          if (loadedState == null) return const SizedBox.shrink();
          return SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: AppButton(
                    label: context.loc.openMatchChat,
                    icon: Icons.forum_outlined,
                    onPressed: () => _onOpenMatchChat(loadedState.post.title),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterTabs(
    BuildContext context, {
    required int activeIndex,
    required int allCount,
    required int pendingCount,
    required int acceptedCount,
    required int rejectedCount,
  }) {
    final tabs = [
      {'label': '${context.loc.tabAll} ($allCount)', 'index': 0},
      {'label': '${context.loc.tabPending} ($pendingCount)', 'index': 1},
      {'label': '${context.loc.tabAccepted} ($acceptedCount)', 'index': 2},
      {'label': '${context.loc.tabRejected} ($rejectedCount)', 'index': 3},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs.map((tab) {
          final isSelected = activeIndex == tab['index'];
          return Padding(
            padding: EdgeInsets.only(right: Dimensions.r8.dynamicW),
            child: FilterChip(
              selected: isSelected,
              label: Text(tab['label'] as String),
              selectedColor: context.primaryColor,
              backgroundColor: context.surfaceColor,
              side: BorderSide(
                color: isSelected ? context.primaryColor : context.borderColor,
              ),
              labelStyle: context.labelMedium?.copyWith(
                color: isSelected ? Colors.white : context.textPrimary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
              showCheckmark: false,
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.r10.dynamicW,
                vertical: Dimensions.r6.dynamicH,
              ),
              onSelected: (_) {
                _selectedTabIndex.value = tab['index'] as int;
              },
            ),
          );
        }).toList(),
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
