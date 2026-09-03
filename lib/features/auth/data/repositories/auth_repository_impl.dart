import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({required AuthRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  String? getCurrentUserId() => _remoteDataSource.getCurrentUserId();

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    return _remoteDataSource.signUp(
      email: email,
      password: password,
      fullName: fullName,
    );
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    return _remoteDataSource.signIn(email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    return _remoteDataSource.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    return _remoteDataSource.sendPasswordResetEmail(email: email);
  }

  @override
  Future<void> verifyOtp({
    required String email,
    required String token,
    required String type,
  }) async {
    return _remoteDataSource.verifyOtp(email: email, token: token, type: type);
  }

  @override
  Future<void> resendOtp({required String email, required String type}) async {
    return _remoteDataSource.resendOtp(email: email, type: type);
  }
}
