import '../../../../core/base_import.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import 'package:lastspot_app/features/cities/presentation/bloc/city_cubit.dart';
import 'package:lastspot_app/features/cities/presentation/bloc/city_state.dart';
import '../bloc/my_sports_space_state.dart';
import '../widgets/profile_list_tile.dart';
import '../widgets/profile_section.dart';
import '../widgets/profile_skeleton.dart';
import '../widgets/sports_achievements_section.dart';
import '../widgets/sports_activity_summary.dart';
import '../widgets/sports_interests_section.dart';
import '../widgets/sports_journey_section.dart';
import '../widgets/sports_profile_header.dart';
import '../widgets/sports_quick_actions.dart';
import '../widgets/sports_requests_section.dart';

/// Mobile layout for My Sports Space dashboard.
///
/// Integrates:
/// - Real-data sports profile header
/// - 4-metric sports activity summary
/// - Sports quick actions (Explore, Create, Activities, Chats)
/// - Filterable Sports Journey timeline
/// - Sports Interests with 3D category artwork
/// - My Requests overview
/// - Verified milestones and achievements
/// - Preserved Account, Legal, and Logout actions
class MySportsSpaceScreenMobile extends StatefulWidget {
  final MySportsSpaceState state;
  final Future<void> Function() onRefresh;

  const MySportsSpaceScreenMobile({
    super.key,
    required this.state,
    required this.onRefresh,
  });

  @override
  State<MySportsSpaceScreenMobile> createState() =>
      _MySportsSpaceScreenMobileState();
}

class _MySportsSpaceScreenMobileState extends State<MySportsSpaceScreenMobile> {
  late final ValueNotifier<int> _journeyTabNotifier;

  @override
  void initState() {
    super.initState();
    _journeyTabNotifier = ValueNotifier<int>(0);
    if (sl.isRegistered<CityCubit>()) {
      final cityCubit = sl<CityCubit>();
      if (cityCubit.state is! CityLoaded) {
        cityCubit.fetchCities();
      }
    }
  }

  @override
  void dispose() {
    _journeyTabNotifier.dispose();
    super.dispose();
  }

  void _onEditProfile() {
    context.push(AppRoutes.editProfile).then((_) => widget.onRefresh());
  }

  void _onOpenSettings() {
    context.safePush(AppRoutes.settings);
  }

  void _onFindGame() {
    context.go(AppRoutes.explore);
  }

  void _onOrganizeMatch() {
    context.push(AppRoutes.create);
  }

  void _onMyMatches() {
    context.go(AppRoutes.activities);
  }

  void _onTeamChats() {
    context.go(AppRoutes.chats);
  }

  void _onNotifications() {
    context.push(AppRoutes.notifications);
  }

  void _onHelpSupport() {
    context.push(AppRoutes.helpSupport);
  }

  void _onPrivacyPolicy() {
    context.push(AppRoutes.privacyPolicy);
  }

  void _onTermsConditions() {
    context.push(AppRoutes.termsConditions);
  }

  void _onSummaryCardTap(int tabIndex) {
    _journeyTabNotifier.value = tabIndex;
  }

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
    final state = widget.state;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: KhelBhaiBackButton.leading(context),
        title: Text(
          loc.mySportsSpaceTitle,
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
        actions: [
          IconButton(
            onPressed: _onNotifications,
            icon: Icon(
              Icons.notifications_outlined,
              size: Dimensions.r22.dynamicH,
              color: context.textPrimary,
            ),
            tooltip: loc.notifications,
          ),
          SizedBox(width: Dimensions.r8.dynamicW),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: widget.onRefresh,
        color: context.primaryColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: Dimensions.r16.dynamicW),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state is MySportsSpaceLoading ||
                  state is MySportsSpaceInitial)
                const ProfileSkeleton()
              else if (state is MySportsSpaceError)
                Padding(
                  padding: EdgeInsets.only(top: Dimensions.r48.dynamicH),
                  child: ErrorState(
                    message: state.message,
                    onRetry: widget.onRefresh,
                  ),
                )
              else if (state is MySportsSpaceLoaded) ...[
                SizedBox(height: Dimensions.r12.dynamicH),

                // 1. Profile Header
                SportsProfileHeader(
                  profile: state.data.profile,
                  onEditProfile: _onEditProfile,
                ),
                SizedBox(height: Dimensions.r16.dynamicH),

                // 2. Personal Activity Summary (4 Real Metric Cards)
                ValueListenableBuilder<int>(
                  valueListenable: _journeyTabNotifier,
                  builder: (context, activeIndex, _) {
                    return SportsActivitySummary(
                      hostedCount: state.data.hostedCount,
                      joinedCount: state.data.joinedCount,
                      upcomingCount: state.data.upcomingCount,
                      completedCount: state.data.completedCount,
                      selectedIndex: activeIndex,
                      onCardTap: _onSummaryCardTap,
                    );
                  },
                ),
                SizedBox(height: Dimensions.r16.dynamicH),

                // 3. Quick Actions
                SportsQuickActions(
                  onFindGame: _onFindGame,
                  onOrganizeMatch: _onOrganizeMatch,
                  onMyMatches: _onMyMatches,
                  onTeamChats: _onTeamChats,
                ),
                SizedBox(height: Dimensions.r16.dynamicH),

                // 4. Sports Journey Timeline
                SportsJourneySection(
                  upcomingActivities: state.data.upcomingActivities,
                  joinedActivities: state.data.joinedActivities,
                  hostedActivities: state.data.hostedActivities,
                  pastActivities: state.data.completedActivities,
                  currentUserId: state.data.profile.id,
                  activeTabNotifier: _journeyTabNotifier,
                  onFindGame: _onFindGame,
                  onHostGame: _onOrganizeMatch,
                  onViewAllActivities: _onMyMatches,
                ),
                SizedBox(height: Dimensions.r16.dynamicH),

                // 5. Sports Interests
                SportsInterestsSection(
                  interests: state.data.profile.sportsInterests,
                  onEditInterests: _onEditProfile,
                ),
                SizedBox(height: Dimensions.r16.dynamicH),

                // 6. My Requests Overview
                SportsRequestsSection(
                  sentRequests: state.data.sentRequests,
                  onViewAll: _onMyMatches,
                ),
                SizedBox(height: Dimensions.r16.dynamicH),

                // 7. Verified Personal Achievements
                SportsAchievementsSection(
                  hostedCount: state.data.hostedCount,
                  joinedCount: state.data.joinedCount,
                  completedCount: state.data.completedCount,
                ),
                SizedBox(height: Dimensions.r20.dynamicH),

                // 8. Account & Support Section
                ProfileSection(
                  title: loc.profileSectionAccount,
                  items: [
                    ProfileListTile(
                      icon: Icons.settings_outlined,
                      title: loc.settings,
                      onTap: _onOpenSettings,
                    ),
                    ProfileListTile(
                      icon: Icons.help_outline_rounded,
                      title: loc.helpSupport,
                      onTap: _onHelpSupport,
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.r12.dynamicH),

                // 9. Legal Section
                ProfileSection(
                  title: loc.profileSectionLegal,
                  items: [
                    ProfileListTile(
                      icon: Icons.privacy_tip_outlined,
                      title: loc.privacyPolicy,
                      onTap: _onPrivacyPolicy,
                    ),
                    ProfileListTile(
                      icon: Icons.article_outlined,
                      title: loc.termsConditions,
                      onTap: _onTermsConditions,
                    ),
                  ],
                ),

                // 9. Logout CTA
                SizedBox(height: Dimensions.r12.dynamicH),
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
