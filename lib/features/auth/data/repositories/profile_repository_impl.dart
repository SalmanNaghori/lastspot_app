import 'dart:io';
import '../../../../core/network/base/base_repository.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl extends BaseRepository
    implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl({required ProfileRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<UserProfile?> getProfile(String userId) {
    return executeApiRaw(
      operationName: ApiEndpoints.profileGet,
      requestData: {'userId': userId},
      operation: () => _remoteDataSource.getProfile(userId),
    );
  }

  @override
  Future<void> updateProfile(UserProfile profile) {
    return executeApiRaw(
      operationName: ApiEndpoints.profileUpdate,
      requestData: profile.toJson(),
      operation: () => _remoteDataSource.updateProfile(profile),
    );
  }

  @override
  Future<String> uploadAvatar({
    required String userId,
    required File imageFile,
  }) {
    return executeApiRaw(
      operationName: ApiEndpoints.profileUploadAvatar,
      requestData: {'userId': userId, 'fileName': '$userId/profile.jpg'},
      operation: () =>
          _remoteDataSource.uploadAvatar(userId: userId, imageFile: imageFile),
    );
  }

  @override
  Future<Map<String, int>> getProfileStats(String userId) {
    return executeApiRaw(
      operationName: 'Profile.getProfileStats',
      requestData: {'userId': userId},
      operation: () => _remoteDataSource.getProfileStats(userId),
    );
  }
}
