import 'dart:developer' as developer;

import 'package:skeletonizer/skeletonizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import 'core/base_import.dart';
import 'core/network/router.dart';
import 'core/services/account_session_service.dart';
import 'core/services/in_app_feedback_manager.dart';
import 'core/services/password_recovery_link_monitor.dart';
import 'core/widgets/env_banner.dart';
import 'core/widgets/app_keyboard_dismissal.dart';
import 'features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'features/auth/domain/usecases/get_profile_usecase.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/register_device_usecase.dart';
import 'features/auth/domain/usecases/resend_otp_usecase.dart';
import 'features/auth/domain/usecases/reset_password_usecase.dart';
import 'features/auth/domain/usecases/signup_usecase.dart';
import 'features/auth/domain/usecases/update_password_usecase.dart';
import 'features/auth/domain/usecases/verify_otp_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/categories/presentation/bloc/category_bloc.dart';
import 'features/cities/presentation/bloc/city_cubit.dart';
import 'features/settings/presentation/bloc/settings_cubit.dart';
import 'features/settings/presentation/bloc/settings_state.dart';
import 'features/startup/presentation/bloc/startup_bloc.dart';

class LastSpotApp extends StatelessWidget {
  const LastSpotApp({super.key});

  @override
  Widget build(BuildContext context) {
    final feedbackManager = appFeedbackManager;
    return RepositoryProvider<InAppFeedbackManager>.value(
      value: feedbackManager,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => StartupBloc(
              supabaseClient: sl<SupabaseClient>(),
              prefs: sl<SharedPrefsUtil>(),
            ),
          ),
          BlocProvider(
            create: (context) => AuthBloc(
              loginUseCase: sl<LoginUseCase>(),
              signupUseCase: sl<SignupUseCase>(),
              logoutUseCase: sl<LogoutUseCase>(),
              resetPasswordUseCase: sl<ResetPasswordUseCase>(),
              verifyOtpUseCase: sl<VerifyOtpUseCase>(),
              resendOtpUseCase: sl<ResendOtpUseCase>(),
              checkAuthStatusUseCase: sl<CheckAuthStatusUseCase>(),
              getProfileUseCase: sl<GetProfileUseCase>(),
              registerDeviceUseCase: sl<RegisterDeviceUseCase>(),
              accountSessionService: sl<AccountSessionService>(),
              updatePasswordUseCase: sl<UpdatePasswordUseCase>(),
              supabaseClient: sl<SupabaseClient>(),
              recoveryLinkMonitor: sl<PasswordRecoveryLinkMonitor>(),
            ),
          ),
          BlocProvider(create: (context) => sl<SettingsCubit>()),
          BlocProvider(create: (context) => sl<CityCubit>()),
          BlocProvider(create: (context) => sl<CategoryBloc>()),
        ],
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, settingsState) {
            final isDark =
                settingsState.themeMode == ThemeMode.dark ||
                (settingsState.themeMode == ThemeMode.system &&
                    MediaQuery.platformBrightnessOf(context) ==
                        Brightness.dark);

            return SkeletonizerConfig(
              data: SkeletonizerConfigData(
                effect: ShimmerEffect(
                  baseColor: isDark
                      ? AppColor.surfaceContainerDark
                      : AppColor.dividerLight,
                  highlightColor:
                      (isDark
                              ? settingsState.appThemeColor.darkPrimary
                              : settingsState.appThemeColor.primary)
                          .withValues(alpha: 0.5),
                ),
              ),
              child: MaterialApp.router(
                title: AppString.appName,
                onGenerateTitle: (context) =>
                    AppLocalizations.of(context)?.appName ?? AppString.appName,
                debugShowCheckedModeBanner: false,
                scaffoldMessengerKey: feedbackManager.messengerKey,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                locale: Locale(settingsState.locale, ''),
                themeMode: settingsState.themeMode,
                theme: AppTheme.lightThemeFor(settingsState.appThemeColor),
                darkTheme: AppTheme.darkThemeFor(settingsState.appThemeColor),
                routerConfig: appRouter,
                scrollBehavior: const MaterialScrollBehavior().copyWith(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                ),
                builder: (context, child) {
                  Dimensions.init(context);
                  return EnvBanner(
                    child: AppKeyboardDismissal(
                      child: BlocListener<AuthBloc, AuthState>(
                        listener: (context, state) {
                          if (state is Unauthenticated) {
                            feedbackManager.endSession();
                            appRouter.go(AppRoutes.login);
                          } else if (state is AuthSessionNeedsSignIn) {
                            feedbackManager.endSession();
                            appRouter.go(AppRoutes.login);
                            final message =
                                state.message ??
                                'This device session is not active. Please sign in again.';
                            developer.log(
                              'Showing sign-in session toast: $message',
                              name: 'LastSpot.AuthUI',
                              level: 1000,
                            );
                            feedbackManager.showFeedback(
                              SnackBar(content: Text(message)),
                              duration: const Duration(seconds: 4),
                            );
                          } else if (state is AuthSessionCheckUnavailable) {
                            // Do not display an intrusive persistent toast for transient connectivity
                            developer.log(
                              'Session check unavailable: ${state.message}',
                              name: 'LastSpot.AuthUI',
                              level: 800,
                            );
                          } else if (state is Authenticated) {
                            feedbackManager.setSessionActive(true);
                          } else if (state is AuthPasswordRecoveryReady ||
                              state is AuthPasswordRecoveryInvalid) {
                            appRouter.go(AppRoutes.resetPassword);
                          } else if (state is AuthPasswordRecoveryCompleted) {
                            appRouter.go(AppRoutes.login);
                            feedbackManager.showFeedback(
                              SnackBar(
                                content: Text(
                                  'Your password has been changed. Sign in with your new password.',
                                ),
                              ),
                            );
                          } else if (state is AuthSuspended ||
                              state is AuthBanned ||
                              state is AuthDeleted) {
                            feedbackManager.endSession();
                            appRouter.go(AppRoutes.accountStatus);
                          }
                        },
                        child: child ?? const SizedBox(),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
