import 'dart:io';
import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/core/di/service_locator.dart';
import 'package:lastspot_app/core/utils/currency_input_formatter.dart';
import 'package:lastspot_app/core/widgets/selection_bottom_sheet.dart';
import '../../../cities/domain/entities/city_entity.dart';
import '../../../cities/presentation/bloc/city_cubit.dart';
import '../../../cities/presentation/bloc/city_state.dart';
import '../../domain/entities/request_entity.dart';
import '../../../categories/domain/entities/category.dart';
import '../bloc/create_spot_bloc.dart';
import 'create_spot_screen.dart';
import '../widgets/create_spot_section_title.dart';
import '../widgets/create_spot_selection_field.dart';
import '../widgets/create_spot_add_photo_button.dart';
import '../widgets/create_spot_existing_image.dart';
import '../widgets/create_spot_file_image.dart';
import '../widgets/create_spot_participants_selector.dart';
import '../widgets/create_spot_datetime_selector.dart';

class CreateSpotScreenMobile extends StatelessWidget {
  final CreateSpotFormState formState;
  final RequestEntity? spotToEdit;
  final bool isLoading;
  final VoidCallback onPickImages;
  final VoidCallback onPreview;
  final CreateSpotState blocState;

  final bool showAppBar;

  const CreateSpotScreenMobile({
    super.key,
    required this.formState,
    this.spotToEdit,
    required this.isLoading,
    required this.onPickImages,
    required this.onPreview,
    required this.blocState,
    this.showAppBar = true,
  });

  // To make City and Category pickers work with SelectionBottomSheet easily:
  void _openCityPicker(BuildContext context) async {
    // Ensure cities are loaded
    final cityCubit = sl<CityCubit>();
    if (cityCubit.state is! CityLoaded) {
      await cityCubit.fetchCities();
    }

    if (context.mounted) {
      final state = cityCubit.state;
      List<CityEntity> cities = [];
      bool hasError = false;
      bool isLoading = false;

      if (state is CityLoaded) {
        cities = state.cities;
      }

      final selected = await SelectionBottomSheet.show<CityEntity>(
        context,
        title: context.loc.selectCity,
        searchHint: 'Search city...',
        items: cities,
        itemText: (city) => city.name,
        onSearch: (city, query) => city.name.toLowerCase().contains(query),
        selectedItem: formState.selectedCity.value,
        isLoading: isLoading,
        hasError: hasError,
        onRetry: () => cityCubit.fetchCities(),
        leadingIcon: (city) => Icon(Icons.location_on, color: context.textSecondary),
      );

      if (selected != null) {
        formState.selectedCity.value = selected;
      }
    }
  }

