import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lastspot_app/core/l10n/app_localizations.dart';
import 'core/constants/app_color.dart';
import 'core/constants/dimensions.dart';
import 'core/network/supabase_config.dart';
import 'core/network/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/di/service_locator.dart';
import 'features/startup/presentation/bloc/startup_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/signup_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/reset_password_usecase.dart';
import 'features/auth/domain/usecases/verify_otp_usecase.dart';
import 'features/auth/domain/usecases/resend_otp_usecase.dart';
import 'features/auth/domain/usecases/check_auth_status_usecase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await SupabaseConfig.initialize();

  // Register all singletons
  setupServiceLocator();

  runApp(const LastSpotApp());
}

class LastSpotApp extends StatelessWidget {
  const LastSpotApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize responsive dimensions based on media query context
    // In a real app, you might use a builder, but for this MVP,
    // we set it at the top level when possible or inside a builder.

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => StartupBloc(supabaseClient: sl<SupabaseClient>())),
        BlocProvider(create: (context) => AuthBloc(
          loginUseCase: sl<LoginUseCase>(),
          signupUseCase: sl<SignupUseCase>(),
          logoutUseCase: sl<LogoutUseCase>(),
          resetPasswordUseCase: sl<ResetPasswordUseCase>(),
          verifyOtpUseCase: sl<VerifyOtpUseCase>(),
          resendOtpUseCase: sl<ResendOtpUseCase>(),
          checkAuthStatusUseCase: sl<CheckAuthStatusUseCase>(),
        )),
      ],
      child: Builder(
        builder: (context) {
          // Initialize dimensions safely here inside builder where MediaQuery is available
          // (Actually MediaQuery isn't available until MaterialApp, so we'll init it in a nested builder below)
          return MaterialApp.router(
            title: 'LastSpot',
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en', '')],
            themeMode: ThemeMode.system,
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              colorScheme: ColorScheme.light(
                primary: AppColor.primaryColor,
                secondary: AppColor.secondaryColor,
                surface: AppColor.surfaceLight,
              ),
              scaffoldBackgroundColor: AppColor.backgroundLight,
              textTheme: GoogleFonts.interTextTheme(
                ThemeData.light().textTheme,
              ).apply(bodyColor: AppColor.textPrimaryLight, displayColor: AppColor.textPrimaryLight),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              colorScheme: ColorScheme.dark(
                primary: AppColor.primaryColor,
                secondary: AppColor.primaryColor,
                surface: AppColor.surfaceDark,
              ),
              scaffoldBackgroundColor: AppColor.backgroundDark,
              textTheme: GoogleFonts.interTextTheme(
                ThemeData.dark().textTheme,
              ).apply(bodyColor: AppColor.textPrimaryDark, displayColor: AppColor.textPrimaryDark),
            ),
            routerConfig: appRouter,
            builder: (context, child) {
              Dimensions.init(context);
              return child ?? const SizedBox();
            },
          );
        },
      ),
    );
  }
}
