import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:lastspot_app/core/services/account_session_service.dart';
import 'package:lastspot_app/core/services/password_recovery_link_monitor.dart';
import 'package:lastspot_app/core/utils/result.dart';
import 'package:lastspot_app/features/auth/domain/entities/user_profile.dart';
import 'package:lastspot_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:lastspot_app/features/auth/domain/repositories/device_repository.dart';
import 'package:lastspot_app/features/auth/domain/repositories/profile_repository.dart';
import 'package:lastspot_app/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:lastspot_app/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:lastspot_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:lastspot_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:lastspot_app/features/auth/domain/usecases/register_device_usecase.dart';
import 'package:lastspot_app/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:lastspot_app/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:lastspot_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:lastspot_app/features/auth/domain/usecases/update_password_usecase.dart';
import 'package:lastspot_app/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:lastspot_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lastspot_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:lastspot_app/features/auth/presentation/bloc/auth_state.dart';

class FakeSupabaseClient extends Fake implements supabase.SupabaseClient {
  final _auth = FakeGoTrueClient();
  @override
  supabase.GoTrueClient get auth => _auth;
}

class FakeGoTrueClient extends Fake implements supabase.GoTrueClient {
  final _controller = StreamController<supabase.AuthState>.broadcast();
  supabase.Session? _session;

  @override
  Stream<supabase.AuthState> get onAuthStateChange => _controller.stream;

  @override
  supabase.Session? get currentSession => _session;
}

class FakeAccountSessionService extends Fake implements AccountSessionService {
  AccountSessionStatus freshStatus = AccountSessionStatus.active;
  AccountSessionStatus validateStatus = AccountSessionStatus.active;
  bool localSessionCleared = false;
  int activateCalls = 0;
  int validateCalls = 0;

  @override
  Future<AccountSessionStatus> activateFreshSession() async {
    activateCalls++;
    return freshStatus;
  }

  @override
  Future<AccountSessionStatus> validateCurrentSession() async {
    validateCalls++;
    return validateStatus;
  }

  @override
  Future<void> clearLocalSession() async {
    localSessionCleared = true;
  }
}

class FakeAuthRepository extends Fake implements AuthRepository {
  String? currentUserId = 'test-user-id';
  Result<void, Exception> loginResult = const Success(null);

  @override
  String? getCurrentUserId() => currentUserId;

  @override
  Future<Result<void, Exception>> signIn({
    required String email,
    required String password,
  }) async => loginResult;

  @override
  Future<Result<void, Exception>> signOut() async => const Success(null);
}

class FakeProfileRepository extends Fake implements ProfileRepository {
  UserProfile? profileToReturn;

  @override
  Future<UserProfile?> getProfile(String userId) async => profileToReturn;
}

class FakeDeviceRepository extends Fake implements DeviceRepository {
  bool registerCalled = false;
  String? registeredUserId;
  Exception? shouldThrow;

  @override
  Future<void> registerDevice(String userId) async {
    registerCalled = true;
    registeredUserId = userId;
    if (shouldThrow != null) throw shouldThrow!;
  }

  @override
  Future<void> unregisterDevice(String userId) async {}
}

