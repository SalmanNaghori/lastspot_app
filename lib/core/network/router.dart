import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/startup/presentation/pages/splash_screen.dart';
import '../../features/startup/presentation/pages/maintenance_screen.dart';
import '../../features/startup/presentation/pages/force_update_screen.dart';
import '../../features/startup/presentation/bloc/startup_state.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/signup_screen.dart';
import '../../features/spot/presentation/pages/feed_screen.dart';
import '../../features/spot/presentation/bloc/feed_bloc.dart';
import '../../features/spot/presentation/pages/create_spot_screen.dart';
import '../../features/spot/presentation/bloc/create_spot_bloc.dart';
import '../../features/spot/presentation/pages/spot_details_screen.dart';
import '../../features/spot/presentation/bloc/spot_details_bloc.dart';
import '../../features/spot/presentation/pages/manage_requests_screen.dart';
import '../../features/spot/presentation/bloc/manage_requests_bloc.dart';
import '../../features/spot/presentation/pages/chat_screen.dart';
import '../../features/spot/data/repositories/spot_repository.dart';
import '../di/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/maintenance',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return MaintenanceScreen(
          title: extra['title'] ?? 'Maintenance',
          message: extra['message'] ?? 'We will be back soon.',
        );
      },
    ),
    GoRoute(
      path: '/force-update',
      builder: (context, state) {
        final updateData = state.extra as StartupUpdateRequired;
        return ForceUpdateScreen(updateData: updateData);
      },
    ),
    GoRoute(
      path: '/auth-check',
      redirect: (context, state) {
        final session = Supabase.instance.client.auth.currentSession;
        if (session != null) {
          return '/home';
        }
        return '/login';
      },
      builder: (context, state) => const Scaffold(body: Center(child: CircularProgressIndicator())),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
    GoRoute(
      path: '/home',
      builder: (context, state) => BlocProvider(
        create: (context) => FeedBloc(repository: sl<SpotRepository>()),
        child: const FeedScreen(),
      ),
    ),
    GoRoute(
      path: '/create-spot',
      builder: (context, state) => BlocProvider(
        create: (context) => CreateSpotBloc(repository: sl<SpotRepository>()),
        child: const CreateSpotScreen(),
      ),
    ),
    GoRoute(
      path: '/spot/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return BlocProvider(
          create: (context) => SpotDetailsBloc(repository: sl<SpotRepository>()),
          child: SpotDetailsScreen(postId: id),
        );
      },
    ),
    GoRoute(
      path: '/manage-requests/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return BlocProvider(
          create: (context) => ManageRequestsBloc(repository: sl<SpotRepository>()),
          child: ManageRequestsScreen(postId: id),
        );
      },
    ),
    GoRoute(
      path: '/chat/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ChatScreen(postId: id);
      },
    ),
  ],
);
