import 'dart:io';
import '../repositories/profile_repository.dart';

class UploadAvatarUseCase {
  final ProfileRepository _repository;

  UploadAvatarUseCase(this._repository);

  Future<String> call({required String userId, required File imageFile}) {
    return _repository.uploadAvatar(userId: userId, imageFile: imageFile);
  }
}
