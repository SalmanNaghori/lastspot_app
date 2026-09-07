import 'dart:io';

import '../../../../core/network/network_exceptions.dart';
import '../../../../core/utils/result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
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
  }) async {
    try {
      await _remoteDataSource.signUp(
        email: email,
        password: password,
        fullName: fullName,
      );
      return const Success(null);
    } on SocketException catch (_) {
      return const Failure(NoInternetException());
    } on Exception catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<void, Exception>> signIn({required String email, required String password}) async {
    try {
      await _remoteDataSource.signIn(email: email, password: password);
      return const Success(null);
    } on SocketException catch (_) {
      return const Failure(NoInternetException());
    } on Exception catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<void, Exception>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Success(null);
    } on SocketException catch (_) {
      return const Failure(NoInternetException());
    } on Exception catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<void, Exception>> sendPasswordResetEmail({required String email}) async {
    try {
      await _remoteDataSource.sendPasswordResetEmail(email: email);
      return const Success(null);
    } on SocketException catch (_) {
      return const Failure(NoInternetException());
    } on Exception catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<void, Exception>> verifyOtp({
    required String email,
    required String token,
    required String type,
  }) async {
    try {
      await _remoteDataSource.verifyOtp(email: email, token: token, type: type);
      return const Success(null);
    } on SocketException catch (_) {
      return const Failure(NoInternetException());
    } on Exception catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }

  @override
  Future<Result<void, Exception>> resendOtp({required String email, required String type}) async {
    try {
      await _remoteDataSource.resendOtp(email: email, type: type);
      return const Success(null);
    } on SocketException catch (_) {
      return const Failure(NoInternetException());
    } on Exception catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
