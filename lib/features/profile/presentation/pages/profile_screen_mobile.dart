import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lastspot_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:lastspot_app/features/auth/presentation/bloc/profile_cubit.dart';

import '../widgets/profile_list_tile.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_statistics.dart';
import '../widgets/profile_skeleton.dart';
import '../widgets/profile_section.dart';

class ProfileScreenMobile extends StatelessWidget {
  final ProfileState state;
  final Future<void> Function() onRefresh;

  const ProfileScreenMobile({
    super.key,
    required this.state,
    required this.onRefresh,
  });

  void _onLogout(BuildContext context, AppLocalizations loc) {
    AppUtils.showConfirmationDialog(
      context,
      isDestructive: true,
      title: loc.logoutDialogTitle,
      message: loc.logoutDialogMessage,
      confirmText: loc.logout,
      cancelText: loc.cancel,
      onConfirm: () {
        context.read<AuthBloc>().add(AuthLogoutRequested());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: KhelBhaiBackButton.leading(context),
        title: Text(
          loc.navProfile,
          style: TextStyle(
            fontSize: Dimensions.r18.dynamicSP,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
            color: context.textPrimary,
          ),
        ),
        centerTitle: false,
        backgroundColor: context.backgroundColor,
        systemOverlayStyle: AppTheme.systemUiOverlayStyle(context),
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: Dimensions.r16.dynamicW),
          child: Column(
            children: [
              if (state is ProfileLoading || state is ProfileInitial)
                const ProfileSkeleton()
              else if (state is ProfileError)
                Padding(
                  padding: EdgeInsets.only(top: Dimensions.r48.dynamicH),
                  child: ErrorState(
                    message: (state as ProfileError).message,
                    onRetry: onRefresh,
                  ),
                )
              else if (state is ProfileLoaded) ...[
                SizedBox(height: Dimensions.r24.dynamicH),
                ProfileHeader(profile: (state as ProfileLoaded).profile),
                SizedBox(height: Dimensions.r32.dynamicH),

                // Statistics
                ProfileStatistics(
                  createdCount: (state as ProfileLoaded).stats.createdCount,
                  joinedCount: (state as ProfileLoaded).stats.joinedCount,
                  completedCount: (state as ProfileLoaded).stats.completedCount,
                ),
                SizedBox(height: Dimensions.r32.dynamicH),

                // Sections
                ProfileSection(
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
                ProfileSection(
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

                SizedBox(height: Dimensions.r24.dynamicH),
                TextButton(
                  onPressed: () => _onLogout(context, loc),
                  style: TextButton.styleFrom(
                    foregroundColor: context.colorScheme.error,
                    minimumSize: Size.fromHeight(Dimensions.r48.dynamicH),
                  ),
                  child: Text(loc.logout),
                ),
                SizedBox(height: Dimensions.r48.dynamicH),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
