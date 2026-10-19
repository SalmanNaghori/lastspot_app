import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../../core/base_import.dart';
import '../../../../core/utils/image_cropper_helper.dart';
import '../../domain/entities/user_profile.dart';
import '../bloc/profile_cubit.dart';
import '../../../cities/domain/entities/city_entity.dart';
import '../../../cities/presentation/bloc/city_cubit.dart';
import '../../../cities/presentation/bloc/city_state.dart';
import '../../../categories/domain/entities/category.dart';
import '../../../categories/presentation/bloc/category_bloc.dart';
import '../../../categories/presentation/bloc/category_event.dart';
import '../../../categories/presentation/bloc/category_state.dart';
import '../widgets/profile_step_indicator.dart';
import '../widgets/profile_details_step.dart';
import '../widgets/profile_city_step.dart';
import '../widgets/profile_sports_step.dart';
import '../widgets/profile_completion_step.dart';

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

  int _currentStep = 0;
  late String _userId;

  @override
  void initState() {
    super.initState();
    _userId = Supabase.instance.client.auth.currentUser!.id;
    final cityCubit = sl<CityCubit>();
    if (cityCubit.state is! CityLoaded) {
      cityCubit.fetchCities();
    }
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

  void _onToggleSport(String sport) {
    final sports = List<String>.from(_selectedSports.value);
    if (sports.contains(sport)) {
      sports.remove(sport);
    } else {
      sports.add(sport);
    }
    _selectedSports.value = sports;
  }

  void _goToNextStep() {
    if (_currentStep == 0) {
      final isValid = _formKey.currentState?.validate() ?? false;
      if (!isValid) return;
    } else if (_currentStep == 1) {
      if (_selectedCity.value == null) {
        AppUtils.showSnackBar(
          context,
          'Please select your city to continue',
          isError: true,
        );
        return;
      }
    } else if (_currentStep == 2) {
      if (_selectedSports.value.isEmpty) {
        AppUtils.showSnackBar(
          context,
          'Please select at least 1 sport to continue',
          isError: true,
        );
        return;
      }
    }

    if (_currentStep < 3) {
      setState(() => _currentStep++);
    }
  }

  void _goToPreviousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.of(context).maybePop();
    }
  }

  void _onSaveProfile(BuildContext context) {
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
      createdAt: DateTime.now(),
    );

    context.read<ProfileCubit>().saveProfile(
      profile: profile,
      avatarFile: _selectedAvatar.value,
    );
  }

  void _onAuthStateChanged(BuildContext context, AuthState state) {
    if (state is Authenticated) {
      context.go(AppRoutes.home);
    }
  }

  void _onProfileStateChanged(BuildContext context, ProfileState state) {
    if (state is ProfileSaved) {
      context.read<AuthBloc>().add(AuthProfileCompleted());
    } else if (state is ProfileError) {
      AppUtils.showSnackBar(context, state.message, isError: true);
    } else if (state is ProfileLoaded) {
      if (_nameController.text.isEmpty) {
        _nameController.text = state.profile.fullName ?? '';
      }
      if (_bioController.text.isEmpty) {
        _bioController.text = state.profile.bio ?? '';
      }
      if (_selectedCity.value == null &&
          state.profile.cityId != null &&
          state.profile.city != null) {
        _selectedCity.value = CityEntity(
          id: state.profile.cityId!,
          name: state.profile.city!,
        );
      }
      if (_selectedSports.value.isEmpty &&
          state.profile.sportsInterests.isNotEmpty) {
        _selectedSports.value = List.from(state.profile.sportsInterests);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<ProfileCubit>()..fetchProfile(_userId),
        ),
        BlocProvider(
          create: (context) => sl<CategoryBloc>()..add(LoadCategoriesEvent()),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(listener: _onAuthStateChanged),
          BlocListener<ProfileCubit, ProfileState>(
            listener: _onProfileStateChanged,
          ),
        ],
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, profileState) {
            return ResponsiveLayout(
              mobile: _buildContent(context, profileState, isTablet: false),
              tablet: _buildContent(context, profileState, isTablet: true),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ProfileState profileState, {
    required bool isTablet,
  }) {
    UserProfile? existingProfile;
    if (profileState is ProfileLoaded) {
      existingProfile = profileState.profile;
    }

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: AppTheme.systemUiOverlayStyle(context),
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: _goToPreviousStep,
              )
            : null,
        title: Text(
          _currentStep == 0
              ? 'Profile Setup'
              : (_currentStep == 1
                    ? 'Choose City'
                    : (_currentStep == 2 ? 'Choose Sports' : 'Completed')),
          style: TextStyle(
            fontSize: Dimensions.r18.dynamicSP,
            fontWeight: FontWeight.w800,
            color: context.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? 600 : double.infinity,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.r24.dynamicW,
                vertical: Dimensions.r12.dynamicH,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ProfileStepIndicator(
                    currentStep: _currentStep,
                    totalSteps: 4,
                  ),
                  SizedBox(height: Dimensions.r16.dynamicH),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: _buildCurrentStep(
                      context,
                      profileState,
                      existingProfile,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep(
    BuildContext context,
    ProfileState profileState,
    UserProfile? existingProfile,
  ) {
    switch (_currentStep) {
      case 0:
        return ProfileDetailsStep(
          key: const ValueKey('step_0'),
          formKey: _formKey,
          nameController: _nameController,
          bioController: _bioController,
          selectedAvatar: _selectedAvatar,
          existingProfile: existingProfile,
          onPickAvatar: _pickAvatar,
          onNext: _goToNextStep,
        );
      case 1:
        return BlocBuilder<CityCubit, CityState>(
          key: const ValueKey('step_1'),
          bloc: sl<CityCubit>(),
          builder: (context, cityState) {
            List<CityEntity> cities = [];
            bool isLoading = cityState is CityLoading;
            bool hasError = cityState is CityError;
            if (cityState is CityLoaded) {
              cities = cityState.cities;
            }

            return ProfileCityStep(
              cities: cities,
              selectedCity: _selectedCity,
              isLoading: isLoading,
              hasError: hasError,
              onRetry: () => sl<CityCubit>().fetchCities(),
              onNext: _goToNextStep,
            );
          },
        );
      case 2:
        return BlocBuilder<CategoryBloc, CategoryState>(
          key: const ValueKey('step_2'),
          builder: (context, catState) {
            List<CategoryEntity> categories = [];
            if (catState is CategoryLoaded) {
              categories = catState.categories;
            } else {
              // Fallback to active categories
              categories = const [
                CategoryEntity(
                  id: '1',
                  name: 'Cricket',
                  slug: 'cricket',
                  icon: 'sports_cricket',
                ),
                CategoryEntity(
                  id: '2',
                  name: 'Football',
                  slug: 'football',
                  icon: 'sports_soccer',
                ),
                CategoryEntity(
                  id: '3',
                  name: 'Volleyball',
                  slug: 'volleyball',
                  icon: 'sports_volleyball',
                ),
                CategoryEntity(
                  id: '4',
                  name: 'Badminton',
                  slug: 'badminton',
                  icon: 'sports_tennis',
                ),
                CategoryEntity(
                  id: '5',
                  name: 'Kabaddi',
                  slug: 'kabaddi',
                  icon: 'sports_kabaddi',
                ),
                CategoryEntity(
                  id: '6',
                  name: 'Kho-Kho',
                  slug: 'kho-kho',
                  icon: 'directions_run',
                ),
                CategoryEntity(
                  id: '7',
                  name: 'Gilli-Danda',
                  slug: 'gilli-danda',
                  icon: 'sports',
                ),
                CategoryEntity(
                  id: '8',
                  name: 'Satoliya / Lagori',
                  slug: 'satoliya',
                  icon: 'filter_hdr',
                ),
                CategoryEntity(
                  id: '9',
                  name: 'Kite Flying',
                  slug: 'kite-flying',
                  icon: 'air',
                ),
                CategoryEntity(
                  id: '10',
                  name: 'Cycling',
                  slug: 'cycling',
                  icon: 'directions_bike',
                ),
                CategoryEntity(
                  id: '11',
                  name: 'Running',
                  slug: 'running',
                  icon: 'directions_run',
                ),
                CategoryEntity(
                  id: '12',
                  name: 'Tennis',
                  slug: 'tennis',
                  icon: 'sports_tennis',
                ),
                CategoryEntity(
                  id: '13',
                  name: 'Basketball',
                  slug: 'basketball',
                  icon: 'sports_basketball',
                ),
                CategoryEntity(
                  id: '14',
                  name: 'Skating',
                  slug: 'skating',
                  icon: 'ice_skating',
                ),
                CategoryEntity(
                  id: '15',
                  name: 'Hockey',
                  slug: 'hockey',
                  icon: 'sports_hockey',
                ),
                CategoryEntity(
                  id: '16',
                  name: 'Ultimate Frisbee',
                  slug: 'ultimate-frisbee',
                  icon: 'album',
                ),
                CategoryEntity(
                  id: '17',
                  name: 'Pickleball',
                  slug: 'pickleball',
                  icon: 'sports_tennis',
                ),
                CategoryEntity(
                  id: '18',
                  name: 'Tug of War',
                  slug: 'tug-of-war',
                  icon: 'group_work',
                ),
                CategoryEntity(
                  id: '19',
                  name: 'Hiking / Trekking',
                  slug: 'hiking',
                  icon: 'hiking',
                ),
                CategoryEntity(
                  id: '20',
                  name: 'Outdoor Yoga',
                  slug: 'outdoor-yoga',
                  icon: 'self_improvement',
                ),
                CategoryEntity(
                  id: '21',
                  name: 'Ride Sharing',
                  slug: 'ride_sharing',
                  icon: 'directions_car',
                ),
                CategoryEntity(
                  id: '22',
                  name: 'Events',
                  slug: 'events',
                  icon: 'celebration',
                ),
                CategoryEntity(
                  id: '23',
                  name: 'Other',
                  slug: 'other',
                  icon: 'sports',
                ),
              ];
            }

            return ProfileSportsStep(
              categories: categories,
              selectedSports: _selectedSports,
              onToggleSport: _onToggleSport,
              onNext: _goToNextStep,
            );
          },
        );
      case 3:
      default:
        return ProfileCompletionStep(
          key: const ValueKey('step_3'),
          fullName: _nameController.text.trim().isNotEmpty
              ? _nameController.text.trim()
              : (existingProfile?.fullName ?? 'Player'),
          selectedCity: _selectedCity.value,
          selectedSports: _selectedSports.value,
          selectedAvatar: _selectedAvatar.value,
          existingProfile: existingProfile,
          isLoading: profileState is ProfileLoading,
          onEnterApp: () => _onSaveProfile(context),
        );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _selectedCity.dispose();
    _selectedAvatar.dispose();
    _selectedSports.dispose();
    super.dispose();
  }
}
