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
    final theme = Theme.of(context);

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
                const ProfileStatistics(
                  createdCount: 0,
                  joinedCount: 0,
                  completedCount: 0,
                ),
                const SizedBox(height: Dimensions.r32),

                // Sections
                _buildSection(
                  context,
                  title: loc.profileSectionActivity,
                  items: [
                    ProfileListTile(
                      icon: Icons.assignment_outlined,
                      title: loc.myRequests,
                      onTap: () {},
                    ),
                    ProfileListTile(
                      icon: Icons.event_available_outlined,
                      title: loc.myActivities,
                      onTap: () {},
                    ),
                  ],
                ),
                _buildSection(
                  context,
                  title: loc.profileSectionAccount,
                  items: [
                    ProfileListTile(
                      icon: Icons.notifications_outlined,
                      title: loc.notifications,
                      onTap: () {},
                    ),
                    ProfileListTile(
                      icon: Icons.settings_outlined,
                      title: loc.settings,
                      onTap: () {
                        context.push(AppRoutes.settings);
                      },
                    ),
                    ProfileListTile(
                      icon: Icons.help_outline,
                      title: loc.helpSupport,
                      onTap: () {},
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
                      onTap: () {},
                    ),
                    ProfileListTile(
                      icon: Icons.article_outlined,
                      title: loc.termsConditions,
                      onTap: () {},
                    ),
                  ],
                ),

                const SizedBox(height: Dimensions.r24),
                TextButton(
                  onPressed: () => _onLogout(context, loc),
                  style: TextButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
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
    final theme = Theme.of(context);
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
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(Dimensions.r12),
          ),
          child: Column(children: items),
        ),
        const SizedBox(height: Dimensions.r24),
      ],
    );
  }
}
