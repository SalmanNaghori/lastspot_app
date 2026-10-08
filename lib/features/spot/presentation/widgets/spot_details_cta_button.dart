import 'package:lastspot_app/core/base_import.dart';
import '../../domain/policies/spot_participation_policy.dart';
import '../bloc/spot_details_bloc.dart';

class SpotDetailsCtaButton extends StatefulWidget {
  final SpotDetailsLoaded loadedState;

  const SpotDetailsCtaButton({super.key, required this.loadedState});

  @override
  State<SpotDetailsCtaButton> createState() => _SpotDetailsCtaButtonState();
}

class _SpotDetailsCtaButtonState extends State<SpotDetailsCtaButton> {
  bool _submitting = false;

  void _requestToJoin() {
    if (_submitting) return;
    // Recheck the time at the action edge in case the screen was left open.
    final availability = SpotParticipationPolicy.availability(
      post: widget.loadedState.post,
      request: widget.loadedState.userJoinRequest,
      now: DateTime.now(),
    );
    if (availability != SpotJoinAvailability.available) {
      setState(() {});
      return;
    }
    setState(() => _submitting = true);
    context.read<SpotDetailsBloc>().add(
      RequestToJoinEvent(spotId: widget.loadedState.post.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;
    final state = widget.loadedState;
    final availability = SpotParticipationPolicy.availability(
      post: state.post,
      request: state.userJoinRequest,
      now: DateTime.now(),
    );
    final label = state.isHost
        ? loc.manageMatchRequests
        : switch (availability) {
            SpotJoinAvailability.available => loc.detailsJoin,
            SpotJoinAvailability.full => loc.statusFull,
            SpotJoinAvailability.closed => loc.detailsClosed,
            SpotJoinAvailability.pending => loc.pendingRequest,
            SpotJoinAvailability.accepted => loc.joined,
            SpotJoinAvailability.rejected => loc.requestRejected,
            SpotJoinAvailability.requestCancelled => loc.requestCancelled,
            SpotJoinAvailability.activityCancelled => loc.statusCancelled,
            SpotJoinAvailability.completed => loc.statusCompleted,
            SpotJoinAvailability.expired => loc.statusExpired,
            SpotJoinAvailability.draft => loc.detailsDraft,
          };
    final enabled =
        state.isHost || availability == SpotJoinAvailability.available;
    return BlocListener<SpotDetailsBloc, SpotDetailsState>(
      listener: (context, state) {
        if (_submitting && state is! SpotDetailsLoading) {
          setState(() => _submitting = false);
        }
      },
      child: AppButton(
        label: label,
        isLoading: _submitting,
        icon: state.isHost ? Icons.group_outlined : Icons.arrow_forward_rounded,
        onPressed: !enabled
            ? null
            : state.isHost
            ? () =>
                  context.safePush(AppRoutes.manageRequestsPath(state.post.id))
            : _requestToJoin,
      ),
    );
  }
}
