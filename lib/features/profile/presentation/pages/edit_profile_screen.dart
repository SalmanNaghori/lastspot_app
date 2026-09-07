import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/core/utils/image_cropper_helper.dart';
import 'package:lastspot_app/core/di/service_locator.dart';
import 'package:lastspot_app/features/auth/domain/entities/user_profile.dart';
import 'package:lastspot_app/features/auth/presentation/bloc/profile_cubit.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _cityController = TextEditingController();
  final _emailController = TextEditingController();
  File? _selectedAvatar;
  List<String> _selectedSports = [];

  final List<String> _availableSports = [
    'Soccer',
    'Basketball',
    'Tennis',
    'Volleyball',
    'Badminton',
    'Table Tennis',
    'Cricket',
    'Swimming',
    'Running',
    'Cycling',
  ];

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
      setState(() {
        _selectedAvatar = file;
      });
    }
  }

  void _onSave(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
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
        city: _cityController.text.trim(),
        email: existingEmail,
        avatarUrl: existingAvatarUrl,
        sportsInterests: _selectedSports,
        createdAt: DateTime.now(), // Will be ignored by update if exists
      );

      context.read<ProfileCubit>().saveProfile(
        profile: profile,
        avatarFile: _selectedAvatar,
      );
    }
  }

  void _toggleSport(String sport) {
    setState(() {
      if (_selectedSports.contains(sport)) {
        _selectedSports.remove(sport);
      } else {
        _selectedSports.add(sport);
      }
    });
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
            _cityController.text = state.profile.city ?? '';
            _emailController.text = state.profile.email ?? '';
            _selectedSports = List.from(state.profile.sportsInterests);
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
        title: Text(context.loc.editProfile),
        backgroundColor: context.backgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: state is ProfileLoading && _nameController.text.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
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
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: context.surfaceColor,
                                backgroundImage: _selectedAvatar != null
                                    ? FileImage(_selectedAvatar!)
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
                                    _selectedAvatar == null &&
                                        (state is! ProfileLoaded ||
                                            state.profile.avatarUrl == null ||
                                            state.profile.avatarUrl!.isEmpty)
                                    ? Icon(
                                        Icons.person,
                                        size: 60,
                                        color: context.textSecondary,
                                      )
                                    : null,
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
                        labelText: context.loc.email,
                        controller: _emailController,
                        readOnly: true,
                        hintText: '',
                      ),
                      const SizedBox(height: Dimensions.r16),
                      AppTextField(
                        controller: _bioController,
                        labelText: context.loc.bioOptional,
                        maxLines: 3,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      const SizedBox(height: Dimensions.r16),
                      AppTextField(
                        controller: _cityController,
                        labelText: context.loc.cityLabel,
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return context.loc.cityIsRequired;
                          }
                          return null;
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
                      Wrap(
                        spacing: Dimensions.r8,
                        runSpacing: Dimensions.r8,
                        children: _availableSports.map((sport) {
                          final isSelected = _selectedSports.contains(sport);
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
                            : Text(context.loc.saveChanges),
                      ),
                    ],
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
    _cityController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
