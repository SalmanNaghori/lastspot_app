import 'package:lastspot_app/core/base_import.dart';
import '../../domain/entities/request_entity.dart';
import '../bloc/create_spot_bloc.dart';
import 'create_spot_screen.dart';
import 'create_spot_screen_mobile.dart'; // To reuse some private methods if we copied them, or just copy the logic for now.

// For simplicity in this implementation, we will reuse CreateSpotScreenMobile layout inside a tablet container
// since the layout is identical but constrained by width.

class CreateSpotScreenTablet extends StatelessWidget {
  final CreateSpotFormState formState;
  final RequestEntity? spotToEdit;
  final bool isLoading;
  final VoidCallback onPickImages;
  final VoidCallback onPreview;
  final CreateSpotState blocState;

  const CreateSpotScreenTablet({
    super.key,
    required this.formState,
    this.spotToEdit,
    required this.isLoading,
    required this.onPickImages,
    required this.onPreview,
    required this.blocState,
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
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.home);
            }
          },
        ),
        title: Text(
          spotToEdit != null ? context.loc.edit : context.loc.generateActivity,
          style: context.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 850,
            ), // Rule 8 max width for tablet content
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
              child: CreateSpotScreenMobile(
                formState: formState,
                spotToEdit: spotToEdit,
                isLoading: isLoading,
                onPickImages: onPickImages,
                onPreview: onPreview,
                blocState: blocState,
                showAppBar: false,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
