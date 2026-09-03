import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/features/auth/domain/entities/user_profile.dart';
import 'package:lastspot_app/features/auth/presentation/bloc/profile_cubit.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfile profile;

  const ProfileHeader({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = context.loc;

    return Column(
      children: [
        AppCachedNetworkImage(
          imageUrl: profile.avatarUrl?.replaceAll('/svg?', '/png?'),
          width: 104,
          height: 104,
          isCircle: true,
          errorWidget: CircleAvatar(
            radius: 52,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            child: Icon(
              Icons.person,
              size: 52,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: Dimensions.r16),
        Text(
          profile.fullName ?? loc.yourName,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        if (profile.city != null && profile.city!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_on,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                profile.city!,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
        if (profile.bio != null && profile.bio!.isNotEmpty) ...[
          const SizedBox(height: Dimensions.r12),
          Text(
            profile.bio!,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
        if (profile.sportsInterests.isNotEmpty) ...[
          const SizedBox(height: Dimensions.r16),
          Wrap(
            spacing: Dimensions.r8,
            runSpacing: Dimensions.r8,
            alignment: WrapAlignment.center,
            children: profile.sportsInterests.map((sport) {
              return Chip(
                label: Text(sport),
                labelStyle: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
                backgroundColor: theme.colorScheme.primaryContainer.withValues(
                  alpha: 0.5,
                ),
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.r8),
                ),
              );
            }).toList(),
          ),
        ],
        const SizedBox(height: Dimensions.r24),
        OutlinedButton.icon(
          onPressed: () async {
            final result = await context.push<dynamic>('/edit-profile');
            if (result != null && result is UserProfile && context.mounted) {
              context.read<ProfileCubit>().setProfileLocally(result);
            }
          },
          icon: const Icon(Icons.edit_outlined, size: 18),
          label: Text(loc.editProfile),
        ),
      ],
    );
  }
}
