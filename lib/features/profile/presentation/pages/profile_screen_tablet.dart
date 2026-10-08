import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lastspot_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:lastspot_app/features/auth/presentation/bloc/profile_cubit.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_list_tile.dart';
import '../widgets/profile_skeleton.dart';
import '../widgets/profile_statistics.dart';
import '../widgets/profile_section.dart';

class ProfileScreenTablet extends StatelessWidget {
  final ProfileState state;
  final Future<void> Function() onRefresh;

  const ProfileScreenTablet({
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
        title: Text(loc.navProfile),
        centerTitle: false,
        backgroundColor: context.backgroundColor,
        systemOverlayStyle: AppTheme.systemUiOverlayStyle(context),
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 850),
              margin: const EdgeInsets.all(Dimensions.r24),
              padding: const EdgeInsets.all(Dimensions.r32),
              decoration: BoxDecoration(
                color: context.colorScheme.surface,
                borderRadius: BorderRadius.circular(Dimensions.r20),
                border: Border.all(
                  color: AppColor.helpCardBorderColor,
                  width: 0.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.blackColor.withValues(alpha: 0.04),
                    blurRadius: Dimensions.r20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Builder(
                builder: (context) {
                  if (state is ProfileLoading || state is ProfileInitial) {
                    return const ProfileSkeleton();
                  } else if (state is ProfileError) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.r48,
                      ),
                      child: ErrorState(
                        message: (state as ProfileError).message,
                        onRetry: onRefresh,
                      ),
                    );
                  } else if (state is ProfileLoaded) {
                    final profile = (state as ProfileLoaded).profile;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column: Avatar & Info
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              ProfileHeader(profile: profile),
                              const SizedBox(height: Dimensions.r32),
                              const ProfileStatistics(
                                createdCount: 0,
                                joinedCount: 0,
                                completedCount: 0,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: Dimensions.r48),

                        // Right Column: Sections
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              ProfileSection(
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
                                    onTap: () {
                                      context.go(AppRoutes.activities);
                                    },
                                  ),
                                ],
                              ),
                              ProfileSection(
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
                                      context.safePush(AppRoutes.settings);
                                    },
                                  ),
                                  ProfileListTile(
                                    icon: Icons.help_outline,
                                    title: loc.helpSupport,
                                    onTap: () {},
                                  ),
                                ],
                              ),
                              ProfileSection(
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
                              const SizedBox(height: Dimensions.r32),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  onPressed: () => _onLogout(context, loc),
                                  style: TextButton.styleFrom(
                                    foregroundColor: context.colorScheme.error,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: Dimensions.r24,
                                      vertical: Dimensions.r12,
                                    ),
                                  ),
                                  child: Text(loc.logout),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
