import 'package:go_router/go_router.dart';
import '../../features/startup/presentation/pages/splash_screen.dart';
import '../../features/startup/presentation/pages/maintenance_screen.dart';
import '../../features/startup/presentation/pages/force_update_screen.dart';
import '../../features/startup/presentation/bloc/startup_state.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/signup_screen.dart';
import '../../features/auth/presentation/pages/forgot_password_screen.dart';
import '../../features/auth/presentation/pages/profile_setup_screen.dart';
import '../../features/auth/presentation/pages/account_status_screen.dart';
import '../../features/auth/presentation/pages/auth_check_screen.dart';
import '../../features/spot/presentation/pages/feed_screen.dart';
import '../../features/spot/presentation/bloc/feed_bloc.dart';
import '../../features/spot/presentation/pages/create_spot_screen.dart';
import '../../features/spot/presentation/bloc/create_spot_bloc.dart';
import '../../features/spot/presentation/pages/spot_details_screen.dart';
import '../../features/spot/presentation/bloc/spot_details_bloc.dart';
import '../../features/spot/presentation/pages/manage_requests_screen.dart';
import '../../features/spot/presentation/bloc/manage_requests_bloc.dart';
import '../../features/spot/presentation/pages/chat_screen.dart';
import '../../features/spot/domain/usecases/create_spot_usecase.dart';
import '../../features/spot/domain/usecases/get_spot_details_usecase.dart';
import '../../features/spot/domain/usecases/get_spots_usecase.dart';
import '../../features/spot/domain/usecases/join_spot_usecase.dart';
import '../../features/spot/domain/usecases/manage_join_request_usecase.dart';
import '../../features/spot/domain/usecases/stream_spot_join_requests_usecase.dart';
import '../../features/spot/domain/usecases/get_confirmed_players_usecase.dart';
import '../../features/categories/domain/usecases/get_categories_usecase.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../widgets/authenticated_app_shell.dart';
import '../../features/explore/presentation/pages/explore_screen.dart';
import '../../features/activities/presentation/pages/activities_screen.dart';
import '../../features/profile/presentation/pages/profile_screen.dart';
import '../../features/profile/presentation/pages/edit_profile_screen.dart';
import '../../features/settings/presentation/pages/settings_screen.dart';
import '../di/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'app_routes.dart';

export 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
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
        final updateData = state.extra as StartupUpdateRequired;
        return ForceUpdateScreen(updateData: updateData);
      },
    ),
    GoRoute(
      path: AppRoutes.authCheck,
      builder: (context, state) => const AuthCheckScreen(),
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
              builder: (context, state) => BlocProvider(
                create: (context) =>
                    FeedBloc(getSpotsUseCase: sl<GetSpotsUseCase>()),
                child: const FeedScreen(),
              ),
            ),
          ],
        ),
        // Branch 1: Explore
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.explore,
              builder: (context, state) => const ExploreScreen(),
            ),
          ],
        ),
        // Branch 2: Create
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.create,
              builder: (context, state) => BlocProvider(
                create: (context) => CreateSpotBloc(
                  createSpotUseCase: sl<CreateSpotUseCase>(),
                  getCategoriesUseCase: sl<GetCategoriesUseCase>(),
                )..add(LoadCategoriesEvent()),
                child: const CreateSpotScreen(),
              ),
            ),
          ],
        ),
        // Branch 3: Activities
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.activities,
              builder: (context, state) => const ActivitiesScreen(),
            ),
          ],
        ),
        // Branch 4: Profile
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfileScreen(),
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
        return BlocProvider(
          create: (context) => SpotDetailsBloc(
            getSpotDetailsUseCase: sl<GetSpotDetailsUseCase>(),
            joinSpotUseCase: sl<JoinSpotUseCase>(),
            authRepository: sl<AuthRepository>(),
            getConfirmedPlayersUseCase: sl<GetConfirmedPlayersUseCase>(),
          ),
          child: SpotDetailsScreen(postId: id),
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
          child: ManageRequestsScreen(postId: id),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.chat,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ChatScreen(postId: id);
      },
    ),
    GoRoute(
      path: AppRoutes.editProfile,
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
    // Future placeholders
    GoRoute(
      path: AppRoutes.notifications,
      builder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Notifications')),
        body: const Center(child: Text('Notifications')),
      ),
    ),
    GoRoute(
      path: AppRoutes.reportUser,
      builder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Report User')),
        body: const Center(child: Text('Report User')),
      ),
    ),
    GoRoute(
      path: AppRoutes.reportActivity,
      builder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Report Activity')),
        body: const Center(child: Text('Report Activity')),
      ),
    ),
  ],
);
