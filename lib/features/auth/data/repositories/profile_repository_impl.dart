import 'dart:io';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl({required ProfileRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<UserProfile?> getProfile(String userId) async {
    return await _remoteDataSource.getProfile(userId);
  }

  @override
  Future<void> updateProfile(UserProfile profile) async {
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
    await _remoteDataSource.updateProfile(profileModel);
  }

  @override
  Future<String> uploadAvatar({
    required String userId,
    required File imageFile,
  }) async {
    return await _remoteDataSource.uploadAvatar(
      userId: userId,
      imageFile: imageFile,
    );
  }
}
