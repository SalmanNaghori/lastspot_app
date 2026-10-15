import 'package:supabase_flutter/supabase_flutter.dart';
import '../base_import.dart';
import '../../features/auth/domain/entities/user_profile.dart';
import '../../features/auth/presentation/bloc/profile_cubit.dart';

/// Reusable circular profile avatar for authenticated headers and navigation bars.
///
/// Features:
/// - Displays authenticated user's profile image if available.
/// - Gracefully falls back to initials when photo is absent or fails to load.
/// - Strict 36-40px circular visual dimension with a 48x48 accessible touch target.
/// - Accessible semantics and tooltip ("Open profile").
/// - Tapping pushes the existing Profile route without resetting navigation stack.
class UserProfileAvatar extends StatelessWidget {
  final double size;
  final VoidCallback? onTap;
  final UserProfile? profile;

  const UserProfileAvatar({
    super.key,
    this.size = 38.0,
    this.onTap,
    this.profile,
  });

  String _computeInitials(String? name) {
    if (name == null || name.trim().isEmpty) return 'P';
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts[1][0]}'.toUpperCase();
    }
    return parts.first[0].toUpperCase();
  }

  void _handleTap(BuildContext context) {
    if (onTap != null) {
      onTap!();
      return;
    }
    context.push(AppRoutes.profile).then((_) {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (context.mounted && userId != null) {
        try {
          context.read<ProfileCubit>().fetchProfile(userId);
        } catch (_) {}
      }
    });
  }

  Widget _buildAvatarContent(
    BuildContext context,
    UserProfile? currentProfile,
  ) {
    final photoUrl = currentProfile?.avatarUrl?.trim();
    final initials = _computeInitials(currentProfile?.fullName);

    final Widget fallback = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: context.primaryColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: AppColor.whiteColor,
          fontSize: size * 0.38,
          fontWeight: FontWeight.w700,
        ),
      ),
    );

    if (photoUrl == null || photoUrl.isEmpty) {
      return fallback;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: context.colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1.2,
        ),
      ),
      child: AppCachedNetworkImage(
        imageUrl: photoUrl.replaceAll('/svg?', '/png?'),
        width: size,
        height: size,
        isCircle: true,
        memCacheWidth: 120,
        memCacheHeight: 120,
        placeholder: fallback,
        errorWidget: fallback,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final label = context.loc.openProfile;

    Widget avatar;
    if (profile != null) {
      avatar = _buildAvatarContent(context, profile);
    } else {
      ProfileCubit? cubit;
      try {
        cubit = BlocProvider.of<ProfileCubit>(context, listen: false);
      } catch (_) {
        cubit = null;
      }

      if (cubit != null) {
        avatar = BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            final current = state is ProfileLoaded ? state.profile : null;
            return _buildAvatarContent(context, current);
          },
        );
      } else {
        avatar = _buildAvatarContent(context, null);
      }
    }

    return Semantics(
      button: true,
      label: label,
      child: Tooltip(
        message: label,
        child: InkResponse(
          onTap: () => _handleTap(context),
          radius: Dimensions.r24.dynamicR,
          highlightShape: BoxShape.circle,
          containedInkWell: true,
          child: Container(
            constraints: BoxConstraints(
              minWidth: Dimensions.r48.dynamicW,
              minHeight: Dimensions.r48.dynamicH,
            ),
            alignment: Alignment.center,
            child: avatar,
          ),
        ),
      ),
    );
  }
}