  void _openCategoryPicker(BuildContext context) async {
    List<CategoryEntity> categories = [];
    bool hasError = false;
    bool isLoading = blocState is CreateSpotCategoriesLoading;

    if (blocState is CreateSpotCategoriesLoaded) {
      categories = (blocState as CreateSpotCategoriesLoaded).categories;
    } else if (blocState is CreateSpotError) {
      hasError = true;
    }

    final selectedCategory = await SelectionBottomSheet.show<CategoryEntity>(
      context,
      title: context.loc.selectCategory,
      searchHint: 'Search categories...',
      items: categories,
      itemText: (cat) => cat.name,
      onSearch: (cat, query) => cat.name.toLowerCase().contains(query),
      selectedItem: categories.where((c) => c.id == formState.selectedCategoryId.value).firstOrNull,
      isLoading: isLoading,
      hasError: hasError,
      emptyMessage: context.loc.noCategoriesAvailable,
    );

    if (selectedCategory != null) {
      formState.selectedCategoryId.value = selectedCategory.id;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: showAppBar
          ? AppBar(
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
                style: context.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: context.textPrimary),
              ),
            )
          : null,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: Dimensions.r16.dynamicW, vertical: Dimensions.r16.dynamicH),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Activity Images
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.loc.activityImages,
                        style: context.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.chevron_right, color: context.textSecondary),
                    ],
                  ),
                  SizedBox(height: Dimensions.r12.dynamicH),
                  SizedBox(
                    height: 100.0.dynamicH,
                    child: ValueListenableBuilder<List<File>>(
                      valueListenable: formState.selectedImages,
                      builder: (context, images, _) {
                        return ListView(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          children: [
                            if (spotToEdit != null)
                              ...spotToEdit!.images.map((img) => CreateSpotExistingImage(image: img)),
                            ...images.map(
                              (file) => CreateSpotFileImage(
                                file: file,
                                onRemove: () {
                                  final updatedList = List<File>.from(formState.selectedImages.value)..remove(file);
                                  formState.selectedImages.value = updatedList;
                                },
                              ),
                            ),
                            CreateSpotAddPhotoButton(onTap: onPickImages),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: Dimensions.r24.dynamicH),

                  // 2. City
                  CreateSpotSectionTitle(title: context.loc.city),
                  SizedBox(height: Dimensions.r8.dynamicH),
                  ValueListenableBuilder<CityEntity?>(
                    valueListenable: formState.selectedCity,
                    builder: (context, city, _) {
                      return CreateSpotSelectionField(
                        label: city?.name ?? context.loc.selectCity,
                        icon: Icons.location_city,
                        isSelected: city != null,
                        onTap: () => _openCityPicker(context),
                      );
                    },
                  ),
                  SizedBox(height: Dimensions.r24.dynamicH),

                  // 3. Category
                  CreateSpotSectionTitle(title: context.loc.category),
                  SizedBox(height: Dimensions.r8.dynamicH),
                  ValueListenableBuilder<String?>(
                    valueListenable: formState.selectedCategoryId,
                    builder: (context, categoryId, _) {
                      // Find category name if possible
                      String label = context.loc.selectCategory;
                      if (categoryId != null && blocState is CreateSpotCategoriesLoaded) {
                        final cats = (blocState as CreateSpotCategoriesLoaded).categories;
                        final found = cats.where((c) => c.id == categoryId).firstOrNull;
                        if (found != null) label = found.name;
                      }

                      return CreateSpotSelectionField(
                        label: label,
                        icon: Icons.category_outlined,
                        isSelected: categoryId != null,
                        onTap: () => _openCategoryPicker(context),
                      );
                    },
                  ),
                  SizedBox(height: Dimensions.r24.dynamicH),

                  // 4. Activity Title
                  AppTextField(
                    controller: formState.titleController,
                    labelText: '${context.loc.activityTitle} *',
                    hintText: context.loc.activityTitleHint,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  SizedBox(height: Dimensions.r16.dynamicH),

                  // 5. Description
                  AppTextField(
                    controller: formState.descriptionController,
                    labelText: '${context.loc.description} *',
                    hintText: context.loc.descriptionHint,
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  SizedBox(height: Dimensions.r16.dynamicH),

                  // 6. Location
                  AppTextField(
                    controller: formState.locationController,
                    labelText: '${context.loc.location} *',
                    hintText: context.loc.locationHint,
                    textCapitalization: TextCapitalization.sentences,
                    prefixIcon: Icon(Icons.location_on_outlined, color: context.textSecondary),
                  ),
                  SizedBox(height: Dimensions.r24.dynamicH),

                  // 7. Date & Time
                  CreateSpotSectionTitle(title: 'Date & Time *'),
                  SizedBox(height: Dimensions.r8.dynamicH),
                  CreateSpotDatetimeSelector(dateNotifier: formState.eventDate, timeNotifier: formState.eventTime),
                  SizedBox(height: Dimensions.r32.dynamicH),

                  // 8. Participants
                  CreateSpotSectionTitle(title: '${context.loc.maxParticipants} *'),
                  SizedBox(height: Dimensions.r8.dynamicH),
                  CreateSpotParticipantsSelector(maxParticipantsNotifier: formState.maxParticipants),
                  SizedBox(height: Dimensions.r32.dynamicH),

                  // 9. Price
                  CreateSpotSectionTitle(title: context.loc.price),
                  SizedBox(height: Dimensions.r12.dynamicH),
                  ValueListenableBuilder<bool>(
                    valueListenable: formState.isFree,
                    builder: (context, isFree, _) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: context.surfaceColor,
                              borderRadius: BorderRadius.circular(Dimensions.r24.dynamicR),
                              border: Border.all(color: context.borderColor),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => formState.isFree.value = true,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: Dimensions.r12.dynamicH),
                                      decoration: BoxDecoration(
                                        color: isFree ? context.primaryColor : Colors.transparent,
                                        borderRadius: BorderRadius.circular(Dimensions.r24.dynamicR),
                                      ),
                                      child: Center(
                                        child: Text(
                                          context.loc.free,
                                          style: TextStyle(
                                            color: isFree ? Colors.white : context.textPrimary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => formState.isFree.value = false,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: Dimensions.r12.dynamicH),
                                      decoration: BoxDecoration(
                                        color: !isFree ? context.primaryColor : Colors.transparent,
                                        borderRadius: BorderRadius.circular(Dimensions.r24.dynamicR),
                                      ),
                                      child: Center(
                                        child: Text(
                                          context.loc.paid,
                                          style: TextStyle(
                                            color: !isFree ? Colors.white : context.textPrimary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Animated Price Field
                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: !isFree
                                ? Padding(
                                    padding: EdgeInsets.only(top: Dimensions.r24.dynamicH),
                                    child: AppTextField(
                                      controller: formState.priceController,
                                      labelText: '${context.loc.pricePerPerson} *',
                                      hintText: '₹ Enter amount',
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [CurrencyInputFormatter()],
                                    ),
                                  )
                                : const SizedBox(width: double.infinity, height: 0),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: Dimensions.r48.dynamicH),

                  // 10. CTAs
                  AppButton(label: context.loc.previewActivity, onPressed: onPreview, isFullWidth: true),
                  SizedBox(height: Dimensions.r64.dynamicH), // Extra space for bottom nav
                ],
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black45,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
