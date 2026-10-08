import 'package:lastspot_app/core/base_import.dart';
import '../bloc/spot_details_bloc.dart';
import 'spot_details_screen_mobile.dart';
import 'spot_details_screen_tablet.dart';
import '../../domain/entities/request_entity.dart';

class SpotDetailsScreen extends StatefulWidget {
  final String spotId;
  final String? heroTag;
  final RequestEntity? initialSpot;

  const SpotDetailsScreen({
    super.key,
    required this.spotId,
    this.heroTag,
    this.initialSpot,
  });

  @override
  State<SpotDetailsScreen> createState() => _SpotDetailsScreenState();
}

class _SpotDetailsScreenState extends State<SpotDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SpotDetailsBloc>().add(
      LoadSpotDetailsEvent(
        spotId: widget.spotId,
        initialSpot: widget.initialSpot,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpotDetailsBloc, SpotDetailsState>(
      buildWhen: (previous, current) {
        // Keep the loaded details visible during a successful join refresh.
        if (current is RequestJoinSuccess) return false;
        if (previous is RequestJoinSuccess && current is SpotDetailsLoading) {
          return false;
        }
        return true;
      },
      listener: (context, state) {
        if (state is RequestJoinSuccess) {
          AppUtils.showSnackBar(context, state.message);
        } else if (state is SpotDetailsError) {
          AppUtils.showSnackBar(context, state.message, isError: true);
        }
      },
      builder: (context, state) {
        void reload() => context.read<SpotDetailsBloc>().add(
          LoadSpotDetailsEvent(spotId: widget.spotId),
        );
        return LayoutBuilder(
          builder: (context, constraints) =>
              constraints.maxWidth >= Dimensions.detailsTabletBreakpoint
              ? SpotDetailsScreenTablet(
                  state: state,
                  heroTag: widget.heroTag,
                  onBack: () => context.pop(),
                  onRetry: reload,
                )
              : SpotDetailsScreenMobile(
                  state: state,
                  heroTag: widget.heroTag,
                  onBack: () => context.pop(),
                  onRetry: reload,
                ),
        );
      },
    );
  }
}
