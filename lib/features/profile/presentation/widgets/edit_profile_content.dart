import 'dart:io';

import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/features/auth/presentation/bloc/profile_cubit.dart';
import 'package:lastspot_app/features/cities/domain/entities/city_entity.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EditProfileContent extends StatelessWidget {
  final ProfileState state;
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController bioController;
  final TextEditingController emailController;
  final ValueNotifier<CityEntity?> selectedCity;
  final ValueNotifier<File?> selectedAvatar;
  final ValueNotifier<List<String>> selectedSports;
  final ValueNotifier<bool> showCityError;
  final VoidCallback onPickAvatar;
  final VoidCallback onCityTap;
  final VoidCallback onSave;
  final ValueChanged<String> onToggleSport;

  const EditProfileContent({
    super.key,
    required this.state,
    required this.formKey,
    required this.nameController,
    required this.bioController,
    required this.emailController,
    required this.selectedCity,
    required this.selectedAvatar,
    required this.selectedSports,
    required this.showCityError,
    required this.onPickAvatar,
    required this.onCityTap,
    required this.onSave,
    required this.onToggleSport,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        title: Text(context.loc.editProfile),
        backgroundColor: context.backgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Skeletonizer(
          enabled: state is ProfileLoading && nameController.text.isEmpty,
          child: SingleChildScrollView(
                padding: const EdgeInsets.all(Dimensions.r24),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: onPickAvatar,
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              ValueListenableBuilder<File?>(
                                valueListenable: selectedAvatar,
                                builder: (context, avatar, _) {
                                  return CircleAvatar(
                                    radius: 60,
                                    backgroundColor: context.surfaceColor,
                                    backgroundImage: avatar != null
                                        ? FileImage(avatar)
                                        : (state is ProfileLoaded &&
                                              (state as ProfileLoaded)
                                                      .profile
                                                      .avatarUrl !=
                                                  null &&
                                              (state as ProfileLoaded)
                                                  .profile
                                                  .avatarUrl!
                                                  .isNotEmpty)
                                        ? NetworkImage(
                                                (state as ProfileLoaded)
                                                    .profile
                                                    .avatarUrl!
                                                    .replaceAll(
                                                      '/svg?',
                                                      '/png?',
                                                    ),
                                              )
                                              as ImageProvider
                                        : null,
                                    child:
                                        avatar == null &&
                                            (state is! ProfileLoaded ||
                                                (state as ProfileLoaded)
                                                        .profile
                                                        .avatarUrl ==
                                                    null ||
                                                (state as ProfileLoaded)
                                                    .profile
                                                    .avatarUrl!
                                                    .isEmpty)
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
                                backgroundColor: context.primaryColor,
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
                        controller: nameController,
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
                        controller: emailController,
                        readOnly: true,
                        hintText: '',
                      ),
                      const SizedBox(height: Dimensions.r16),
                      AppTextField(
                        controller: bioController,
                        labelText: context.loc.bioOptional,
                        maxLines: 3,
                        textCapitalization: TextCapitalization.sentences,
                      ),
                      const SizedBox(height: Dimensions.r16),
                      // City Picker
                      ValueListenableBuilder<bool>(
                        valueListenable: showCityError,
                        builder: (context, showError, _) {
                          return ValueListenableBuilder<CityEntity?>(
                            valueListenable: selectedCity,
                            builder: (context, city, _) {
                              return AppTextField(
                                labelText: context.loc.cityLabel,
                                hintText:
                                    city?.name ?? context.loc.selectCityHint,
                                readOnly: true,
                                onTap: onCityTap,
                                errorText: showError && city == null
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
                        valueListenable: selectedSports,
                        builder: (context, sports, _) {
                          return Wrap(
                            spacing: Dimensions.r8,
                            runSpacing: Dimensions.r8,
                            children: AppConstants.getAvailableSports(context).map((sport) {
                              final isSelected = sports.contains(sport);
                              return ChoiceChip(
                                label: Text(sport),
                                selected: isSelected,
                                onSelected: (_) => onToggleSport(sport),
                                selectedColor: context.primaryColor.withValues(
                                  alpha: 0.2,
                                ),
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? context.primaryColor
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
                          backgroundColor: context.primaryColor,
                          foregroundColor: AppColor.whiteColor,
                          padding: const EdgeInsets.symmetric(
                            vertical: Dimensions.r16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Dimensions.r12),
                          ),
                        ),
                        onPressed: state is ProfileLoading ? null : onSave,
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
      ),
    );
  }
}
