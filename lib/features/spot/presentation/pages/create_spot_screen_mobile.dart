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
        leadingIcon: (city) =>
            Icon(Icons.location_on, color: context.textSecondary),
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
      selectedItem: categories
          .where((c) => c.id == formState.selectedCategoryId.value)
          .firstOrNull,
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
                spotToEdit != null
                    ? context.loc.edit
                    : context.loc.generateActivity,
                style: context.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.textPrimary,
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.r16.dynamicW,
                vertical: Dimensions.r16.dynamicH,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(Dimensions.r20.dynamicW),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          context.primaryColor,
                          Color.lerp(context.primaryColor, Colors.black, 0.24)!,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(
                        Dimensions.r24.dynamicR,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.sports_score_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            SizedBox(width: Dimensions.r8.dynamicW),
                            Expanded(
                              child: Text(
                                'STEP 1 OF 2  ·  ACTIVITY DETAILS',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.86),
                                  fontSize: Dimensions.r11.dynamicSP,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Dimensions.r16.dynamicH),
                        Text(
                          'Bring your next game to life',
                          style: context.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: Dimensions.r6.dynamicH),
                        Text(
                          'Share the details. Find your people. Play together.',
                          style: context.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.84),
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: Dimensions.r16.dynamicH),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(
                            Dimensions.r999.dynamicR,
                          ),
                          child: const LinearProgressIndicator(
                            value: 0.5,
                            minHeight: 4,
                            backgroundColor: Color(0x55FFFFFF),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Dimensions.r24.dynamicH),

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(Dimensions.r16.dynamicW),
                    decoration: BoxDecoration(
                      color: context.surfaceColor,
                      borderRadius: BorderRadius.circular(
                        Dimensions.r20.dynamicR,
                      ),
                      border: Border.all(color: context.borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.loc.activityImages,
                          style: context.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: Dimensions.r4.dynamicH),
                        Text(
                          'Add a photo to help your activity stand out.',
                          style: context.bodySmall?.copyWith(
                            color: context.textSecondary,
                          ),
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
                                    ...spotToEdit!.images.map(
                                      (img) =>
                                          CreateSpotExistingImage(image: img),
                                    ),
                                  ...images.map(
                                    (file) => CreateSpotFileImage(
                                      file: file,
                                      onRemove: () {
                                        final updatedList = List<File>.from(
                                          formState.selectedImages.value,
                                        )..remove(file);
                                        formState.selectedImages.value =
                                            updatedList;
                                      },
                                    ),
                                  ),
                                  CreateSpotAddPhotoButton(onTap: onPickImages),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Dimensions.r24.dynamicH),

                  CreateSpotSectionTitle(title: 'Choose your game'),
                  SizedBox(height: Dimensions.r12.dynamicH),

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
                      if (categoryId != null &&
                          blocState is CreateSpotCategoriesLoaded) {
                        final cats = (blocState as CreateSpotCategoriesLoaded)
                            .categories;
                        final found = cats
                            .where((c) => c.id == categoryId)
                            .firstOrNull;
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
                  CreateSpotSectionTitle(title: 'Tell players about it'),
                  SizedBox(height: Dimensions.r12.dynamicH),
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
                    labelText: context.loc.description,
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
                    prefixIcon: Icon(
                      Icons.location_on_outlined,
                      color: context.textSecondary,
                    ),
                  ),
                  SizedBox(height: Dimensions.r24.dynamicH),

                  // 7. Date & Time
                  CreateSpotSectionTitle(title: 'Set the plan'),
                  SizedBox(height: Dimensions.r8.dynamicH),
                  CreateSpotSectionTitle(title: 'Date & Time *'),
                  SizedBox(height: Dimensions.r8.dynamicH),
                  CreateSpotDatetimeSelector(
                    dateNotifier: formState.eventDate,
                    timeNotifier: formState.eventTime,
                  ),
                  SizedBox(height: Dimensions.r32.dynamicH),

                  // 8. Participants
                  CreateSpotSectionTitle(
                    title: '${context.loc.maxParticipants} *',
                  ),
                  SizedBox(height: Dimensions.r8.dynamicH),
                  CreateSpotParticipantsSelector(
                    maxParticipantsNotifier: formState.maxParticipants,
                  ),
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
                              borderRadius: BorderRadius.circular(
                                Dimensions.r24.dynamicR,
                              ),
                              border: Border.all(color: context.borderColor),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => formState.isFree.value = true,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: Dimensions.r12.dynamicH,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isFree
                                            ? context.primaryColor
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(
                                          Dimensions.r24.dynamicR,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          context.loc.free,
                                          style: TextStyle(
                                            color: isFree
                                                ? Colors.white
                                                : context.textPrimary,
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
                                      padding: EdgeInsets.symmetric(
                                        vertical: Dimensions.r12.dynamicH,
                                      ),
                                      decoration: BoxDecoration(
                                        color: !isFree
                                            ? context.primaryColor
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(
                                          Dimensions.r24.dynamicR,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          context.loc.paid,
                                          style: TextStyle(
                                            color: !isFree
                                                ? Colors.white
                                                : context.textPrimary,
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
                                    padding: EdgeInsets.only(
                                      top: Dimensions.r24.dynamicH,
                                    ),
                                    child: AppTextField(
                                      controller: formState.priceController,
                                      labelText:
                                          '${context.loc.pricePerPerson} *',
                                      hintText: '₹ Enter amount',
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        CurrencyInputFormatter(),
                                      ],
                                    ),
                                  )
                                : const SizedBox(
                                    width: double.infinity,
                                    height: 0,
                                  ),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: Dimensions.r32.dynamicH),
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
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.fromLTRB(
            Dimensions.r16.dynamicW,
            Dimensions.r12.dynamicH,
            Dimensions.r16.dynamicW,
            Dimensions.r12.dynamicH,
          ),
          decoration: BoxDecoration(
            color: context.surfaceColor,
            border: Border(top: BorderSide(color: context.borderColor)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'READY WHEN YOU ARE',
                      style: context.labelSmall?.copyWith(
                        color: context.textSecondary,
                        letterSpacing: 0.7,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: Dimensions.r4.dynamicH),
                    Text(
                      'Preview before publishing',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.bodySmall?.copyWith(
                        color: context.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: Dimensions.r12.dynamicW),
              SizedBox(
                width: Dimensions.w(176),
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    minimumSize: Size(0, Dimensions.h52),
                  ),
                  onPressed: isLoading ? null : onPreview,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: Text(
                    context.loc.previewActivity,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
