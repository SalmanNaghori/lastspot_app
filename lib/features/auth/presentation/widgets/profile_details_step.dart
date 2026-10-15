import 'dart:io';
import 'package:lastspot_app/core/base_import.dart';
import '../../domain/entities/user_profile.dart';

class ProfileDetailsStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController bioController;
  final ValueNotifier<File?> selectedAvatar;
  final UserProfile? existingProfile;
  final VoidCallback onPickAvatar;
  final VoidCallback onNext;

  const ProfileDetailsStep({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.bioController,
    required this.selectedAvatar,
    this.existingProfile,
    required this.onPickAvatar,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: Dimensions.r16.dynamicH),
          Text(
            'Setup your profile',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Dimensions.r24.dynamicSP,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
              color: context.textPrimary,
            ),
          ),
          SizedBox(height: Dimensions.r6.dynamicH),
          Text(
            'Add your photo and details so teammates know who you are.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Dimensions.r14.dynamicSP,
              color: context.textSecondary,
              height: 1.4,
            ),
          ),
          SizedBox(height: Dimensions.r28.dynamicH),
          Center(
            child: GestureDetector(
              onTap: onPickAvatar,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  ValueListenableBuilder<File?>(
                    valueListenable: selectedAvatar,
                    builder: (context, avatarFile, _) {
                      final hasExistingAvatar =
                          existingProfile?.avatarUrl != null &&
                          existingProfile!.avatarUrl!.isNotEmpty;

                      return Container(
                        width: Dimensions.r96.dynamicW * 1.3,
                        height: Dimensions.r96.dynamicH * 1.3,
                        decoration: BoxDecoration(
                          color: context.isDarkMode
                              ? context.surfaceContainer
                              : AppColor.surfaceContainerLight,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: context.primaryColor.withValues(alpha: 0.3),
                            width: 2.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: context.primaryColor.withValues(
                                alpha: 0.12,
                              ),
                              blurRadius: Dimensions.r16.dynamicR,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: avatarFile != null
                              ? Image.file(avatarFile, fit: BoxFit.cover)
                              : (hasExistingAvatar
                                    ? Image.network(
                                        existingProfile!.avatarUrl!.replaceAll(
                                          '/svg?',
                                          '/png?',
                                        ),
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(
                                                  Icons.person_rounded,
                                                  size: Dimensions.r60.dynamicH,
                                                  color: context.textSecondary,
                                                ),
                                      )
                                    : Icon(
                                        Icons.person_rounded,
                                        size: Dimensions.r60.dynamicH,
                                        color: context.textSecondary,
                                      )),
                        ),
                      );
                    },
                  ),
                  Container(
                    width: Dimensions.r36.dynamicW,
                    height: Dimensions.r36.dynamicH,
                    decoration: BoxDecoration(
                      color: context.primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColor.whiteColor,
                        width: 2.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.blackColor.withValues(alpha: 0.15),
                          blurRadius: Dimensions.r6.dynamicR,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
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
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return context.loc.fullNameRequired;
              }
              return null;
            },
          ),
          SizedBox(height: Dimensions.r16.dynamicH),
          AppTextField(
            controller: bioController,
            labelText: context.loc.bioOptional,
            prefixIcon: const Icon(Icons.info_outline_rounded),
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
          ),
          SizedBox(height: Dimensions.r32.dynamicH),
          SizedBox(
            width: double.infinity,
            height: Dimensions.r48.dynamicH * 1.15,
            child: FilledButton(
              onPressed: onNext,
              style: FilledButton.styleFrom(
                backgroundColor: context.primaryColor,
                foregroundColor: AppColor.whiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
                ),
                elevation: 0,
              ),
              child: Text(
                'Next: Choose City',
                style: TextStyle(
                  fontSize: Dimensions.r16.dynamicSP,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
