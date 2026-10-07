import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/get_profile_stats_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/upload_avatar_usecase.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/entities/profile_stats.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfile profile;
  final ProfileStats stats;
  ProfileLoaded(this.profile, [this.stats = const ProfileStats()]);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileSaved extends ProfileState {
  final UserProfile profile;
  final ProfileStats stats;
  ProfileSaved(this.profile, [this.stats = const ProfileStats()]);
}

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfile;
  final GetProfileStatsUseCase getProfileStats;
  final UpdateProfileUseCase updateProfile;
  final UploadAvatarUseCase uploadAvatar;

  ProfileCubit({
    required this.getProfile,
    required this.getProfileStats,
    required this.updateProfile,
    required this.uploadAvatar,
  }) : super(ProfileInitial());

  Future<void> fetchProfile(String userId) async {
    emit(ProfileLoading());
    try {
      final results = await Future.wait([
        getProfile(userId),
        getProfileStats(userId),
      ]);

      final profile = results[0] as UserProfile?;
      final statsMap = results[1] as Map<String, int>;

      if (profile != null) {
        final stats = ProfileStats(
          createdCount: statsMap['createdCount'] ?? 0,
          joinedCount: statsMap['joinedCount'] ?? 0,
          completedCount: statsMap['completedCount'] ?? 0,
        );
        emit(ProfileLoaded(profile, stats));
      } else {
        emit(ProfileError('Profile not found'));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  void setProfileLocally(UserProfile profile, [ProfileStats stats = const ProfileStats()]) {
    emit(ProfileLoaded(profile, stats));
  }

  Future<void> saveProfile({
    required UserProfile profile,
    File? avatarFile,
  }) async {
    emit(ProfileLoading());
    try {
      String? newAvatarUrl = profile.avatarUrl;
      if (avatarFile != null) {
        newAvatarUrl = await uploadAvatar(
          userId: profile.id,
          imageFile: avatarFile,
        );
      }

      final updatedProfile = UserProfile(
        id: profile.id,
        fullName: profile.fullName,
        avatarUrl: newAvatarUrl,
        phone: profile.phone,
        email: profile.email,
        bio: profile.bio,
        city: profile.city,
        cityId: profile.cityId,
        status: profile.status,
        isProfileCompleted: true, // Mark completed on every save
        sportsInterests: profile.sportsInterests,
        rating: profile.rating,
        createdAt: profile.createdAt,
        deletedAt: profile.deletedAt,
      );

      await updateProfile(updatedProfile);
      
      ProfileStats currentStats = const ProfileStats();
      if (state is ProfileLoaded) {
        currentStats = (state as ProfileLoaded).stats;
      }
      
      emit(ProfileSaved(updatedProfile, currentStats));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
