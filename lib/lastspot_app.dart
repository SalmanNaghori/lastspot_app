import 'core/base_import.dart';
import 'core/utils/shared_prefs_util.dart';
import 'core/network/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'core/di/service_locator.dart';
import 'features/settings/presentation/bloc/settings_cubit.dart';
import 'features/settings/presentation/bloc/settings_state.dart';
import 'features/startup/presentation/bloc/startup_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/signup_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/reset_password_usecase.dart';
import 'features/auth/domain/usecases/verify_otp_usecase.dart';
import 'features/auth/domain/usecases/resend_otp_usecase.dart';
import 'features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'features/auth/domain/usecases/get_profile_usecase.dart';
import 'features/auth/domain/usecases/register_device_usecase.dart';

class LastSpotApp extends StatelessWidget {
  const LastSpotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => StartupBloc(supabaseClient: sl<SupabaseClient>(), prefs: sl<SharedPrefsUtil>()),
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
          ),
        ),
        BlocProvider(create: (context) => sl<SettingsCubit>()),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settingsState) {
          return MaterialApp.router(
            title: AppString.appName,
            onGenerateTitle: (context) => AppLocalizations.of(context)?.appName ?? AppString.appName,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale(settingsState.locale, ''),
            themeMode: settingsState.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            routerConfig: appRouter,
            builder: (context, child) {
              Dimensions.init(context);
              return GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is Unauthenticated) {
                      appRouter.go(AppRoutes.login);
                    } else if (state is AuthSuspended || state is AuthBanned || state is AuthDeleted) {
                      appRouter.go(AppRoutes.accountStatus);
                    }
                  },
                  child: child ?? const SizedBox(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
