import 'package:lastspot_app/core/base_import.dart';
import '../bloc/spot_details_bloc.dart';
import 'spot_details_screen_mobile.dart';

class SpotDetailsScreenTablet extends StatelessWidget {
  final SpotDetailsState state;
  final String? currentUserId;
  final String? heroTag;
  final VoidCallback onBack;

  const SpotDetailsScreenTablet({
    super.key,
    required this.state,
    required this.currentUserId,
    this.heroTag,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        systemOverlayStyle: AppTheme.systemUiOverlayStyle(context),
        iconTheme: IconThemeData(color: context.textPrimary),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
        title: Text(
          context.loc.matchOverviewTitle,
          style: context.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 850),
            margin: EdgeInsets.all(Dimensions.r24.dynamicW),
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: BorderRadius.circular(Dimensions.r24.dynamicR),
              border: Border.all(color: context.borderColor, width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: context.isDarkMode
                      ? Colors.transparent
                      : Colors.black.withValues(alpha: 0.04),
                  blurRadius: Dimensions.r20.dynamicR,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.r24.dynamicR),
              child: SpotDetailsScreenMobile(
                state: state,
                currentUserId: currentUserId,
                heroTag: heroTag,
                onBack: onBack,
                showAppBar: false, // Tablet wrapper handles the AppBar
              ),
            ),
          ),
        ),
      ),
    );
  }
}
