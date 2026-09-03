import 'dart:io';
import '../entities/user_profile.dart';

abstract class ProfileRepository {
  /// Fetches a user profile by ID.
  Future<UserProfile?> getProfile(String userId);

  /// Creates or updates a user profile.
  Future<void> updateProfile(UserProfile profile);

  /// Uploads an avatar image and returns the URL.
  Future<String> uploadAvatar({
    required String userId,
    required File imageFile,
  });
}
