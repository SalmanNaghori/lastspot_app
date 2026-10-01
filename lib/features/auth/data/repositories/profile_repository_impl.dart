import 'dart:io';
import '../../../../core/network/base/base_repository.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/profile_model.dart';

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
    final profileModel = ProfileModel(
      id: profile.id,
      fullName: profile.fullName,
      avatarUrl: profile.avatarUrl,
      phone: profile.phone,
      email: profile.email,
      bio: profile.bio,
      city: profile.city,
      status: profile.status,
      isProfileCompleted: profile.isProfileCompleted,
      sportsInterests: profile.sportsInterests,
      rating: profile.rating,
      createdAt: profile.createdAt,
      deletedAt: profile.deletedAt,
    );
    return executeApiRaw(
      operationName: ApiEndpoints.profileUpdate,
      requestData: profileModel.toJson(),
      operation: () => _remoteDataSource.updateProfile(profileModel),
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
}
