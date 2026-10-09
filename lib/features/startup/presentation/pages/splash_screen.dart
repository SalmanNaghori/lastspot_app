import 'dart:math' as math;

import 'package:url_launcher/url_launcher.dart';
import 'package:lastspot_app/core/base_import.dart';
import 'package:lastspot_app/gen/assets.gen.dart';
import 'package:lottie/lottie.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/startup_bloc.dart';
import '../bloc/startup_event.dart';
import '../bloc/startup_state.dart';
import '../../data/models/app_settings_model.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/utils/shared_prefs_util.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: const [SystemUiOverlay.bottom],
    );
    context.read<StartupBloc>().add(StartupInitialCheckRequested());
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<StartupBloc, StartupState>(
          listener: (context, state) {
            state.maybeWhen(
              success: () {
                _continueAfterStartup(context);
              },
              maintenanceMode: (title, message) {
                context.go(
                  AppRoutes.maintenance,
                  extra: {'title': title, 'message': message},
                );
              },
              updateRequired: (messageData, storeUrl, isForced, latestVersion) {
                if (isForced) {
                  context.go(
                    AppRoutes.forceUpdate,
                    extra: {'messageData': messageData, 'storeUrl': storeUrl},
                  );
                } else {
                  _showSoftUpdateDialog(
                    context,
                    messageData,
                    storeUrl,
                    latestVersion,
                  );
                }
              },
              orElse: () {},
            );
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              context.go(AppRoutes.home);
            } else if (state is Unauthenticated || state is AuthError) {
              context.go(AppRoutes.login);
            } else if (state is AuthProfileIncomplete) {
              context.go(AppRoutes.profileSetup);
            } else if (state is AuthSuspended ||
                state is AuthBanned ||
                state is AuthDeleted) {
              context.go(AppRoutes.accountStatus);
            }
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          final colors = context.colorScheme;
          final animationSize = math.min(
            math.min(
              MediaQuery.sizeOf(context).width * 0.96,
              MediaQuery.sizeOf(context).height * 0.48,
            ),
            420.0,
          );
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: AppTheme.systemUiOverlayStyle(context),
            child: Scaffold(
              backgroundColor: colors.surface,
              body: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 10,
                    left: 0,
                    right: 0,
                    height: animationSize,
                    child: Center(
                      child: Lottie.asset(
                        Assets.ain.anSplashScreen.path,
                        width: animationSize,
                        height: animationSize,
                        repeat: true,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Positioned(
                    left: Dimensions.w(24),
                    right: Dimensions.w(24),
                    bottom:
                        MediaQuery.viewPaddingOf(context).bottom +
                        Dimensions.h50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Welcome to',
                          textAlign: TextAlign.center,
                          style: context.titleLarge?.copyWith(
                            color: colors.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          context.loc.appName,
                          textAlign: TextAlign.center,
                          style: context.headlineMedium?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.6,
                          ),
                        ),
                        SizedBox(height: Dimensions.h(28)),
                        SizedBox(
                          width: Dimensions.w(132),
                          child: LinearProgressIndicator(
                            minHeight: Dimensions.h(4),
                            borderRadius: BorderRadius.circular(
                              Dimensions.r999,
                            ),
                            backgroundColor: colors.primary.withValues(
                              alpha: 0.12,
                            ),
                            color: colors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _continueAfterStartup(BuildContext context) async {
    final prefs = sl<SharedPrefsUtil>();
    await prefs.reload();
    if (!context.mounted) return;

    final hasCompletedOnboarding = prefs.getBool(
      SharedPrefsKeys.onboardingCompleted,
    );
    if (hasCompletedOnboarding) {
      context.read<AuthBloc>().add(AuthCheckRequested());
    } else {
      context.go(AppRoutes.onboarding);
    }
  }

  void _showSoftUpdateDialog(
    BuildContext context,
    VersionMessage messageData,
    String storeUrl,
    String? latestVersion,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(messageData.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(messageData.message),
              const SizedBox(height: 16),
              ...messageData.releaseNotes.map((note) => Text('• $note')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final startupBloc = context.read<StartupBloc>();
                Navigator.pop(dialogContext);
                if (latestVersion != null) {
                  startupBloc.add(StartupUpdateSkipped(latestVersion));
                } else {
                  _continueAfterStartup(context);
                }
              },
              child: const Text('Maybe Later'),
            ),
            ElevatedButton(
              onPressed: () async {
                final startupBloc = context.read<StartupBloc>();
                Navigator.pop(dialogContext);
                if (storeUrl.isNotEmpty) {
                  final uri = Uri.tryParse(storeUrl);
                  if (uri != null && await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                }
                if (latestVersion != null) {
                  startupBloc.add(StartupUpdateSkipped(latestVersion));
                } else if (context.mounted) {
                  _continueAfterStartup(context);
                }
              },
              child: const Text('Update Now'),
            ),
          ],
        );
      },
    );
  }
}
