import '../../../../core/network/base/base_repository.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/utils/result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl extends BaseRepository implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({required AuthRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  String? getCurrentUserId() => _remoteDataSource.getCurrentUserId();

  @override
  Future<Result<void, Exception>> signUp({
    required String email,
    required String password,
    required String fullName,
  }) {
    return executeApi(
      operationName: ApiEndpoints.authSignUp,
      requestData: {'email': email, 'full_name': fullName},
      operation: () => _remoteDataSource.signUp(
        email: email,
        password: password,
        fullName: fullName,
      ),
    );
  }

  @override
  Future<Result<void, Exception>> signIn({
    required String email,
    required String password,
  }) {
    return executeApi(
      operationName: ApiEndpoints.authSignIn,
      requestData: {'email': email},
      operation: () =>
          _remoteDataSource.signIn(email: email, password: password),
    );
  }

  @override
  Future<Result<void, Exception>> signOut() {
    return executeApi(
      operationName: ApiEndpoints.authSignOut,
      operation: () => _remoteDataSource.signOut(),
    );
  }

  @override
  Future<Result<void, Exception>> sendPasswordResetEmail({
    required String email,
  }) {
    return executeApi(
      operationName: ApiEndpoints.authResetPassword,
      requestData: {'email': email},
      operation: () => _remoteDataSource.sendPasswordResetEmail(email: email),
    );
  }

  @override
  Future<Result<void, Exception>> verifyOtp({
    required String email,
    required String token,
    required String type,
  }) {
    return executeApi(
      operationName: ApiEndpoints.authVerifyOtp,
      requestData: {'email': email, 'type': type},
      operation: () =>
          _remoteDataSource.verifyOtp(email: email, token: token, type: type),
    );
  }

  @override
  Future<Result<void, Exception>> resendOtp({
    required String email,
    required String type,
  }) {
    return executeApi(
      operationName: ApiEndpoints.authResendOtp,
      requestData: {'email': email, 'type': type},
      operation: () => _remoteDataSource.resendOtp(email: email, type: type),
    );
  }
}
