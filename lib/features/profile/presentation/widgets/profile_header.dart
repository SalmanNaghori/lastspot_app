import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/features/auth/domain/entities/user_profile.dart';
import 'package:lastspot_app/features/auth/presentation/bloc/profile_cubit.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfile profile;

  const ProfileHeader({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;

    return Column(
      children: [
        AppCachedNetworkImage(
          imageUrl: profile.avatarUrl?.replaceAll('/svg?', '/png?'),
          width: Dimensions.r100.dynamicW,
          height: Dimensions.r100.dynamicH,
          isCircle: true,
          memCacheWidth: 300,
          memCacheHeight: 300,
          errorWidget: CircleAvatar(
            radius: Dimensions.r50.dynamicR,
            backgroundColor: context.colorScheme.surfaceContainerHighest,
            child: Icon(
              Icons.person,
              size: Dimensions.r48.dynamicH,
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        SizedBox(height: Dimensions.r16.dynamicH),
        Text(
          profile.fullName ?? loc.yourName,
          style: context.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        if (profile.city != null && profile.city!.isNotEmpty) ...[
          SizedBox(height: Dimensions.r4.dynamicH),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_on,
                size: Dimensions.r16.dynamicH,
                color: context.colorScheme.primary,
              ),
              SizedBox(width: Dimensions.r4.dynamicW),
              Text(
                profile.city!,
                style: context.titleMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
        if (profile.bio != null && profile.bio!.isNotEmpty) ...[
          SizedBox(height: Dimensions.r12.dynamicH),
          Text(
            profile.bio!,
            style: context.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
        if (profile.sportsInterests.isNotEmpty) ...[
          SizedBox(height: Dimensions.r16.dynamicH),
          Wrap(
            spacing: Dimensions.r8.dynamicW,
            runSpacing: Dimensions.r8.dynamicH,
            alignment: WrapAlignment.center,
            children: profile.sportsInterests.map((sport) {
              return Chip(
                avatar: Image.asset(
                  AppAssets.getCategoryAsset(sport),
                  width: Dimensions.r18.dynamicW,
                  height: Dimensions.r18.dynamicH,
                  cacheWidth: 64,
                  cacheHeight: 64,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      AppAssets.getCategoryFallbackIcon(sport),
                      size: Dimensions.r14.dynamicH,
                      color: context.primaryColor,
                    );
                  },
                ),
                label: Text(sport),
                labelStyle: context.bodySmall?.copyWith(
                  color: context.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
                backgroundColor: context.colorScheme.primaryContainer
                    .withValues(alpha: 0.5),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.r8.dynamicR),
                ),
              );
            }).toList(),
          ),
        ],
        SizedBox(height: Dimensions.r24.dynamicH),
        OutlinedButton.icon(
          onPressed: () async {
            final result = await context.safePush<dynamic>(
              AppRoutes.editProfile,
            );
            if (result != null && result is UserProfile && context.mounted) {
              context.read<ProfileCubit>().setProfileLocally(result);
            }
          },
          icon: Icon(Icons.edit_outlined, size: Dimensions.r18.dynamicH),
          label: Text(loc.editProfile),
        ),
      ],
    );
  }
}
