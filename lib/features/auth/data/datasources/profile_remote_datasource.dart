import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lastspot_app/core/network/api_endpoints.dart';
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
    final response = await _client
        .from(ApiEndpoints.tableProfiles)
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response == null) return null;
    return ProfileModel.fromJson(response);
  }

  @override
  Future<void> updateProfile(ProfileModel profile) async {
    await _client.from(ApiEndpoints.tableProfiles).upsert(profile.toJson());
  }

  @override
  Future<String> uploadAvatar({
    required String userId,
    required File imageFile,
  }) async {
    final fileName = '$userId/profile.jpg';

    // Upload image to the 'profiles' bucket
    await _client.storage
        .from(ApiEndpoints.bucketProfiles)
        .upload(
          fileName,
          imageFile,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
        );

    // Get the public URL
    return _client.storage
        .from(ApiEndpoints.bucketProfiles)
        .getPublicUrl(fileName);
  }
}
