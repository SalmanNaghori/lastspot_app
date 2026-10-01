import 'package:lastspot_app/core/base_import.dart';

import '../../domain/entities/request_entity.dart';
import '../bloc/create_spot_bloc.dart';
import '../widgets/preview_spot_detail_row.dart';
import 'create_spot_screen.dart';

class PreviewSpotScreen extends StatelessWidget {
  final CreateSpotFormState formState;
  final RequestEntity? spotToEdit;

  const PreviewSpotScreen({
    super.key,
    required this.formState,
    this.spotToEdit,
  });

  void _onPublish(BuildContext context) {
    final matchDateTime = DateTime(
      formState.eventDate.value.year,
      formState.eventDate.value.month,
      formState.eventDate.value.day,
      formState.eventTime.value.hour,
      formState.eventTime.value.minute,
    );

    double price = 0.0;
    if (!formState.isFree.value && formState.priceController.text.isNotEmpty) {
      String cleanPrice = formState.priceController.text.replaceAll(
        RegExp(r'[^\d]'),
        '',
      );
      price = double.tryParse(cleanPrice) ?? 0.0;
    }

    if (spotToEdit != null) {
      final updateEvent = UpdateSpotEvent(
        spotId: spotToEdit!.id,
        categoryId: formState.selectedCategoryId.value,
        cityId: formState.selectedCity.value?.id,
        title: formState.titleController.text,
        description: formState.descriptionController.text,
        locationName: formState.locationController.text,
        eventDateTime: matchDateTime,
        maxParticipants: formState.maxParticipants.value,
        pricePerPerson: price,
      );
      context.read<CreateSpotBloc>().add(updateEvent);
    } else {
      final event = SubmitSpotEvent(
        categoryId: formState.selectedCategoryId.value!,
        cityId: formState.selectedCity.value!.id,
        title: formState.titleController.text,
        description: formState.descriptionController.text.isNotEmpty
            ? formState.descriptionController.text
            : null,
        locationName: formState.locationController.text,
        eventDateTime: matchDateTime,
        maxParticipants: formState.maxParticipants.value,
        pricePerPerson: price,
        images: formState.selectedImages.value,
      );
      context.read<CreateSpotBloc>().add(event);
    }

    // Pop the preview screen, loading/success will be handled by the parent screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final date = formState.eventDate.value;
    final time = formState.eventTime.value;
    final String formattedDate =
        '${date.day} ${AppConstants.getMonthName(date.month)} ${date.year} • ${time.format(context)}';

    String priceText = 'Free';
    if (!formState.isFree.value && formState.priceController.text.isNotEmpty) {
      priceText = '${formState.priceController.text} ${context.loc.perPerson}';
    }

    // Attempt to get category name if possible, fallback to ID if we don't have it (in a real app we'd fetch it)
    String categoryName = formState.selectedCategoryId.value ?? 'Category';
    final state = context.read<CreateSpotBloc>().state;
    if (state is CreateSpotCategoriesLoaded) {
      final found = state.categories
          .where((c) => c.id == formState.selectedCategoryId.value)
          .firstOrNull;
      if (found != null) categoryName = found.name;
    }

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        systemOverlayStyle: AppTheme.systemUiOverlayStyle(context),
        iconTheme: IconThemeData(color: context.textPrimary),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          context.loc.previewActivity,
          style: context.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(Dimensions.r16.dynamicW),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image preview
              if (formState.selectedImages.value.isNotEmpty ||
                  (spotToEdit != null && spotToEdit!.images.isNotEmpty))
                Container(
                  width: double.infinity,
                  height: 200.0.dynamicH,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      Dimensions.r16.dynamicR,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: Dimensions.r8.dynamicR,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      Dimensions.r16.dynamicR,
                    ),
                    child: formState.selectedImages.value.isNotEmpty
                        ? Image.file(
                            formState.selectedImages.value.first,
                            fit: BoxFit.cover,
                          )
                        : AppCachedNetworkImage(
                            imageUrl: spotToEdit!.images.first.storagePath,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              SizedBox(height: Dimensions.r16.dynamicH),

              // Category Badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.r12.dynamicW,
                  vertical: Dimensions.r6.dynamicH,
                ),
                decoration: BoxDecoration(
                  color: context.primaryColor,
                  borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
                ),
                child: Text(
                  categoryName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Dimensions.r12.dynamicSP,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: Dimensions.r16.dynamicH),

              // Title
              Text(
                formState.titleController.text,
                style: context.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.textPrimary,
                ),
              ),
              SizedBox(height: Dimensions.r8.dynamicH),

              // Description
              Text(
                formState.descriptionController.text,
                style: TextStyle(
                  color: context.textSecondary,
                  fontSize: Dimensions.r14.dynamicSP,
                ),
              ),
              SizedBox(height: Dimensions.r24.dynamicH),

              // Details List
              PreviewSpotDetailRow(
                icon: Icons.location_on_outlined,
                text: formState.locationController.text,
                onTap: () {
                  AppUtils.launchMap(formState.locationController.text);
                },
              ),
              SizedBox(height: Dimensions.r12.dynamicH),
              PreviewSpotDetailRow(
                icon: Icons.calendar_today_outlined,
                text: formattedDate,
              ),
              SizedBox(height: Dimensions.r12.dynamicH),
              PreviewSpotDetailRow(
                icon: Icons.group_outlined,
                text: '1/${formState.maxParticipants.value} players',
              ),
              SizedBox(height: Dimensions.r12.dynamicH),
              PreviewSpotDetailRow(
                icon: Icons.payments_outlined,
                text: priceText,
                iconColor: context.primaryColor,
                textColor: context.primaryColor,
              ),
              SizedBox(height: Dimensions.r32.dynamicH),

              // Disclaimer
              Container(
                padding: EdgeInsets.all(Dimensions.r16.dynamicW),
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.visibility_outlined,
                      color: context.primaryColor,
                    ),
                    SizedBox(width: Dimensions.r12.dynamicW),
                    Expanded(
                      child: Text(
                        context.loc.thisIsHowActivityAppears,
                        style: TextStyle(
                          color: context.primaryColor,
                          fontSize: Dimensions.r14.dynamicSP,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: Dimensions.r48.dynamicH),

              AppButton(
                label: context.loc.publishActivity,
                onPressed: () => _onPublish(context),
                isFullWidth: true,
              ),
              SizedBox(height: Dimensions.r32.dynamicH),
            ],
          ),
        ),
      ),
    );
  }
}
