import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/upload_avatar_usecase.dart';
import '../../domain/entities/user_profile.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfile profile;
  ProfileLoaded(this.profile);
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileSaved extends ProfileState {
  final UserProfile profile;
  ProfileSaved(this.profile);
}

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfile;
  final UpdateProfileUseCase updateProfile;
  final UploadAvatarUseCase uploadAvatar;

  ProfileCubit({
    required this.getProfile,
    required this.updateProfile,
    required this.uploadAvatar,
  }) : super(ProfileInitial());

  Future<void> fetchProfile(String userId) async {
    emit(ProfileLoading());
    try {
      final profile = await getProfile(userId);
      if (profile != null) {
        emit(ProfileLoaded(profile));
      } else {
        emit(ProfileError('Profile not found'));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  void setProfileLocally(UserProfile profile) {
    emit(ProfileLoaded(profile));
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
        status: profile.status,
        isProfileCompleted: true, // Mark completed on every save
        sportsInterests: profile.sportsInterests,
        rating: profile.rating,
        createdAt: profile.createdAt,
        deletedAt: profile.deletedAt,
      );

      await updateProfile(updatedProfile);
      emit(ProfileSaved(updatedProfile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
