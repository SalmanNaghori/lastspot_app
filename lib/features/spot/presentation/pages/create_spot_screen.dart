import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:lastspot_app/core/base_import.dart';
import '../bloc/create_spot_bloc.dart';
import '../../../cities/domain/entities/city_entity.dart';
import '../../../auth/presentation/widgets/city_picker_bottom_sheet.dart';

import '../../domain/entities/request_entity.dart';

class CreateSpotScreen extends StatefulWidget {
  final RequestEntity? spotToEdit;
  
  const CreateSpotScreen({super.key, this.spotToEdit});

  @override
  State<CreateSpotScreen> createState() => _CreateSpotScreenState();
}

class _CreateSpotScreenState extends State<CreateSpotScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController(text: '0.0');

  final ValueNotifier<String?> _selectedCategoryId = ValueNotifier(null);
  final ValueNotifier<CityEntity?> _selectedCity = ValueNotifier(null);
  final ValueNotifier<int> _maxParticipants = ValueNotifier(2);
  final ValueNotifier<DateTime> _eventDate = ValueNotifier(DateTime.now());
  final ValueNotifier<TimeOfDay> _eventTime = ValueNotifier(TimeOfDay.now());
  final ValueNotifier<List<File>> _selectedImages = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    if (widget.spotToEdit != null) {
      final spot = widget.spotToEdit!;
      _titleController.text = spot.title;
      _descriptionController.text = spot.description ?? '';
      _locationController.text = spot.locationName;
      _priceController.text = spot.pricePerPerson.toString();
      _selectedCategoryId.value = spot.categoryId;
      if (spot.cityId != null) {
        _selectedCity.value = CityEntity(id: spot.cityId!, name: 'Current City');
      }
      _maxParticipants.value = spot.maxParticipants;
      _eventDate.value = spot.eventDateTime;
      _eventTime.value = TimeOfDay.fromDateTime(spot.eventDateTime);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _selectedCategoryId.dispose();
    _selectedCity.dispose();
    _maxParticipants.dispose();
    _eventDate.dispose();
    _eventTime.dispose();
    _selectedImages.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      final updatedList = List<File>.from(_selectedImages.value)..addAll(pickedFiles.map((pf) => File(pf.path)));
      _selectedImages.value = updatedList;
    }
  }

  void _submit() {
    if (_titleController.text.isEmpty || _locationController.text.isEmpty || _selectedCategoryId.value == null || _selectedCity.value == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.loc.validationTitleLocationCategory)));
      return;
    }

    final matchDateTime = DateTime(
      _eventDate.value.year,
      _eventDate.value.month,
      _eventDate.value.day,
      _eventTime.value.hour,
      _eventTime.value.minute,
    );

    if (widget.spotToEdit != null) {
      final updateEvent = UpdateSpotEvent(
        spotId: widget.spotToEdit!.id,
        categoryId: _selectedCategoryId.value,
        cityId: _selectedCity.value?.id,
        title: _titleController.text,
        description: _descriptionController.text,
        locationName: _locationController.text,
        eventDateTime: matchDateTime,
        maxParticipants: _maxParticipants.value,
        pricePerPerson: double.tryParse(_priceController.text),
      );
      context.read<CreateSpotBloc>().add(updateEvent);
    } else {
      final event = SubmitSpotEvent(
        categoryId: _selectedCategoryId.value!,
        cityId: _selectedCity.value!.id,
        title: _titleController.text,
        description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
        locationName: _locationController.text,
        eventDateTime: matchDateTime,
        maxParticipants: _maxParticipants.value,
        pricePerPerson: double.tryParse(_priceController.text) ?? 0.0,
        images: _selectedImages.value,
      );
      context.read<CreateSpotBloc>().add(event);
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = BlocConsumer<CreateSpotBloc, CreateSpotState>(
      listener: (context, state) {
        if (state is CreateSpotSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.loc.activityGeneratedSuccess)));
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(AppRoutes.home); // Go to home tab on success
          }
        } else if (state is CreateSpotError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        bool isLoading = state is CreateSpotLoading || state is CreateSpotCategoriesLoading;

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
              widget.spotToEdit != null ? context.loc.edit : context.loc.generateActivity,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: context.textPrimary),
            ),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.all(Dimensions.r16.dynamicW),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Images
                      Text(
                        context.loc.activityImages,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: Dimensions.r8.dynamicH),
                      SizedBox(
                        height: 100.0.dynamicH,
                        child: ValueListenableBuilder<List<File>>(
                          valueListenable: _selectedImages,
                          builder: (context, images, _) {
                            return ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                GestureDetector(
                                  onTap: _pickImages,
                                  child: Container(
                                    width: 100.0.dynamicW,
                                    margin: EdgeInsets.only(right: Dimensions.r12.dynamicW),
                                    decoration: BoxDecoration(
                                      color: context.surfaceColor,
                                      border: Border.all(color: context.borderColor),
                                      borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
                                    ),
                                  child: Center(child: Icon(Icons.add_a_photo, color: context.textSecondary)),
                                    ),
                                  ),
                                  if (widget.spotToEdit != null)
                                    ...widget.spotToEdit!.images.map(
                                      (img) => Stack(
                                        children: [
                                          Container(
                                            width: 100.0.dynamicW,
                                            height: double.infinity,
                                            margin: EdgeInsets.only(right: Dimensions.r12.dynamicW),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
                                              child: AppCachedNetworkImage(
                                                imageUrl: img.storagePath,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 4,
                                            right: 16,
                                            child: GestureDetector(
                                              onTap: () {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(content: Text(context.loc.deleteImageNotSupported)),
                                                );
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(2),
                                                decoration: const BoxDecoration(
                                                  color: Colors.black54,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(Icons.close, size: 16, color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ...images.map(
                                  (file) => Stack(
                                    children: [
                                      Container(
                                        width: 100.0.dynamicW,
                                        margin: EdgeInsets.only(right: Dimensions.r12.dynamicW),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
                                          image: DecorationImage(image: FileImage(file), fit: BoxFit.cover),
                                        ),
                                      ),
                                      Positioned(
                                        top: 4,
                                        right: 16,
                                        child: GestureDetector(
                                          onTap: () {
                                            final updatedList = List<File>.from(_selectedImages.value)..remove(file);
                                            _selectedImages.value = updatedList;
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                                            child: const Icon(Icons.close, size: 16, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: Dimensions.r24.dynamicH),

                      // City
                      Text(
                        context.loc.city,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: Dimensions.r8.dynamicH),
                      ValueListenableBuilder<CityEntity?>(
                        valueListenable: _selectedCity,
                        builder: (context, city, _) {
                          return GestureDetector(
                            onTap: () async {
                              final selected = await CityPickerBottomSheet.show(context, selectedCity: city);
                              if (selected != null) _selectedCity.value = selected;
                            },
                            child: Container(
                              padding: EdgeInsets.all(Dimensions.r16.dynamicW),
                              decoration: BoxDecoration(
                                color: context.surfaceColor,
                                borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    city?.name ?? context.loc.selectCity,
                                    style: TextStyle(
                                      fontSize: Dimensions.r16.dynamicSP,
                                      color: city == null ? context.textSecondary : context.textPrimary,
                                    ),
                                  ),
                                  Icon(Icons.arrow_drop_down, color: context.textSecondary),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: Dimensions.r24.dynamicH),

                      // Category
                      Text(
                        context.loc.category,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: Dimensions.r8.dynamicH),
                      if (state is CreateSpotCategoriesLoaded)
                        ValueListenableBuilder<String?>(
                          valueListenable: _selectedCategoryId,
                          builder: (context, categoryId, _) {
                            return DropdownButtonFormField<String>(
                              initialValue: categoryId,
                              hint: Text(context.loc.selectCategory),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: context.surfaceColor,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              items: state.categories.map((cat) {
                                return DropdownMenuItem<String>(value: cat.id, child: Text(cat.name));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) _selectedCategoryId.value = val;
                              },
                            );
                          },
                        )
                      else if (state is CreateSpotCategoriesLoading)
                        const CircularProgressIndicator()
                      else
                        Text(context.loc.failedToLoadCategories),

                      SizedBox(height: Dimensions.r24.dynamicH),

                      // Basic Details
                      AppTextField(
                        controller: _titleController,
                        labelText: context.loc.activityTitle,
                        hintText: context.loc.activityTitleHint,
                      ),
                      SizedBox(height: Dimensions.r16.dynamicH),

                      AppTextField(
                        controller: _descriptionController,
                        labelText: context.loc.description,
                        hintText: context.loc.descriptionHint,
                        maxLines: 3,
                      ),
                      SizedBox(height: Dimensions.r16.dynamicH),

                      AppTextField(
                        controller: _locationController,
                        labelText: context.loc.location,
                        hintText: context.loc.locationHint,
                      ),
                      SizedBox(height: Dimensions.r24.dynamicH),

                      // Date & Time
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(context.loc.date, style: Theme.of(context).textTheme.titleSmall),
                                SizedBox(height: Dimensions.r8.dynamicH),
                                ValueListenableBuilder<DateTime>(
                                  valueListenable: _eventDate,
                                  builder: (context, date, _) {
                                    return GestureDetector(
                                      onTap: () async {
                                        final newDate = await showDatePicker(
                                          context: context,
                                          initialDate: date,
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.now().add(const Duration(days: 90)),
                                        );
                                        if (newDate != null) _eventDate.value = newDate;
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(Dimensions.r16.dynamicW),
                                        decoration: BoxDecoration(
                                          color: context.surfaceColor,
                                          borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
                                        ),
                                        child: Text('${date.day}/${date.month}/${date.year}'),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: Dimensions.r16.dynamicW),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(context.loc.time, style: Theme.of(context).textTheme.titleSmall),
                                SizedBox(height: Dimensions.r8.dynamicH),
                                ValueListenableBuilder<TimeOfDay>(
                                  valueListenable: _eventTime,
                                  builder: (context, time, _) {
                                    return GestureDetector(
                                      onTap: () async {
                                        final newTime = await showTimePicker(context: context, initialTime: time);
                                        if (newTime != null) _eventTime.value = newTime;
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(Dimensions.r16.dynamicW),
                                        decoration: BoxDecoration(
                                          color: context.surfaceColor,
                                          borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
                                        ),
                                        child: Text(time.format(context)),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.r24.dynamicH),

                      // Participants and Price
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(context.loc.maxParticipants, style: Theme.of(context).textTheme.titleSmall),
                                SizedBox(height: Dimensions.r8.dynamicH),
                                ValueListenableBuilder<int>(
                                  valueListenable: _maxParticipants,
                                  builder: (context, maxParticipants, _) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: Dimensions.r8.dynamicW,
                                        vertical: Dimensions.r4.dynamicH,
                                      ),
                                      decoration: BoxDecoration(
                                        color: context.surfaceColor,
                                        borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.remove),
                                            onPressed: () {
                                              if (maxParticipants > 2) _maxParticipants.value = maxParticipants - 1;
                                            },
                                          ),
                                          Text('$maxParticipants', style: Theme.of(context).textTheme.titleMedium),
                                          IconButton(
                                            icon: const Icon(Icons.add),
                                            onPressed: () => _maxParticipants.value = maxParticipants + 1,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: Dimensions.r16.dynamicW),
                          Expanded(
                            child: AppTextField(
                              controller: _priceController,
                              labelText: AppLocalizations.of(context)!.pricePerPerson,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: Dimensions.r48.dynamicH),

                      AppButton(
                        label: widget.spotToEdit != null ? context.loc.edit : context.loc.generateActivity, 
                        onPressed: _submit, 
                        isFullWidth: true,
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
        );
      },
    );

    return ResponsiveLayout(mobile: content, tablet: content);
  }
}
