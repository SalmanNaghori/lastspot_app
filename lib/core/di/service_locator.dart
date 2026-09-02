import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../network/supabase_config.dart';

// Auth Data
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';

// Auth Domain
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/signup_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/reset_password_usecase.dart';
import '../../features/auth/domain/usecases/verify_otp_usecase.dart';
import '../../features/auth/domain/usecases/resend_otp_usecase.dart';
import '../../features/auth/domain/usecases/check_auth_status_usecase.dart';

// Spot Data
import '../../features/spot/data/repositories/spot_repository.dart';

final sl = GetIt.instance;

/// Call once in [main] before [runApp].
void setupServiceLocator() {
  // ── Core ──────────────────────────────────────────────
  sl.registerSingleton<SupabaseClient>(SupabaseConfig.client);

  // ── Data Sources ──────────────────────────────────────
  sl.registerSingleton<AuthRemoteDataSource>(
    SupabaseAuthDataSourceImpl(client: sl<SupabaseClient>()),
  );

  // ── Repositories ──────────────────────────────────────
  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(remoteDataSource: sl<AuthRemoteDataSource>()),
  );

  sl.registerSingleton<SpotRepository>(
    SpotRepository(client: sl<SupabaseClient>()),
  );

  // ── Use Cases ─────────────────────────────────────────
  sl.registerSingleton<LoginUseCase>(LoginUseCase(sl<AuthRepository>()));
  sl.registerSingleton<SignupUseCase>(SignupUseCase(sl<AuthRepository>()));
  sl.registerSingleton<LogoutUseCase>(LogoutUseCase(sl<AuthRepository>()));
  sl.registerSingleton<ResetPasswordUseCase>(ResetPasswordUseCase(sl<AuthRepository>()));
  sl.registerSingleton<VerifyOtpUseCase>(VerifyOtpUseCase(sl<AuthRepository>()));
  sl.registerSingleton<ResendOtpUseCase>(ResendOtpUseCase(sl<AuthRepository>()));
  sl.registerSingleton<CheckAuthStatusUseCase>(CheckAuthStatusUseCase(sl<AuthRepository>()));
}
