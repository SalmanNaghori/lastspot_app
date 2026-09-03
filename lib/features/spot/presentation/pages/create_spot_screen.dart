import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:lastspot_app/core/base_import.dart';
import '../bloc/create_spot_bloc.dart';

class CreateSpotScreen extends StatefulWidget {
  const CreateSpotScreen({super.key});

  @override
  State<CreateSpotScreen> createState() => _CreateSpotScreenState();
}

class _CreateSpotScreenState extends State<CreateSpotScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController(text: '0.0');

  String? _selectedCategoryId;
  int _maxParticipants = 2;
  DateTime _eventDate = DateTime.now();
  TimeOfDay _eventTime = TimeOfDay.now();
  final List<File> _selectedImages = [];

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(pickedFiles.map((pf) => File(pf.path)));
      });
    }
  }

  void _submit() {
    if (_titleController.text.isEmpty || _locationController.text.isEmpty || _selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.loc.validationTitleLocationCategory)));
      return;
    }

    final matchDateTime = DateTime(
      _eventDate.year,
      _eventDate.month,
      _eventDate.day,
      _eventTime.hour,
      _eventTime.minute,
    );

    final event = SubmitSpotEvent(
      categoryId: _selectedCategoryId!,
      title: _titleController.text,
      description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
      locationName: _locationController.text,
      eventDateTime: matchDateTime,
      maxParticipants: _maxParticipants,
      pricePerPerson: double.tryParse(_priceController.text) ?? 0.0,
      images: _selectedImages,
    );

    context.read<CreateSpotBloc>().add(event);
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
              context.loc.generateActivity,
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
                        child: ListView(
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
                            ..._selectedImages.map(
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
                                        setState(() => _selectedImages.remove(file));
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
                        ),
                      ),
                      SizedBox(height: Dimensions.r24.dynamicH),

                      // Category
                      Text(
                        context.loc.category,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: Dimensions.r8.dynamicH),
                      if (state is CreateSpotCategoriesLoaded)
                        DropdownButtonFormField<String>(
                          value: _selectedCategoryId,
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
                            if (val != null) setState(() => _selectedCategoryId = val);
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
                        label: context.loc.activityTitle,
                        hint: context.loc.activityTitleHint,
                      ),
                      SizedBox(height: Dimensions.r16.dynamicH),

                      AppTextField(
                        controller: _descriptionController,
                        label: context.loc.description,
                        hint: context.loc.descriptionHint,
                        maxLines: 3,
                      ),
                      SizedBox(height: Dimensions.r16.dynamicH),

                      AppTextField(
                        controller: _locationController,
                        label: context.loc.location,
                        hint: context.loc.locationHint,
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
                                GestureDetector(
                                  onTap: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: _eventDate,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now().add(const Duration(days: 90)),
                                    );
                                    if (date != null) setState(() => _eventDate = date);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(Dimensions.r16.dynamicW),
                                    decoration: BoxDecoration(
                                      color: context.surfaceColor,
                                      borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
                                    ),
                                    child: Text('${_eventDate.day}/${_eventDate.month}/${_eventDate.year}'),
                                  ),
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
                                GestureDetector(
                                  onTap: () async {
                                    final time = await showTimePicker(context: context, initialTime: _eventTime);
                                    if (time != null) setState(() => _eventTime = time);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(Dimensions.r16.dynamicW),
                                    decoration: BoxDecoration(
                                      color: context.surfaceColor,
                                      borderRadius: BorderRadius.circular(Dimensions.r12.dynamicR),
                                    ),
                                    child: Text(_eventTime.format(context)),
                                  ),
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
                                Container(
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
                                          if (_maxParticipants > 2) setState(() => _maxParticipants--);
                                        },
                                      ),
                                      Text('$_maxParticipants', style: Theme.of(context).textTheme.titleMedium),
                                      IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () => setState(() => _maxParticipants++),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: Dimensions.r16.dynamicW),
                          Expanded(
                            child: AppTextField(
                              controller: _priceController,
                              label: AppLocalizations.of(context)!.pricePerPerson,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: Dimensions.r48.dynamicH),

                      AppButton(label: context.loc.generateActivity, onPressed: _submit, isFullWidth: true),
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
