import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../features/notifications/presentation/pages/notifications_screen.dart';
import '../../features/startup/presentation/pages/splash_screen.dart';
import '../../features/startup/presentation/pages/onboarding_screen.dart';
import '../../features/startup/presentation/pages/maintenance_screen.dart';
import '../../features/startup/presentation/pages/force_update_screen.dart';
import '../../features/startup/data/models/app_settings_model.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/signup_screen.dart';
import '../../features/auth/presentation/pages/forgot_password_screen.dart';
import '../../features/auth/presentation/pages/reset_password_screen.dart';
import '../../features/auth/presentation/pages/profile_setup_screen.dart';
import '../../features/auth/presentation/pages/account_status_screen.dart';
import '../../features/spot/presentation/pages/home_screen.dart';
import '../../features/spot/presentation/bloc/home_cubit.dart';
import '../../features/spot/presentation/pages/create_spot_screen.dart';
import '../../features/spot/presentation/pages/create_spot_success_screen.dart';
import '../../features/spot/presentation/pages/preview_spot_screen.dart';
import '../../features/auth/presentation/bloc/profile_cubit.dart';
import '../../features/spot/presentation/bloc/create_spot_bloc.dart';
import '../../features/spot/presentation/pages/spot_details_screen.dart';
import '../../features/spot/presentation/bloc/spot_details_bloc.dart';
import '../../features/spot/presentation/pages/manage_requests_screen.dart';
import '../../features/spot/presentation/bloc/manage_requests_bloc.dart';
import '../../features/spot/presentation/pages/chat_screen.dart';
import '../../features/chat/presentation/pages/group_info_screen.dart';
import '../../features/spot/domain/usecases/create_spot_usecase.dart';
import '../../features/spot/domain/usecases/update_spot_usecase.dart';
import '../../features/spot/domain/usecases/get_spot_details_usecase.dart';

import '../../features/spot/domain/usecases/join_spot_usecase.dart';
import '../../features/spot/domain/entities/request_entity.dart';
import '../../features/spot/domain/usecases/manage_join_request_usecase.dart';
import '../../features/spot/domain/usecases/stream_spot_join_requests_usecase.dart';
import '../../features/spot/domain/usecases/get_confirmed_players_usecase.dart';
import '../../features/spot/domain/usecases/get_user_join_request_usecase.dart';
import '../../features/categories/domain/usecases/get_categories_usecase.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/categories/presentation/bloc/category_bloc.dart';
import '../../features/categories/presentation/bloc/category_event.dart' as ce;
import '../widgets/authenticated_app_shell.dart';
import '../services/in_app_feedback_manager.dart';
import '../../features/explore/presentation/pages/explore_screen.dart';
import '../../features/explore/presentation/bloc/explore_bloc.dart';
import '../../features/activities/presentation/pages/activities_screen.dart';
import '../../features/chat/presentation/pages/chats_screen.dart';
import '../../features/profile/presentation/pages/profile_screen.dart';
import '../../features/profile/presentation/pages/edit_profile_screen.dart';
import '../../features/reports/presentation/pages/report_screen.dart';
import '../../features/settings/presentation/pages/settings_screen.dart';
import '../../features/help_support/presentation/pages/help_support_screen.dart';
import '../../features/legal/presentation/pages/privacy_policy_screen.dart';
import '../../features/legal/presentation/pages/terms_conditions_screen.dart';
import '../di/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_routes.dart';

