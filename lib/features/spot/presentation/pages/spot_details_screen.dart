import 'package:supabase_flutter/supabase_flutter.dart';
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
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;

    return BlocConsumer<SpotDetailsBloc, SpotDetailsState>(
      listener: (context, state) {
        if (state is RequestJoinSuccess) {
          AppUtils.showSnackBar(context, state.message);
        } else if (state is SpotDetailsError) {
          AppUtils.showSnackBar(context, state.message, isError: true);
        }
      },
      builder: (context, state) {
        return ResponsiveLayout(
          mobile: SpotDetailsScreenMobile(
            state: state,
            currentUserId: currentUserId,
            heroTag: widget.heroTag,
            onBack: () => context.pop(),
          ),
          tablet: SpotDetailsScreenTablet(
            state: state,
            currentUserId: currentUserId,
            heroTag: widget.heroTag,
            onBack: () => context.pop(),
          ),
        );
      },
    );
  }
}
