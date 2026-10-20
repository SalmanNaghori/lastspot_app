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
    final profile = state is ProfileLoaded
        ? (state as ProfileLoaded).profile
        : null;
    final avatarUrl = profile?.avatarUrl?.trim();
    final avatarName = nameController.text.trim().isNotEmpty
        ? nameController.text.trim()
        : profile?.fullName?.trim() ?? '';
    final initial = avatarName.isNotEmpty
        ? avatarName.characters.first.toUpperCase()
        : 'P';
    final avatarSize = Dimensions.r60.dynamicR * 2;
    final avatarFallback = Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        color: context.primaryContainer,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: TextStyle(
          color: context.primaryColor,
          fontWeight: FontWeight.w700,
          fontSize: Dimensions.r36.dynamicSP,
        ),
      ),
    );

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: KhelBhaiBackButton.leading(context),
        title: Text(context.loc.editProfile),
        backgroundColor: context.backgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Skeletonizer(
          enabled: state is ProfileLoading && nameController.text.isEmpty,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(Dimensions.r24.dynamicW),
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
                              return ClipOval(
                                child: SizedBox(
                                  width: avatarSize,
                                  height: avatarSize,
                                  child: avatar != null
                                      ? Image.file(avatar, fit: BoxFit.cover)
                                      : (avatarUrl?.isNotEmpty == true
                                            ? AppCachedNetworkImage(
                                                imageUrl: avatarUrl,
                                                width: avatarSize,
                                                height: avatarSize,
                                                isCircle: true,
                                                fit: BoxFit.cover,
                                                memCacheWidth: 360,
                                                memCacheHeight: 360,
                                                placeholder: avatarFallback,
                                                errorWidget: avatarFallback,
                                              )
                                            : avatarFallback),
                                ),
                              );
                            },
                          ),
                          CircleAvatar(
                            radius: Dimensions.r18.dynamicR,
                            backgroundColor: context.primaryColor,
                            child: Icon(
                              Icons.camera_alt_rounded,
                              size: Dimensions.r18.dynamicH,
                              color: AppColor.whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.r32.dynamicH),
                  AppTextField(
                    controller: nameController,
                    labelText: context.loc.fullName,
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                    textCapitalization: TextCapitalization.words,
                    validator: AppValidators.fullName(context.loc),
                  ),
                  SizedBox(height: Dimensions.r16.dynamicH),
                  AppTextField(
                    labelText: context.loc.email,
                    controller: emailController,
                    prefixIcon: const Icon(Icons.email_outlined),
                    readOnly: true,
                    hintText: '',
                  ),
                  SizedBox(height: Dimensions.r16.dynamicH),
                  AppTextField(
                    controller: bioController,
                    labelText: context.loc.bioOptional,
                    prefixIcon: const Icon(Icons.badge_outlined),
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  SizedBox(height: Dimensions.r16.dynamicH),
                  // City Picker
                  ValueListenableBuilder<bool>(
                    valueListenable: showCityError,
                    builder: (context, showError, _) {
                      return ValueListenableBuilder<CityEntity?>(
                        valueListenable: selectedCity,
                        builder: (context, city, _) {
                          return AppTextField(
                            labelText: context.loc.cityLabel,
                            prefixIcon: const Icon(Icons.location_on_outlined),
                            hintText: city != null
                                ? city.formattedLocation
                                : context.loc.selectCityHint,
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
                  SizedBox(height: Dimensions.r24.dynamicH),
                  Text(
                    context.loc.sportsPreferences,
                    style: TextStyle(
                      fontSize: Dimensions.r16.dynamicSP,
                      fontWeight: FontWeight.bold,
                      color: context.textPrimary,
                    ),
                  ),
                  SizedBox(height: Dimensions.r12.dynamicH),
                  ValueListenableBuilder<List<String>>(
                    valueListenable: selectedSports,
                    builder: (context, sports, _) {
                      return Wrap(
                        spacing: Dimensions.r8.dynamicW,
                        runSpacing: Dimensions.r8.dynamicH,
                        children: AppConstants.getAvailableSports(context).map((
                          sport,
                        ) {
                          final isSelected = sports.contains(sport);
                          return ChoiceChip(
                            avatar: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                Dimensions.r12.dynamicR,
                              ),
                              child: Image.asset(
                                AppAssets.getCategoryAsset(sport.toLowerCase()),
                                width: Dimensions.r18.dynamicW,
                                height: Dimensions.r18.dynamicH,
                                fit: BoxFit.contain,
                              ),
                            ),
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
                              fontSize: Dimensions.r13.dynamicSP,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  SizedBox(height: Dimensions.r40.dynamicH),
                  SizedBox(
                    height: Dimensions.r56.dynamicH,
                    child: FilledButton(
                      onPressed: state is ProfileLoading ? null : onSave,
                      child: state is ProfileLoading
                          ? SizedBox(
                              height: Dimensions.r20.dynamicH,
                              width: Dimensions.r20.dynamicH,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColor.whiteColor,
                              ),
                            )
                          : Text(context.loc.saveChanges),
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
}
