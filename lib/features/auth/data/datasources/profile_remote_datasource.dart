import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lastspot_app/core/network/api_endpoints.dart';
import '../../domain/entities/user_profile.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfile?> getProfile(String userId);
  Future<void> updateProfile(UserProfile profile);
  Future<String> uploadAvatar({
    required String userId,
    required File imageFile,
  });
  Future<Map<String, int>> getProfileStats(String userId);
}

class SupabaseProfileDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient _client;

  SupabaseProfileDataSourceImpl({required SupabaseClient client})
    : _client = client;

  @override
  Future<UserProfile?> getProfile(String userId) async {
    final response = await _client
        .from(ApiEndpoints.tableProfiles)
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response == null) return null;
    return UserProfile.fromJson(response);
  }

  @override
  Future<void> updateProfile(UserProfile profile) async {
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
  @override
  Future<Map<String, int>> getProfileStats(String userId) async {
    final createdResponse = await _client
        .from(ApiEndpoints.tableRequests)
        .select('id')
        .eq('user_id', userId)
        .count(CountOption.exact);

    final joinedResponse = await _client
        .from(ApiEndpoints.tableRequestParticipants)
        .select('id, requests!inner(user_id)')
        .eq('user_id', userId)
        .neq('requests.user_id', userId)
        .count(CountOption.exact);

    final completedResponse = await _client
        .from(ApiEndpoints.tableRequests)
        .select('id')
        .eq('user_id', userId)
        .eq('status', 'completed')
        .count(CountOption.exact);

    return {
      'createdCount': createdResponse.count,
      'joinedCount': joinedResponse.count,
      'completedCount': completedResponse.count,
    };
  }
}
