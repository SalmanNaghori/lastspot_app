import 'dart:io';
import 'dart:developer' as developer;
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
    var session = _client.auth.currentSession;
    if (session == null) {
      developer.log(
        'Avatar upload blocked: no active Supabase session.',
        name: 'Supabase.Profile',
      );
      throw const AuthException(
        'Please sign in again before uploading a profile photo.',
      );
    }

    if (session.isExpired) {
      developer.log(
        'Avatar upload session is expired; refreshing it for authUid=${session.user.id}.',
        name: 'Supabase.Profile',
      );
      await _client.auth.refreshSession();
      session = _client.auth.currentSession;
    }

    final authUser = _client.auth.currentUser;
    developer.log(
      'Avatar upload identity: authUid=${authUser?.id}, '
      'requestedUid=$userId, sessionPresent=${session != null}, '
      'sessionExpired=${session?.isExpired ?? true}',
      name: 'Supabase.Profile',
    );

    if (session == null || authUser == null || session.isExpired) {
      throw const AuthException(
        'Your sign-in session is unavailable or expired. Please sign in again.',
      );
    }

    if (authUser.id != session.user.id || userId != authUser.id) {
      throw const AuthException(
        'The signed-in account changed. Reload your profile and try again.',
      );
    }

    // Always scope the object to the currently authenticated account.
    final fileName = '${authUser.id}/profile.jpg';

    // Upload image to the 'profiles' bucket
    await _client.storage
        .from(ApiEndpoints.bucketProfiles)
        .upload(
          fileName,
          imageFile,
          fileOptions: const FileOptions(
            cacheControl: '3600',
            contentType: 'image/jpeg',
            upsert: true,
          ),
        );

    final publicUrl = _client.storage
        .from(ApiEndpoints.bucketProfiles)
        .getPublicUrl(fileName);
    final publicUri = Uri.parse(publicUrl);
    // Give cached image widgets and the CDN a new URL after replacement.
    return publicUri
        .replace(
          queryParameters: {
            ...publicUri.queryParameters,
            'v': DateTime.now().microsecondsSinceEpoch.toString(),
          },
        )
        .toString();
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
