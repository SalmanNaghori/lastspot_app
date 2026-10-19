import 'package:lastspot_app/core/base_import.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../data/models/app_settings_model.dart';
import '../bloc/startup_bloc.dart';
import '../bloc/startup_event.dart';
import '../bloc/startup_state.dart';
import '../widgets/splash_branding_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: const [SystemUiOverlay.bottom],
    );

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.75, curve: Curves.easeOutCubic),
    );

    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    _animController.forward();
    context.read<StartupBloc>().add(StartupInitialCheckRequested());
  }

  @override
  void dispose() {
    _animController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _onStartupStateChanged(BuildContext context, StartupState state) {
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
          _showSoftUpdateDialog(context, messageData, storeUrl, latestVersion);
        }
      },
      orElse: () {},
    );
  }

  void _onAuthStateChanged(BuildContext context, AuthState state) {
    if (state is Authenticated) {
      context.go(AppRoutes.home);
    } else if (state is Unauthenticated || state is AuthError) {
      context.go(AppRoutes.login);
    } else if (state is AuthSessionNeedsSignIn ||
        state is AuthSessionCheckUnavailable) {
      // A validation outage keeps the local Supabase session intact;
      // login is shown as a safe recovery surface until it can be
      // verified or the user signs in again.
      context.go(AppRoutes.login);
    } else if (state is AuthProfileIncomplete) {
      context.go(AppRoutes.profileSetup);
    } else if (state is AuthSuspended ||
        state is AuthBanned ||
        state is AuthDeleted) {
      context.go(AppRoutes.accountStatus);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<StartupBloc, StartupState>(
          listener: _onStartupStateChanged,
        ),
        BlocListener<AuthBloc, AuthState>(listener: _onAuthStateChanged),
      ],
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          systemNavigationBarColor: AppColor.primaryColor,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: AppColor.primaryColor,
          body: SplashBrandingView(
            fadeAnimation: _fadeAnimation,
            scaleAnimation: _scaleAnimation,
          ),
        ),
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
              SizedBox(height: Dimensions.r16.dynamicH),
              ...messageData.releaseNotes.map((note) => Text('• $note')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  _onMaybeLaterPressed(context, dialogContext, latestVersion),
              child: Text(context.loc.maybeLater),
            ),
            ElevatedButton(
              onPressed: () => _onUpdateNowPressed(
                context,
                dialogContext,
                storeUrl,
                latestVersion,
              ),
              child: Text(context.loc.updateNow),
            ),
          ],
        );
      },
    );
  }

  void _onMaybeLaterPressed(
    BuildContext context,
    BuildContext dialogContext,
    String? latestVersion,
  ) {
    final startupBloc = context.read<StartupBloc>();
    Navigator.pop(dialogContext);
    if (latestVersion != null) {
      startupBloc.add(StartupUpdateSkipped(latestVersion));
    } else {
      _continueAfterStartup(context);
    }
  }

  Future<void> _onUpdateNowPressed(
    BuildContext context,
    BuildContext dialogContext,
    String storeUrl,
    String? latestVersion,
  ) async {
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
  }
}
