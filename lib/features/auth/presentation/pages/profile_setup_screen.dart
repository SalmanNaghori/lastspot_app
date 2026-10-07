import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/base_import.dart';
import '../../../../core/utils/image_cropper_helper.dart';
import '../../../../core/di/service_locator.dart';
import '../../domain/entities/user_profile.dart';
import '../bloc/profile_cubit.dart';
import 'package:lastspot_app/core/widgets/selection_bottom_sheet.dart';
import '../../../cities/domain/entities/city_entity.dart';
import '../../../cities/presentation/bloc/city_cubit.dart';
import '../../../cities/presentation/bloc/city_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final ValueNotifier<CityEntity?> _selectedCity = ValueNotifier(null);
  final ValueNotifier<File?> _selectedAvatar = ValueNotifier(null);
  final ValueNotifier<List<String>> _selectedSports = ValueNotifier([]);
  final ValueNotifier<bool> _showCityError = ValueNotifier(false);

  late String _userId;

  @override
  void initState() {
    super.initState();
    _userId = Supabase.instance.client.auth.currentUser!.id;
  }

  Future<void> _pickAvatar() async {
    final file = await ImageCropperHelper.pickCropAndCompressImage(
      context: context,
      source: ImageSource.gallery,
    );
    if (file != null) {
      _selectedAvatar.value = file;
    }
  }

  void _onCityTap() async {
    final cityCubit = sl<CityCubit>();
    if (cityCubit.state is! CityLoaded) {
      await cityCubit.fetchCities();
    }

    if (!mounted) return;

    final state = cityCubit.state;
    List<CityEntity> cities = [];
    bool hasError = false;
    bool isLoading = false;

    if (state is CityLoaded) {
      cities = state.cities;
    } else if (state is CityError) {
      hasError = true;
    } else {
      isLoading = true;
    }

    final city = await SelectionBottomSheet.show<CityEntity>(
      context,
      title: context.loc.selectCity,
      searchHint: 'Search city...',
      items: cities,
      itemText: (city) => city.name,
      onSearch: (city, query) => city.name.toLowerCase().contains(query),
      selectedItem: _selectedCity.value,
      isLoading: isLoading,
      hasError: hasError,
      onRetry: () => cityCubit.fetchCities(),
      leadingIcon: (city) =>
          Icon(Icons.location_on, color: context.textSecondary),
    );

    if (city != null) {
      _selectedCity.value = city;
      _showCityError.value = false;
    }
  }

  void _onSave(BuildContext context) {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (_selectedCity.value == null) {
      _showCityError.value = true;
    }

    if (isValid && _selectedCity.value != null) {
      final currentState = context.read<ProfileCubit>().state;
      String? existingAvatarUrl;
      String? existingEmail;

      if (currentState is ProfileLoaded) {
        existingAvatarUrl = currentState.profile.avatarUrl;
        existingEmail = currentState.profile.email;
      }

      final profile = UserProfile(
        id: _userId,
        fullName: _nameController.text.trim(),
        bio: _bioController.text.trim(),
        city: _selectedCity.value?.name,
        cityId: _selectedCity.value?.id,
        email: existingEmail,
        avatarUrl: existingAvatarUrl,
        sportsInterests: _selectedSports.value,
        createdAt: DateTime.now(), // Will be ignored by update if exists
      );

      context.read<ProfileCubit>().saveProfile(
        profile: profile,
        avatarFile: _selectedAvatar.value,
      );
    }
  }

  void _toggleSport(String sport) {
    final sports = List<String>.from(_selectedSports.value);
    if (sports.contains(sport)) {
      sports.remove(sport);
    } else {
      sports.add(sport);
    }
    _selectedSports.value = sports;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileCubit>()..fetchProfile(_userId),
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileSaved) {
            context.go(AppRoutes.home);
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is ProfileLoaded) {
            _nameController.text = state.profile.fullName ?? '';
            _bioController.text = state.profile.bio ?? '';
            if (state.profile.cityId != null && state.profile.city != null) {
              _selectedCity.value = CityEntity(
                id: state.profile.cityId!,
                name: state.profile.city!,
              );
            }
            _selectedSports.value = List.from(state.profile.sportsInterests);
          }
        },
        builder: (context, state) {
          return ResponsiveLayout(
            mobile: _buildContent(context, state),
            tablet: _buildContent(context, state),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, ProfileState state) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        title: Text(context.loc.setupProfile),
        backgroundColor: context.backgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Skeletonizer(
          enabled: state is ProfileLoading && _nameController.text.isEmpty,
          child: SingleChildScrollView(
                padding: const EdgeInsets.all(Dimensions.r24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: _pickAvatar,
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              ValueListenableBuilder<File?>(
                                valueListenable: _selectedAvatar,
                                builder: (context, selectedAvatar, _) {
                                  return CircleAvatar(
                                    radius: 60,
                                    backgroundColor: context.surfaceColor,
                                    backgroundImage: selectedAvatar != null
                                        ? FileImage(selectedAvatar)
                                        : (state is ProfileLoaded &&
                                              state.profile.avatarUrl != null &&
                                              state.profile.avatarUrl!.isNotEmpty)
                                        ? NetworkImage(
                                                state.profile.avatarUrl!.replaceAll(
                                                  '/svg?',
                                                  '/png?',
                                                ),
                                              )
                                              as ImageProvider
                                        : null,
                                    child:
                                        selectedAvatar == null &&
                                            (state is! ProfileLoaded ||
                                                state.profile.avatarUrl == null ||
                                                state.profile.avatarUrl!.isEmpty)
                                        ? Icon(
                                            Icons.person,
                                            size: 60,
                                            color: context.textSecondary,
                                          )
                                        : null,
                                  );
                                },
                              ),
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: AppColor.primaryColor,
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: AppColor.whiteColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: Dimensions.r32),
                      AppTextField(
                        controller: _nameController,
                        labelText: context.loc.fullName,
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return context.loc.fullNameRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: Dimensions.r16),
                      AppTextField(
                        controller: _bioController,
                        labelText: context.loc.bioOptional,
                        maxLines: 3,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      const SizedBox(height: Dimensions.r16),
                      // City Picker
                      ValueListenableBuilder<bool>(
                        valueListenable: _showCityError,
                        builder: (context, showError, _) {
                          return ValueListenableBuilder<CityEntity?>(
                            valueListenable: _selectedCity,
                            builder: (context, selectedCity, _) {
                              return AppTextField(
                                labelText: context.loc.cityLabel,
                                hintText: selectedCity?.name ?? context.loc.selectCityHint,
                                readOnly: true,
                                onTap: _onCityTap,
                                errorText: showError && selectedCity == null
                                    ? context.loc.cityRequiredError
                                    : null,
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: Dimensions.r24),
                      Text(
                        context.loc.sportsPreferences,
                        style: TextStyle(
                          fontSize: Dimensions.r16,
                          fontWeight: FontWeight.bold,
                          color: context.textPrimary,
                        ),
                      ),
                      const SizedBox(height: Dimensions.r12),
                      ValueListenableBuilder<List<String>>(
                        valueListenable: _selectedSports,
                        builder: (context, selectedSports, _) {
                          return Wrap(
                            spacing: Dimensions.r8,
                            runSpacing: Dimensions.r8,
                            children: AppConstants.getAvailableSports(context).map((sport) {
                              final isSelected = selectedSports.contains(sport);
                              return ChoiceChip(
                                label: Text(sport),
                                selected: isSelected,
                                onSelected: (_) => _toggleSport(sport),
                                selectedColor: AppColor.primaryColor.withValues(
                                  alpha: 0.2,
                                ),
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? AppColor.primaryColor
                                      : context.textSecondary,
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                      const SizedBox(height: Dimensions.r48),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryColor,
                          foregroundColor: AppColor.whiteColor,
                          padding: const EdgeInsets.symmetric(
                            vertical: Dimensions.r16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Dimensions.r12),
                          ),
                        ),
                        onPressed: state is ProfileLoading
                            ? null
                            : () => _onSave(context),
                        child: state is ProfileLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColor.whiteColor,
                                ),
                              )
                            : Text(context.loc.saveAndContinue),
                      ),
                    ],
                  ),
                ),
              ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _selectedCity.dispose();
    _selectedAvatar.dispose();
    _selectedSports.dispose();
    _showCityError.dispose();
    super.dispose();
  }
}
