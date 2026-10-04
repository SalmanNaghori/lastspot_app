import 'dart:io';
import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/core/services/image_service.dart';
import 'package:lastspot_app/core/di/service_locator.dart';
import '../bloc/create_spot_bloc.dart';
import '../../../cities/domain/entities/city_entity.dart';
import '../../domain/entities/request_entity.dart';
import 'create_spot_screen_mobile.dart';
import 'create_spot_screen_tablet.dart';

class CreateSpotFormState {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final ValueNotifier<String?> selectedCategoryId = ValueNotifier(null);
  final ValueNotifier<CityEntity?> selectedCity = ValueNotifier(null);
  final ValueNotifier<int> maxParticipants = ValueNotifier(1);
  final ValueNotifier<DateTime> eventDate = ValueNotifier(DateTime.now());
  final ValueNotifier<TimeOfDay> eventTime = ValueNotifier(TimeOfDay.now());
  final ValueNotifier<List<File>> selectedImages = ValueNotifier([]);
  final ValueNotifier<bool> isFree = ValueNotifier(true);

  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    locationController.dispose();
    priceController.dispose();
    selectedCategoryId.dispose();
    selectedCity.dispose();
    maxParticipants.dispose();
    eventDate.dispose();
    eventTime.dispose();
    selectedImages.dispose();
    isFree.dispose();
  }
}

class CreateSpotScreen extends StatefulWidget {
  final RequestEntity? spotToEdit;

  const CreateSpotScreen({super.key, this.spotToEdit});

  @override
  State<CreateSpotScreen> createState() => _CreateSpotScreenState();
}

class _CreateSpotScreenState extends State<CreateSpotScreen> {
  final CreateSpotFormState _formState = CreateSpotFormState();

  @override
  void initState() {
    super.initState();
    if (widget.spotToEdit != null) {
      final spot = widget.spotToEdit!;
      _formState.titleController.text = spot.title;
      _formState.descriptionController.text = spot.description ?? '';
      _formState.locationController.text = spot.locationName;

      if (spot.pricePerPerson == 0) {
        _formState.isFree.value = true;
        _formState.priceController.text = '';
      } else {
        _formState.isFree.value = false;
        _formState.priceController.text = spot.pricePerPerson
            .toInt()
            .toString(); // Will be formatted by formatter
      }

      _formState.selectedCategoryId.value = spot.categoryId;
      if (spot.cityId != null) {
        _formState.selectedCity.value = CityEntity(
          id: spot.cityId!,
          name: 'Current City',
        );
      }
      _formState.maxParticipants.value = spot.maxParticipants;
      _formState.eventDate.value = spot.eventDateTime;
      _formState.eventTime.value = TimeOfDay.fromDateTime(spot.eventDateTime);
    }
  }

  @override
  void dispose() {
    _formState.dispose();
    super.dispose();
  }

  bool _isPickingImages = false;

  Future<void> _pickImages() async {
    if (_isPickingImages) return;

    _isPickingImages = true;
    try {
      final imageService = sl<ImageService>();
      final compressedFiles = await imageService
          .pickAndCompressMultipleImages();
      if (compressedFiles.isNotEmpty) {
        final updatedList = List<File>.from(_formState.selectedImages.value)
          ..addAll(compressedFiles);
        _formState.selectedImages.value = updatedList;
      }
    } finally {
      _isPickingImages = false;
    }
  }

  void _onPreview() {
    if (_formState.titleController.text.isEmpty ||
        _formState.locationController.text.isEmpty ||
        _formState.selectedCategoryId.value == null ||
        _formState.selectedCity.value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.loc.validationTitleLocationCategory)),
      );
      return;
    }

    if (!_formState.isFree.value && _formState.priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.loc.pleaseEnterValidPrice)),
      );
      return;
    }

    final bloc = context.read<CreateSpotBloc>();

    context.push(
      AppRoutes.previewSpot,
      extra: {
        'bloc': bloc,
        'formState': _formState,
        'spotToEdit': widget.spotToEdit,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateSpotBloc, CreateSpotState>(
      listener: (context, state) {
        if (state is CreateSpotSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.loc.activityGeneratedSuccess)),
          );
          if (context.canPop()) {
            context.pop();
          } else {
            context.go(AppRoutes.home); // Go to home tab on success
          }
        } else if (state is CreateSpotError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final isLoading =
            state is CreateSpotLoading || state is CreateSpotCategoriesLoading;

        return ResponsiveLayout(
          mobile: CreateSpotScreenMobile(
            formState: _formState,
            spotToEdit: widget.spotToEdit,
            isLoading: isLoading,
            onPickImages: _pickImages,
            onPreview: _onPreview,
            blocState: state,
          ),
          tablet: CreateSpotScreenTablet(
            formState: _formState,
            spotToEdit: widget.spotToEdit,
            isLoading: isLoading,
            onPickImages: _pickImages,
            onPreview: _onPreview,
            blocState: state,
          ),
        );
      },
    );
  }
}
