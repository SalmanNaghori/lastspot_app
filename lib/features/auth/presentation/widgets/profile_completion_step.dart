import 'dart:io';
import 'package:lastspot_app/core/base_import.dart';
import '../../../cities/domain/entities/city_entity.dart';
import '../../domain/entities/user_profile.dart';

class ProfileCompletionStep extends StatelessWidget {
  final String fullName;
  final CityEntity? selectedCity;
  final List<String> selectedSports;
  final File? selectedAvatar;
  final UserProfile? existingProfile;
  final bool isLoading;
  final VoidCallback onEnterApp;

  const ProfileCompletionStep({
    super.key,
    required this.fullName,
    required this.selectedCity,
    required this.selectedSports,
    required this.selectedAvatar,
    this.existingProfile,
    required this.isLoading,
    required this.onEnterApp,
  });

  @override
  Widget build(BuildContext context) {
    final fallbackName = fullName.trim().isNotEmpty
        ? fullName.trim()
        : existingProfile?.fullName?.trim() ?? '';
    final initial = fallbackName.isNotEmpty
        ? fallbackName.characters.first.toUpperCase()
        : 'P';
    final avatarSize = Dimensions.r48.dynamicH;
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
          fontSize: Dimensions.r18.dynamicSP,
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: Dimensions.r16.dynamicH),
        Center(
          child: Container(
            width: Dimensions.r96.dynamicW * 1.8,
            height: Dimensions.r96.dynamicH * 1.8,
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
                  color: context.primaryColor.withValues(alpha: 0.15),
                  blurRadius: Dimensions.r24.dynamicR,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(Dimensions.r16.dynamicH),
                child: Assets.images.emptyStates.activityCreatedSuccess.image(
                  fit: BoxFit.contain,
                  cacheWidth: 400,
                  cacheHeight: 400,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.emoji_events_rounded,
                    size: Dimensions.r64.dynamicH * 1.5,
                    color: context.primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: Dimensions.r24.dynamicH),
        Text(
          "You're all set!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: Dimensions.r28.dynamicSP,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.6,
            color: context.textPrimary,
          ),
        ),
        SizedBox(height: Dimensions.r8.dynamicH),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.r16.dynamicW),
          child: Text(
            'Your sports profile is ready. Start discovering matches and fill the last spot.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Dimensions.r14.dynamicSP,
              color: context.textSecondary,
              height: 1.45,
            ),
          ),
        ),
        SizedBox(height: Dimensions.r28.dynamicH),
        // Summary Card
        Container(
          padding: EdgeInsets.all(Dimensions.r16.dynamicW),
          decoration: BoxDecoration(
            color: context.isDarkMode
                ? context.surfaceContainer
                : AppColor.surfaceContainerLight,
            borderRadius: BorderRadius.circular(Dimensions.r20.dynamicR),
            border: Border.all(
              color: context.borderColor.withValues(alpha: 0.6),
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipOval(
                    child: selectedAvatar != null
                        ? Image.file(
                            selectedAvatar!,
                            width: avatarSize,
                            height: avatarSize,
                            fit: BoxFit.cover,
                          )
                        : (existingProfile?.avatarUrl?.trim().isNotEmpty == true
                              ? AppCachedNetworkImage(
                                  imageUrl: existingProfile!.avatarUrl,
                                  width: avatarSize,
                                  height: avatarSize,
                                  isCircle: true,
                                  fit: BoxFit.cover,
                                  memCacheWidth: 144,
                                  memCacheHeight: 144,
                                  placeholder: avatarFallback,
                                  errorWidget: avatarFallback,
                                )
                              : avatarFallback),
                  ),
                  SizedBox(width: Dimensions.r12.dynamicW),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName,
                          style: TextStyle(
                            fontSize: Dimensions.r16.dynamicSP,
                            fontWeight: FontWeight.w800,
                            color: context.textPrimary,
                          ),
                        ),
                        if (selectedCity != null) ...[
                          SizedBox(height: Dimensions.r2.dynamicH),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                size: Dimensions.r14.dynamicH,
                                color: context.primaryColor,
                              ),
                              SizedBox(width: Dimensions.r4.dynamicW),
                              Text(
                                selectedCity!.name,
                                style: TextStyle(
                                  fontSize: Dimensions.r13.dynamicSP,
                                  color: context.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              if (selectedSports.isNotEmpty) ...[
                SizedBox(height: Dimensions.r16.dynamicH),
                Wrap(
                  spacing: Dimensions.r8.dynamicW,
                  runSpacing: Dimensions.r8.dynamicH,
                  children: selectedSports.map((sport) {
                    final normalizedSport = sport.toLowerCase().replaceAll(
                      ' ',
                      '-',
                    );
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.r10.dynamicW,
                        vertical: Dimensions.r4.dynamicH,
                      ),
                      decoration: BoxDecoration(
                        color: AppAssets.getCategorySoftTint(normalizedSport),
                        borderRadius: BorderRadius.circular(
                          Dimensions.r999.dynamicR,
                        ),
                        border: Border.all(
                          color: context.primaryColor.withValues(alpha: 0.3),
                          width: 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            AppAssets.getCategoryAsset(normalizedSport),
                            width: Dimensions.r16.dynamicW,
                            height: Dimensions.r16.dynamicH,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.sports_rounded,
                              size: Dimensions.r14.dynamicH,
                              color: context.primaryColor,
                            ),
                          ),
                          SizedBox(width: Dimensions.r6.dynamicW),
                          Text(
                            sport,
                            style: TextStyle(
                              fontSize: Dimensions.r12.dynamicSP,
                              fontWeight: FontWeight.w700,
                              color: context.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: Dimensions.r32.dynamicH),
        SizedBox(
          width: double.infinity,
          height: Dimensions.r48.dynamicH * 1.15,
          child: FilledButton(
            onPressed: isLoading ? null : onEnterApp,
            style: FilledButton.styleFrom(
              backgroundColor: context.primaryColor,
              foregroundColor: AppColor.whiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.r16.dynamicR),
              ),
              elevation: 0,
            ),
            child: isLoading
                ? SizedBox(
                    width: Dimensions.r20.dynamicW,
                    height: Dimensions.r20.dynamicH,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: AppColor.whiteColor,
                    ),
                  )
                : Text(
                    'Enter ${AppString.appName}',
                    style: TextStyle(
                      fontSize: Dimensions.r16.dynamicSP,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
