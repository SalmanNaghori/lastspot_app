import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/core/utils/image_cropper_helper.dart';
import 'package:lastspot_app/core/di/service_locator.dart';
import 'package:lastspot_app/features/auth/domain/entities/user_profile.dart';
import 'package:lastspot_app/features/auth/presentation/bloc/profile_cubit.dart';
import 'package:lastspot_app/core/widgets/selection_bottom_sheet.dart';
import 'package:lastspot_app/features/cities/domain/entities/city_entity.dart';
import 'package:lastspot_app/features/cities/presentation/bloc/city_cubit.dart';
import 'package:lastspot_app/features/cities/presentation/bloc/city_state.dart';
import '../widgets/edit_profile_content.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _emailController = TextEditingController();
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
            context.pop(state.profile);
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
            _emailController.text = state.profile.email ?? '';
            _selectedSports.value = List.from(state.profile.sportsInterests);
          }
        },
        builder: (context, state) {
          return ResponsiveLayout(
            mobile: EditProfileContent(
              state: state,
              formKey: _formKey,
              nameController: _nameController,
              bioController: _bioController,
              emailController: _emailController,
              selectedCity: _selectedCity,
              selectedAvatar: _selectedAvatar,
              selectedSports: _selectedSports,
              showCityError: _showCityError,
              onPickAvatar: _pickAvatar,
              onCityTap: _onCityTap,
              onSave: () => _onSave(context),
              onToggleSport: _toggleSport,
            ),
            tablet: EditProfileContent(
              state: state,
              formKey: _formKey,
              nameController: _nameController,
              bioController: _bioController,
              emailController: _emailController,
              selectedCity: _selectedCity,
              selectedAvatar: _selectedAvatar,
              selectedSports: _selectedSports,
              showCityError: _showCityError,
              onPickAvatar: _pickAvatar,
              onCityTap: _onCityTap,
              onSave: () => _onSave(context),
              onToggleSport: _toggleSport,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _emailController.dispose();
    _selectedCity.dispose();
    _selectedAvatar.dispose();
    _selectedSports.dispose();
    _showCityError.dispose();
    super.dispose();
  }
}