export 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  observers: [appFeedbackManager],
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.maintenance,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return MaintenanceScreen(
          title: extra['title'] ?? 'Maintenance',
          message: extra['message'] ?? 'We will be back soon.',
        );
      },
    ),
    GoRoute(
      path: AppRoutes.forceUpdate,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return ForceUpdateScreen(
          messageData: extra['messageData'] as VersionMessage,
          storeUrl: extra['storeUrl'] as String,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.resetPassword,
      builder: (context, state) => const ResetPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.profileSetup,
      builder: (context, state) => const ProfileSetupScreen(),
    ),
    GoRoute(
      path: AppRoutes.accountStatus,
      builder: (context, state) => const AccountStatusScreen(),
    ),

    // Authenticated App Shell (Bottom Navigation)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AuthenticatedAppShell(navigationShell: navigationShell);
      },
      branches: [
        // Branch 0: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) {
                final userId = Supabase.instance.client.auth.currentUser!.id;
                return MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (context) => sl<HomeCubit>()),
                    BlocProvider(
                      create: (context) =>
                          sl<ProfileCubit>()..fetchProfile(userId),
                    ),
                  ],
                  child: const HomeScreen(),
                );
              },
            ),
          ],
        ),
        // Branch 1: Explore
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.explore,
              builder: (context, state) => MultiBlocProvider(
                providers: [
                  BlocProvider(create: (context) => sl<ExploreBloc>()),
                  BlocProvider(
                    create: (context) =>
                        sl<CategoryBloc>()..add(ce.LoadCategoriesEvent()),
                  ),
                ],
                child: ExploreScreen(
                  initialCategoryId: state.uri.queryParameters['category_id'],
                ),
              ),
            ),
          ],
        ),

        // Branch 2: Activities
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.activities,
              builder: (context, state) => const ActivitiesScreen(),
            ),
          ],
        ),
        // Branch 3: Chats
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.chats,
              builder: (context, state) => const ChatsScreen(),
            ),
          ],
        ),
      ],
    ),

    // Contextual Features (Outside Bottom Navigation)
    GoRoute(
      path: AppRoutes.spotDetails,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final extra = state.extra as Map<String, dynamic>? ?? {};
        final heroTag = extra['heroTag'] as String?;
        final initialSpot = extra['spot'] as RequestEntity?;

        return BlocProvider(
          create: (context) => SpotDetailsBloc(
            getSpotDetailsUseCase: sl<GetSpotDetailsUseCase>(),
            joinSpotUseCase: sl<JoinSpotUseCase>(),
            authRepository: sl<AuthRepository>(),
            getConfirmedPlayersUseCase: sl<GetConfirmedPlayersUseCase>(),
            getUserJoinRequestUseCase: sl<GetUserJoinRequestUseCase>(),
          ),
          child: SpotDetailsScreen(
            spotId: id,
            heroTag: heroTag,
            initialSpot: initialSpot,
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.create,
      builder: (context, state) {
        final spotToEdit = state.extra as RequestEntity?;
        return BlocProvider(
          create: (context) => CreateSpotBloc(
            createSpotUseCase: sl<CreateSpotUseCase>(),
            updateSpotUseCase: sl<UpdateSpotUseCase>(),
            getCategoriesUseCase: sl<GetCategoriesUseCase>(),
          )..add(LoadCategoriesEvent()),
          child: CreateSpotScreen(spotToEdit: spotToEdit),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.createSuccess,
      builder: (context, state) => const CreateSpotSuccessScreen(),
    ),
    GoRoute(
      path: AppRoutes.editSpot,
      builder: (context, state) {
        final spotToEdit = state.extra as RequestEntity?;
        return BlocProvider(
          create: (context) => CreateSpotBloc(
            createSpotUseCase: sl<CreateSpotUseCase>(),
            updateSpotUseCase: sl<UpdateSpotUseCase>(),
            getCategoriesUseCase: sl<GetCategoriesUseCase>(),
          )..add(LoadCategoriesEvent()),
          child: CreateSpotScreen(spotToEdit: spotToEdit),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.previewSpot,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        final bloc = extra['bloc'] as CreateSpotBloc;
        final formState = extra['formState'] as CreateSpotFormState;
        final spotToEdit = extra['spotToEdit'] as RequestEntity?;

        return BlocProvider.value(
          value: bloc,
          child: PreviewSpotScreen(
            formState: formState,
            spotToEdit: spotToEdit,
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.manageRequests,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return BlocProvider(
          create: (context) => ManageRequestsBloc(
            streamRequestsUseCase: sl<StreamSpotJoinRequestsUseCase>(),
            manageRequestUseCase: sl<ManageJoinRequestUseCase>(),
            getSpotDetailsUseCase: sl<GetSpotDetailsUseCase>(),
          ),
          child: ManageRequestsScreen(spotId: id),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.chat,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final isConversation =
            state.uri.queryParameters['is_conversation'] == 'true';
        final isDirect = state.uri.queryParameters['is_direct'] != null
            ? state.uri.queryParameters['is_direct'] == 'true'
            : (state.uri.queryParameters['recipient'] != null);
        return ChatScreen(
          id: id,
          isConversationId: isConversation,
          isDirect: isDirect,
          recipientUserId: state.uri.queryParameters['recipient'],
          recipientName: state.uri.queryParameters['name'],
          activityTitle: state.uri.queryParameters['activity_title'],
          requestId: state.uri.queryParameters['request_id'],
        );
      },
    ),
    GoRoute(
      path: AppRoutes.groupInfo,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return GroupInfoScreen(
          spotId: id,
          getSpotDetailsUseCase: sl<GetSpotDetailsUseCase>(),
          getConfirmedPlayersUseCase: sl<GetConfirmedPlayersUseCase>(),
          currentUserId: sl<AuthRepository>().getCurrentUserId(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.editProfile,
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.helpSupport,
      builder: (context, state) => const HelpSupportScreen(),
    ),
    GoRoute(
      path: AppRoutes.privacyPolicy,
      builder: (context, state) => const PrivacyPolicyScreen(),
    ),
    GoRoute(
      path: AppRoutes.termsConditions,
      builder: (context, state) => const TermsConditionsScreen(),
    ),
    // Future placeholders
    GoRoute(
      path: AppRoutes.notifications,
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: AppRoutes.reportUser,
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return ReportScreen(reportedUserId: id);
      },
    ),
    GoRoute(
      path: AppRoutes.reportActivity,
      builder: (context, state) {
        final id = state.pathParameters['id'];
        return ReportScreen(reportedActivityId: id);
      },
    ),
  ],
);
