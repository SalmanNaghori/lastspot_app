import 'package:lastspot_app/core/base_import.dart';
import '../../domain/entities/join_request_entity.dart';
import '../../domain/entities/request_entity.dart';
import '../../domain/policies/spot_participation_policy.dart';
import '../bloc/manage_requests_bloc.dart';

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
        title: Text(context.loc.manageMatchRequests),
      ),
      body: BlocBuilder<ManageRequestsBloc, ManageRequestsState>(
        builder: (context, state) {
          if (state is ManageRequestsLoading ||
              state is ManageRequestsInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ManageRequestsError) {
            return Center(
              child: _ContentWidth(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: colors.error),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: context.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      FilledButton.icon(
                        onPressed: _loadRequests,
                        icon: const Icon(Icons.refresh),
                        label: Text(context.loc.retry),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          if (state is ManageRequestsLoaded) {
            return _ContentWidth(
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
                        _SpotSummaryCard(post: state.post),
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
                          _EmptyRequests(message: context.loc.noPendingRequests)
                        else
                          ...state.pendingRequests.map(
                            (request) => Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSpacing.md,
                              ),
                              child: _RequestCard(
                                request: request,
                                onAccept: () =>
                                    _updateRequest(request.id, 'accepted'),
                                onReject: () =>
                                    _updateRequest(request.id, 'rejected'),
                                onMessage: () => _openDirectMessage(
                                  request.userId,
                                  request.userProfile?.fullName ??
                                      context.loc.player,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
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
            child: _ContentWidth(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: FilledButton(
                  onPressed: () =>
                      context.push(AppRoutes.chatPath(widget.spotId)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.forum_outlined),
                      const SizedBox(width: AppSpacing.sm),
                      Text(context.loc.openMatchChat),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _openDirectMessage(String recipientId, String recipientName) {
    final uri = Uri(
      path: AppRoutes.chatPath(widget.spotId),
      queryParameters: {'recipient': recipientId, 'name': recipientName},
    );
    context.push(uri.toString());
  }
}

class _ContentWidth extends StatelessWidget {
  final Widget child;

  const _ContentWidth({required this.child});

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 760),
      child: child,
    ),
  );
}

class _SpotSummaryCard extends StatelessWidget {
  final RequestEntity post;

  const _SpotSummaryCard({required this.post});

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final title = post.title.trim().isNotEmpty
        ? post.title.trim()
        : AppUtils.getDisplayLocation(
            context,
            post.locationName,
            cityId: post.cityId,
          );
    final remaining = SpotParticipationPolicy.remainingSpots(post);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.mdLg),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: AppRadius.xxlBorderRadius,
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: AppRadius.mdBorderRadius,
                ),
                child: Icon(Icons.sports, color: colors.primary),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      AppUtils.formatDateTime(post.eventDateTime),
                      style: context.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Icon(
                Icons.groups_outlined,
                size: 20,
                color: colors.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  context.loc.openSpotsRemaining(
                    remaining,
                    post.maxParticipants,
                  ),
                  style: context.bodyMedium?.copyWith(
                    color: remaining == 0 ? colors.error : colors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: AppRadius.pillBorderRadius,
            child: LinearProgressIndicator(
              value: SpotParticipationPolicy.occupancy(post),
              minHeight: 7,
              backgroundColor: colors.surfaceContainerHighest,
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final JoinRequestEntity request;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final VoidCallback onMessage;

  const _RequestCard({
    required this.request,
    required this.onAccept,
    required this.onReject,
    required this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final name = request.userProfile?.fullName?.trim();
    final displayName = name == null || name.isEmpty
        ? context.loc.player
        : name;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppCachedNetworkImage(
                  imageUrl: request.userProfile?.avatarUrl,
                  width: 48,
                  height: 48,
                  isCircle: true,
                  backgroundColor: colors.surfaceContainerHighest,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: context.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        AppUtils.formatDateTime(request.createdAt),
                        style: context.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.schedule, size: 18, color: colors.onSurfaceVariant),
              ],
            ),
            if (request.message?.trim().isNotEmpty == true) ...[
              const SizedBox(height: AppSpacing.md),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLow,
                  borderRadius: AppRadius.mdBorderRadius,
                ),
                child: Text(
                  request.message!.trim(),
                  style: context.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: onMessage,
                icon: const Icon(Icons.chat_bubble_outline),
                label: Text(context.loc.directMessage),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.error,
                      side: BorderSide(color: colors.error),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.close),
                        const SizedBox(width: AppSpacing.xs),
                        Text(context.loc.reject),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: FilledButton(
                    onPressed: onAccept,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check),
                        const SizedBox(width: AppSpacing.xs),
                        Text(context.loc.accept),
                      ],
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
}

class _EmptyRequests extends StatelessWidget {
  final String message;

  const _EmptyRequests({required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xxl,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: AppRadius.xxlBorderRadius,
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        children: [
          Icon(Icons.inbox_outlined, size: 40, color: colors.onSurfaceVariant),
          const SizedBox(height: AppSpacing.md),
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
