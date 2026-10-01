import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class UpdateUserCityUseCase {
  final ProfileRepository _repository;

  UpdateUserCityUseCase(this._repository);

  Future<void> call({
    required String userId,
    required String cityId,
    required String cityName,
  }) async {
    final currentProfile = await _repository.getProfile(userId);
    if (currentProfile != null) {
      final updatedProfile = UserProfile(
        id: currentProfile.id,
        fullName: currentProfile.fullName,
        avatarUrl: currentProfile.avatarUrl,
        phone: currentProfile.phone,
        email: currentProfile.email,
        status: currentProfile.status,
        isProfileCompleted: currentProfile.isProfileCompleted,
        createdAt: currentProfile.createdAt,
        deletedAt: currentProfile.deletedAt,
        bio: currentProfile.bio,
        city: cityName,
        cityId: cityId,
        sportsInterests: currentProfile.sportsInterests,
        rating: currentProfile.rating,
      );
      await _repository.updateProfile(updatedProfile);
    }
  }
}
