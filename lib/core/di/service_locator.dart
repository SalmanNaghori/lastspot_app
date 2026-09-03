import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/supabase_config.dart';
import '../utils/shared_prefs_util.dart';

// Auth Data
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/data/datasources/profile_remote_datasource.dart';
import '../../features/auth/data/repositories/profile_repository_impl.dart';
import '../../features/auth/data/datasources/device_remote_datasource.dart';
import '../../features/auth/data/repositories/device_repository_impl.dart';

// Category Data
import '../../features/categories/data/datasources/category_remote_datasource.dart';
import '../../features/categories/data/repositories/category_repository_impl.dart';

// Category Domain
import '../../features/categories/domain/repositories/category_repository.dart';
import '../../features/categories/domain/usecases/get_categories_usecase.dart';

// Auth Domain
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/repositories/profile_repository.dart';
import '../../features/auth/domain/repositories/device_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/signup_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/reset_password_usecase.dart';
import '../../features/auth/domain/usecases/verify_otp_usecase.dart';
import '../../features/auth/domain/usecases/resend_otp_usecase.dart';
import '../../features/auth/domain/usecases/check_auth_status_usecase.dart';
import '../../features/auth/domain/usecases/get_profile_usecase.dart';
import '../../features/auth/domain/usecases/update_profile_usecase.dart';
import '../../features/auth/domain/usecases/upload_avatar_usecase.dart';
import '../../features/auth/domain/usecases/register_device_usecase.dart';
import '../../features/auth/presentation/bloc/profile_cubit.dart';

// Spot Data
import '../../features/spot/data/datasources/spot_remote_datasource.dart';
import '../../features/spot/data/repositories/spot_repository_impl.dart';

// Spot Domain
import '../../features/spot/domain/repositories/spot_repository.dart';

// Spot Domain
import '../../features/spot/domain/usecases/create_spot_usecase.dart';
import '../../features/spot/domain/usecases/get_spot_details_usecase.dart';
import '../../features/spot/domain/usecases/get_spots_usecase.dart';
import '../../features/spot/domain/usecases/join_spot_usecase.dart';
import '../../features/spot/domain/usecases/manage_join_request_usecase.dart';
import '../../features/spot/domain/usecases/stream_spot_join_requests_usecase.dart';
import '../../features/spot/domain/usecases/get_confirmed_players_usecase.dart';

// Settings
import '../../features/settings/presentation/bloc/settings_cubit.dart';

final sl = GetIt.instance;

/// Call once in [main] before [runApp].
Future<void> setupServiceLocator() async {
  // ── Core ──────────────────────────────────────────────
  sl.registerSingleton<SupabaseClient>(SupabaseConfig.client);

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<SharedPrefsUtil>(
    () => SharedPrefsUtilImpl(sl<SharedPreferences>()),
  );

  // ── Blocs ─────────────────────────────────────────────
  sl.registerFactory<SettingsCubit>(
    () => SettingsCubit(prefs: sl<SharedPrefsUtil>()),
  );

  // ── Data Sources ──────────────────────────────────────
  sl.registerSingleton<AuthRemoteDataSource>(
    SupabaseAuthDataSourceImpl(client: sl<SupabaseClient>()),
  );

  sl.registerSingleton<ProfileRemoteDataSource>(
    SupabaseProfileDataSourceImpl(client: sl<SupabaseClient>()),
  );

  sl.registerSingleton<DeviceRemoteDataSource>(
    SupabaseDeviceDataSourceImpl(client: sl<SupabaseClient>()),
  );

  sl.registerSingleton<CategoryRemoteDataSource>(
    SupabaseCategoryDataSourceImpl(client: sl<SupabaseClient>()),
  );

  // ── Repositories ──────────────────────────────────────
  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(remoteDataSource: sl<AuthRemoteDataSource>()),
  );

  sl.registerSingleton<ProfileRepository>(
    ProfileRepositoryImpl(remoteDataSource: sl<ProfileRemoteDataSource>()),
  );

  sl.registerSingleton<DeviceRepository>(
    DeviceRepositoryImpl(remoteDataSource: sl<DeviceRemoteDataSource>()),
  );

  sl.registerSingleton<CategoryRepository>(
    CategoryRepositoryImpl(remoteDataSource: sl<CategoryRemoteDataSource>()),
  );

  sl.registerSingleton<SpotRemoteDataSource>(
    SupabaseSpotDataSourceImpl(client: sl<SupabaseClient>()),
  );

  sl.registerSingleton<SpotRepository>(
    SpotRepositoryImpl(
      remoteDataSource: sl<SpotRemoteDataSource>(),
      supabaseClient: sl<SupabaseClient>(),
    ),
  );

  // ── Use Cases ─────────────────────────────────────────
  sl.registerSingleton<LoginUseCase>(LoginUseCase(sl<AuthRepository>()));
  sl.registerSingleton<SignupUseCase>(SignupUseCase(sl<AuthRepository>()));
  sl.registerSingleton<LogoutUseCase>(LogoutUseCase(sl<AuthRepository>()));
  sl.registerSingleton<ResetPasswordUseCase>(
    ResetPasswordUseCase(sl<AuthRepository>()),
  );
  sl.registerSingleton<VerifyOtpUseCase>(
    VerifyOtpUseCase(sl<AuthRepository>()),
  );
  sl.registerSingleton<ResendOtpUseCase>(
    ResendOtpUseCase(sl<AuthRepository>()),
  );
  sl.registerSingleton<CheckAuthStatusUseCase>(
    CheckAuthStatusUseCase(sl<AuthRepository>()),
  );

  sl.registerSingleton<GetProfileUseCase>(
    GetProfileUseCase(sl<ProfileRepository>()),
  );
  sl.registerSingleton<UpdateProfileUseCase>(
    UpdateProfileUseCase(sl<ProfileRepository>()),
  );
  sl.registerSingleton<UploadAvatarUseCase>(
    UploadAvatarUseCase(sl<ProfileRepository>()),
  );

  sl.registerFactory<ProfileCubit>(
    () => ProfileCubit(
      getProfile: sl<GetProfileUseCase>(),
      updateProfile: sl<UpdateProfileUseCase>(),
      uploadAvatar: sl<UploadAvatarUseCase>(),
    ),
  );

  sl.registerSingleton<RegisterDeviceUseCase>(
    RegisterDeviceUseCase(sl<DeviceRepository>()),
  );

  sl.registerSingleton<GetCategoriesUseCase>(
    GetCategoriesUseCase(sl<CategoryRepository>()),
  );

  sl.registerSingleton<CreateSpotUseCase>(
    CreateSpotUseCase(sl<SpotRepository>()),
  );
  sl.registerSingleton<GetSpotDetailsUseCase>(
    GetSpotDetailsUseCase(sl<SpotRepository>()),
  );
  sl.registerSingleton<GetSpotsUseCase>(GetSpotsUseCase(sl<SpotRepository>()));
  sl.registerSingleton<JoinSpotUseCase>(JoinSpotUseCase(sl<SpotRepository>()));
  sl.registerSingleton<GetConfirmedPlayersUseCase>(
    GetConfirmedPlayersUseCase(sl<SpotRepository>()),
  );
  sl.registerSingleton<ManageJoinRequestUseCase>(
    ManageJoinRequestUseCase(sl<SpotRepository>()),
  );
  sl.registerSingleton<StreamSpotJoinRequestsUseCase>(
    StreamSpotJoinRequestsUseCase(sl<SpotRepository>()),
  );
}
