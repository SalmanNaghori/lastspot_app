import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lastspot_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:lastspot_app/features/auth/presentation/bloc/profile_cubit.dart';

import '../widgets/profile_list_tile.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_statistics.dart';
import '../widgets/profile_skeleton.dart';

class ProfileScreenMobile extends StatelessWidget {
  final ProfileState state;
  final Future<void> Function() onRefresh;

  const ProfileScreenMobile({
    super.key,
    required this.state,
    required this.onRefresh,
  });

  void _onLogout(BuildContext context, AppLocalizations loc) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(loc.logoutDialogTitle),
        content: Text(loc.logoutDialogMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(loc.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
            child: Text(loc.logout),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        title: Text(loc.navProfile),
        centerTitle: false,
        backgroundColor: context.backgroundColor,
        systemOverlayStyle: AppTheme.systemUiOverlayStyle(context),
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.r16),
          child: Column(
            children: [
              if (state is ProfileLoading || state is ProfileInitial)
                const ProfileSkeleton()
              else if (state is ProfileError)
                Padding(
                  padding: const EdgeInsets.only(top: Dimensions.r48),
                  child: ErrorState(
                    message: (state as ProfileError).message,
                    onRetry: onRefresh,
                  ),
                )
              else if (state is ProfileLoaded) ...[
                const SizedBox(height: Dimensions.r24),
                ProfileHeader(profile: (state as ProfileLoaded).profile),
                const SizedBox(height: Dimensions.r32),

                // Statistics
                ProfileStatistics(
                  createdCount: (state as ProfileLoaded).stats.createdCount,
                  joinedCount: (state as ProfileLoaded).stats.joinedCount,
                  completedCount: (state as ProfileLoaded).stats.completedCount,
                ),
                const SizedBox(height: Dimensions.r32),

                // Sections
                _buildSection(
                  context,
                  title: loc.profileSectionAccount,
                  items: [
                    ProfileListTile(
                      icon: Icons.notifications_outlined,
                      title: loc.notifications,
                      onTap: () {
                        context.push(AppRoutes.notifications);
                      },
                    ),
                    ProfileListTile(
                      icon: Icons.settings_outlined,
                      title: loc.settings,
                      onTap: () {
                        context.safePush(AppRoutes.settings);
                      },
                    ),
                    ProfileListTile(
                      icon: Icons.help_outline,
                      title: loc.helpSupport,
                      onTap: () {
                        context.push(AppRoutes.helpSupport);
                      },
                    ),
                  ],
                ),
                _buildSection(
                  context,
                  title: loc.profileSectionLegal,
                  items: [
                    ProfileListTile(
                      icon: Icons.privacy_tip_outlined,
                      title: loc.privacyPolicy,
                      onTap: () {
                        context.push(AppRoutes.privacyPolicy);
                      },
                    ),
                    ProfileListTile(
                      icon: Icons.article_outlined,
                      title: loc.termsConditions,
                      onTap: () {
                        context.push(AppRoutes.termsConditions);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: Dimensions.r24),
                TextButton(
                  onPressed: () => _onLogout(context, loc),
                  style: TextButton.styleFrom(
                    foregroundColor: context.colorScheme.error,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: Text(loc.logout),
                ),
                const SizedBox(height: Dimensions.r48),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.r8,
            vertical: Dimensions.r8,
          ),
          child: Text(
            title.toUpperCase(),
            style: context.labelMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Material(
          color: context.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(Dimensions.r12),
          clipBehavior: Clip.antiAlias,
          child: Column(children: items),
        ),
        const SizedBox(height: Dimensions.r24),
      ],
    );
  }
}