void main() {
  group('AuthBloc Device Registration & Session Lifecycle', () {
    late FakeSupabaseClient fakeClient;
    late FakeAccountSessionService fakeAccountService;
    late FakeAuthRepository fakeAuthRepo;
    late FakeProfileRepository fakeProfileRepo;
    late FakeDeviceRepository fakeDeviceRepo;
    late PasswordRecoveryLinkMonitor monitor;
    late AuthBloc authBloc;

    setUp(() {
      fakeClient = FakeSupabaseClient();
      fakeAccountService = FakeAccountSessionService();
      fakeAuthRepo = FakeAuthRepository();
      fakeProfileRepo = FakeProfileRepository();
      fakeDeviceRepo = FakeDeviceRepository();
      monitor = PasswordRecoveryLinkMonitor.instance;
      monitor.clear();

      authBloc = AuthBloc(
        loginUseCase: LoginUseCase(fakeAuthRepo),
        signupUseCase: SignupUseCase(fakeAuthRepo),
        logoutUseCase: LogoutUseCase(fakeAuthRepo, fakeDeviceRepo),
        resetPasswordUseCase: ResetPasswordUseCase(fakeAuthRepo),
        verifyOtpUseCase: VerifyOtpUseCase(fakeAuthRepo),
        resendOtpUseCase: ResendOtpUseCase(fakeAuthRepo),
        checkAuthStatusUseCase: CheckAuthStatusUseCase(fakeAuthRepo),
        getProfileUseCase: GetProfileUseCase(fakeProfileRepo),
        registerDeviceUseCase: RegisterDeviceUseCase(fakeDeviceRepo),
        accountSessionService: fakeAccountService,
        updatePasswordUseCase: UpdatePasswordUseCase(fakeAuthRepo),
        supabaseClient: fakeClient,
        recoveryLinkMonitor: monitor,
      );
    });

    tearDown(() async {
      await authBloc.close();
    });

    test(
      'login with incomplete profile registers device before emitting AuthProfileIncomplete',
      () async {
        fakeProfileRepo.profileToReturn = UserProfile(
          id: 'test-user-id',
          isProfileCompleted: false,
          createdAt: DateTime.now(),
        );

        final states = <AuthState>[];
        final sub = authBloc.stream.listen(states.add);

        authBloc.add(
          const AuthLoginRequested(
            email: 'test@example.com',
            password: 'password123',
          ),
        );

        await Future.delayed(const Duration(milliseconds: 50));
        await sub.cancel();

        expect(fakeDeviceRepo.registerCalled, isTrue);
        expect(fakeDeviceRepo.registeredUserId, equals('test-user-id'));
        expect(states, contains(isA<AuthProfileIncomplete>()));
        expect(states.last, isA<AuthProfileIncomplete>());
      },
    );

    test(
      'login when device registration fails clears session and emits AuthSessionNeedsSignIn',
      () async {
        fakeProfileRepo.profileToReturn = UserProfile(
          id: 'test-user-id',
          isProfileCompleted: false,
          createdAt: DateTime.now(),
        );
        fakeDeviceRepo.shouldThrow = Exception(
          'RPC register_my_device timed out',
        );

        final states = <AuthState>[];
        final sub = authBloc.stream.listen(states.add);

        authBloc.add(
          const AuthLoginRequested(
            email: 'test@example.com',
            password: 'password123',
          ),
        );

        await Future.delayed(const Duration(milliseconds: 50));
        await sub.cancel();

        expect(fakeDeviceRepo.registerCalled, isTrue);
        expect(fakeAccountService.localSessionCleared, isTrue);
        expect(states, contains(isA<AuthSessionNeedsSignIn>()));
        expect(states.last, isA<AuthSessionNeedsSignIn>());
      },
    );

    test(
      'profile completion updates AuthBloc to Authenticated without duplicate registration',
      () async {
        final states = <AuthState>[];
        final sub = authBloc.stream.listen(states.add);

        authBloc.add(AuthProfileCompleted());

        await Future.delayed(const Duration(milliseconds: 20));
        await sub.cancel();

        expect(states, [isA<Authenticated>()]);
        // Duplicate registration should NOT happen on profile completed
        expect(fakeDeviceRepo.registerCalled, isFalse);
      },
    );

    test(
      'app resume validation on active session emits Authenticated',
      () async {
        fakeAccountService.validateStatus = AccountSessionStatus.active;

        final states = <AuthState>[];
        final sub = authBloc.stream.listen(states.add);

        authBloc.add(AuthSessionValidationRequested());

        await Future.delayed(const Duration(milliseconds: 20));
        await sub.cancel();

        expect(states, contains(isA<Authenticated>()));
        expect(fakeAccountService.validateCalls, equals(1));
      },
    );

    test(
      'app resume validation when profile incomplete preserves AuthProfileIncomplete',
      () async {
        // First put bloc in AuthProfileIncomplete state
        fakeProfileRepo.profileToReturn = UserProfile(
          id: 'test-user-id',
          isProfileCompleted: false,
          createdAt: DateTime.now(),
        );

        authBloc.add(
          const AuthLoginRequested(
            email: 'test@example.com',
            password: 'password123',
          ),
        );
        await Future.delayed(const Duration(milliseconds: 50));
        expect(authBloc.state, isA<AuthProfileIncomplete>());

        // Now resume validation occurs
        fakeAccountService.validateStatus = AccountSessionStatus.active;
        final states = <AuthState>[];
        final sub = authBloc.stream.listen(states.add);

        authBloc.add(AuthSessionValidationRequested());

        await Future.delayed(const Duration(milliseconds: 50));
        await sub.cancel();

        expect(states, contains(isA<AuthProfileIncomplete>()));
        expect(authBloc.state, isA<AuthProfileIncomplete>());
      },
    );

    test(
      'session revocation by another device emits AuthSessionNeedsSignIn and clears local session',
      () async {
        fakeAccountService.validateStatus =
            AccountSessionStatus.inactiveOrUninitialized;

        final states = <AuthState>[];
        final sub = authBloc.stream.listen(states.add);

        authBloc.add(AuthSessionValidationRequested());

        await Future.delayed(const Duration(milliseconds: 20));
        await sub.cancel();

        expect(fakeAccountService.localSessionCleared, isTrue);
        expect(states, contains(isA<AuthSessionNeedsSignIn>()));
      },
    );
  });
}
