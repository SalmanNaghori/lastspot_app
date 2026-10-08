import 'package:lastspot_app/core/base_import.dart';
import '../bloc/spot_details_bloc.dart';
import 'spot_details_screen_mobile.dart';

class SpotDetailsScreenTablet extends StatelessWidget {
  final SpotDetailsState state;
  final String? heroTag;
  final VoidCallback onBack;
  final VoidCallback onRetry;

  const SpotDetailsScreenTablet({
    super.key,
    required this.state,
    this.heroTag,
    required this.onBack,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: context.backgroundColor,
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: Dimensions.detailsMaxWidth),
        child: SpotDetailsScreenMobile(
          state: state,
          heroTag: heroTag,
          onBack: onBack,
          onRetry: onRetry,
        ),
      ),
    ),
  );
}
