import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lastspot_app/core/network/supabase_logger.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel?> getProfile(String userId);
  Future<void> updateProfile(ProfileModel profile);
  Future<String> uploadAvatar({
    required String userId,
    required File imageFile,
  });
}

class SupabaseProfileDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient _client;

  SupabaseProfileDataSourceImpl({required SupabaseClient client})
    : _client = client;

  @override
  Future<ProfileModel?> getProfile(String userId) async {
    return SupabaseLogger.execute(
      operationName: 'Profile.getProfile',
      requestData: {'userId': userId},
      operation: () async {
        final response = await _client
            .from('profiles')
            .select()
            .eq('id', userId)
            .maybeSingle();

        if (response == null) return null;
        return ProfileModel.fromJson(response);
      },
    );
  }

  @override
  Future<void> updateProfile(ProfileModel profile) async {
    return SupabaseLogger.execute(
      operationName: 'Profile.updateProfile',
      requestData: profile.toJson(),
      operation: () => _client.from('profiles').upsert(profile.toJson()),
    );
  }

  @override
  Future<String> uploadAvatar({
    required String userId,
    required File imageFile,
  }) async {
    final fileName = '$userId/profile.jpg';

    return SupabaseLogger.execute(
      operationName: 'Profile.uploadAvatar',
      requestData: {'userId': userId, 'fileName': fileName},
      operation: () async {
        // Upload image to the 'profiles' bucket
        await _client.storage
            .from('profiles')
            .upload(
              fileName,
              imageFile,
              fileOptions: const FileOptions(
                cacheControl: '3600',
                upsert: true,
              ),
            );

        // Get the public URL
        return _client.storage.from('profiles').getPublicUrl(fileName);
      },
    );
  }
}
