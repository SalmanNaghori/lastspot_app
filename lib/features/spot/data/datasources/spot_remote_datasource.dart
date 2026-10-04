import 'dart:io';

import 'package:lastspot_app/core/network/api_endpoints.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/join_request_model.dart';
import '../models/request_model.dart';
import '../../domain/entities/join_request_entity.dart';
import '../../../auth/domain/entities/user_profile.dart';

abstract class SpotRemoteDataSource {
  Future<List<RequestModel>> getFeedRequests({
    String? categoryId,
    String? cityId,
  });
  Future<List<RequestModel>> getExploreRequests({
    required String cityId,
    String? categoryId,
    String? searchQuery,
    int limit = 20,
    int offset = 0,
  });
  Future<void> createRequest(
    Map<String, dynamic> requestData,
    List<File> images,
  );
  Future<RequestModel> getSpotDetails(String requestId);
  Future<List<JoinRequestModel>> getConfirmedPlayers(String requestId);
  Stream<List<JoinRequestModel>> streamPendingRequests(String requestId);
  Future<void> requestToJoin(String requestId, {String message = ''});
  Future<void> acceptJoinRequest(String joinRequestId);
  Future<void> rejectJoinRequest(String joinRequestId);
  Future<void> cancelJoinRequest(String joinRequestId);
  Future<List<RequestModel>> getUserActivities();
  Future<void> updateRequest(String spotId, Map<String, dynamic> updates);
  Future<JoinRequestModel?> getUserJoinRequest(String spotId);
  Future<List<JoinRequestModel>> getReceivedJoinRequests();
  Future<List<JoinRequestModel>> getSentJoinRequests();
}

class SupabaseSpotDataSourceImpl implements SpotRemoteDataSource {
  final SupabaseClient _client;

  SupabaseSpotDataSourceImpl({required SupabaseClient client})
    : _client = client;

  @override
  Future<List<RequestModel>> getFeedRequests({
    String? categoryId,
    String? cityId,
  }) async {
    var query = _client
        .from(ApiEndpoints.tableRequests)
        .select('*, profiles:user_id(*), request_images(*)')
        .eq('status', 'open')
        .gte('event_date_time', DateTime.now().toUtc().toIso8601String());

    if (categoryId != null && categoryId.isNotEmpty) {
      query = query.eq('category_id', categoryId);
    }

    if (cityId != null && cityId.isNotEmpty) {
      query = query.eq('city_id', cityId);
    }

    final response = await query.order('event_date_time', ascending: true);
    return (response as List<dynamic>)
        .map((e) => RequestModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<RequestModel>> getExploreRequests({
    required String cityId,
    String? categoryId,
    String? searchQuery,
    int limit = 20,
    int offset = 0,
  }) async {
    var query = _client
        .from(ApiEndpoints.tableRequests)
        .select('*, profiles:user_id(*), request_images(*)')
        .inFilter('status', ['open', 'full'])
        .gte('event_date_time', DateTime.now().toUtc().toIso8601String());

    if (cityId.isNotEmpty) {
      query = query.eq('city_id', cityId);
    }

    if (categoryId != null && categoryId.isNotEmpty) {
      query = query.eq('category_id', categoryId);
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      // Note: Full text search on related tables (categories) is complex in PostgREST.
      // We search title, description, location_name. If category name search is critical,
      // we would need a database function or an ilike with inner join.
      // For now, doing an or() on local fields.
      query = query.or(
        'title.ilike.%$searchQuery%,description.ilike.%$searchQuery%,location_name.ilike.%$searchQuery%',
      );
    }

    final response = await query
        .order('event_date_time', ascending: true)
        .range(offset, offset + limit - 1);

    return (response as List<dynamic>)
        .map((e) => RequestModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> createRequest(
    Map<String, dynamic> requestData,
    List<File> images,
  ) async {
    // 1. Insert the request
    final payload = Map<String, dynamic>.from(requestData);
    payload['current_participants'] = 1;
    payload['status'] = 'open';
    final response = await _client
        .from(ApiEndpoints.tableRequests)
        .insert(payload)
        .select()
        .single();
    final requestId = response['id'] as String;

    // 2. Upload images and insert into request_images
    for (int i = 0; i < images.length; i++) {
      final file = images[i];
      final userId = _client.auth.currentUser?.id ?? '';
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
      final storagePath = '$userId/$fileName';

      await _client.storage.from('request-images').upload(storagePath, file);

      final publicUrl = _client.storage
          .from('request-images')
          .getPublicUrl(storagePath);

      await _client.from('request_images').insert({
        'request_id': requestId,
        'storage_path': publicUrl,
        'sort_order': i,
      });
    }
  }

  @override
  Future<RequestModel> getSpotDetails(String requestId) async {
    final response = await _client
        .from(ApiEndpoints.tableRequests)
        .select('*, profiles:user_id(*), request_images(*)')
        .eq('id', requestId)
        .single();
    return RequestModel.fromJson(response);
  }

  @override
  Future<List<JoinRequestModel>> getConfirmedPlayers(String requestId) async {
    final response = await _client
        .from('request_participants')
        .select('*')
        .eq('request_id', requestId);

    final list = response as List<dynamic>;
    if (list.isEmpty) return [];

    final userIds = list.map((e) => e['user_id']).toSet().toList();
    final profilesResponse = await _client
        .from('profiles')
        .select()
        .inFilter('id', userIds);

    final profilesMap = {for (var p in profilesResponse) p['id']: p};

    return list.map((e) {
      final userId = e['user_id'];
      final profile = profilesMap[userId];
      return JoinRequestModel(
        id: e['id']?.toString() ?? e['request_id'] + e['user_id'],
        requestId: e['request_id'] as String,
        userId: userId as String,
        status: JoinRequestStatus.accepted,
        createdAt:
            DateTime.tryParse(e['joined_at']?.toString() ?? '') ??
            DateTime.now(),
        userProfile: profile != null ? UserProfile.fromJson(profile) : null,
      );
    }).toList();
  }

  @override
  Stream<List<JoinRequestModel>> streamPendingRequests(String requestId) {
    return _client
        .from(ApiEndpoints.tableJoinRequests)
        .stream(primaryKey: ['id'])
        .eq('request_id', requestId)
        .eq('status', 'pending')
        .asyncMap((list) async {
          if (list.isEmpty) return [];
          try {
            final userIds = list.map((e) => e['user_id']).toSet().toList();
            final profilesResponse = await _client
                .from('profiles')
                .select(
                  'id, full_name, avatar_url, bio, city, sports_interests, rating',
                )
                .inFilter('id', userIds);

            final profilesMap = {for (var p in profilesResponse) p['id']: p};

            return list
                .map((e) {
                  try {
                    final userId = e['user_id'];
                    final profile = profilesMap[userId];
                    final json = Map<String, dynamic>.from(e);
                    if (profile != null) {
                      json['profiles'] = profile;
                    }
                    return JoinRequestModel.fromJson(json);
                  } catch (err) {
                    print('Error parsing stream join request: $err');
                    return null;
                  }
                })
                .whereType<JoinRequestModel>()
                .toList();
          } catch (e) {
            print('Error in streamPendingRequests asyncMap: $e');
            return [];
          }
        });
  }

  @override
  Future<List<JoinRequestModel>> getReceivedJoinRequests() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    try {
      final response = await _client
          .from(ApiEndpoints.tableJoinRequests)
          .select('''
            *,
            requests!inner(*)
          ''')
          .eq('requests.user_id', userId)
          .eq('status', 'pending')
          .order('created_at', ascending: false);

      print('DEBUG: getReceivedJoinRequests raw response: $response');
      final list = response as List<dynamic>;
      if (list.isEmpty) return [];

      final applicantIds = list.map((e) => e['user_id']).toSet().toList();
      final profilesResponse = await _client
          .from('profiles')
          .select()
          .inFilter('id', applicantIds);

      final profilesMap = {for (var p in profilesResponse) p['id']: p};

      final parsedList = list
          .map((e) {
            try {
              final applicantId = e['user_id'];
              final profile = profilesMap[applicantId];
              final json = Map<String, dynamic>.from(e);
              if (profile != null) {
                json['profiles'] = profile;
              }
              return JoinRequestModel.fromJson(json);
            } catch (err) {
              print('DEBUG: Error parsing JoinRequestModel: $err for row: $e');
              return null;
            }
          })
          .whereType<JoinRequestModel>()
          .toList();

      final uniqueRequests = <String, JoinRequestModel>{};
      for (final req in parsedList) {
        final key = '${req.requestId}_${req.userId}';
        if (!uniqueRequests.containsKey(key)) {
          uniqueRequests[key] = req;
        }
      }

      final finalList = uniqueRequests.values.toList();
      print('DEBUG: getReceivedJoinRequests parsed count: ${finalList.length}');
      return finalList;
    } catch (e) {
      print('DEBUG: getReceivedJoinRequests query error: $e');
      rethrow;
    }
  }

  @override
  Future<List<JoinRequestModel>> getSentJoinRequests() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    try {
      final response = await _client
          .from(ApiEndpoints.tableJoinRequests)
          .select('''
            *,
            requests(*)
          ''')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      print('DEBUG: getSentJoinRequests raw response: $response');

      final parsedList = (response as List<dynamic>)
          .map((e) {
            try {
              return JoinRequestModel.fromJson(e as Map<String, dynamic>);
            } catch (err) {
              print('DEBUG: Error parsing JoinRequestModel: $err for row: $e');
              return null;
            }
          })
          .whereType<JoinRequestModel>()
          .toList();

      final uniqueRequests = <String, JoinRequestModel>{};
      for (final req in parsedList) {
        final key = '${req.requestId}_${req.userId}';
        if (!uniqueRequests.containsKey(key)) {
          uniqueRequests[key] = req;
        }
      }

      final finalList = uniqueRequests.values.toList();
      print('DEBUG: getSentJoinRequests parsed count: ${finalList.length}');
      return finalList;
    } catch (e) {
      print('DEBUG: getSentJoinRequests query error: $e');
      rethrow;
    }
  }

  @override
  Future<void> requestToJoin(String requestId, {String message = ''}) async {
    await _client.rpc(
      'create_join_request',
      params: {
        'p_request_id': requestId,
        'p_message': (message.trim().isEmpty) ? null : message.trim(),
      },
    );
  }

  @override
  Future<void> acceptJoinRequest(String joinRequestId) async {
    await _client.rpc(
      'accept_join_request',
      params: {'p_join_request_id': joinRequestId},
    );
  }

  @override
  Future<void> rejectJoinRequest(String joinRequestId) async {
    await _client.rpc(
      'reject_join_request',
      params: {'p_join_request_id': joinRequestId},
    );
  }

  @override
  Future<void> cancelJoinRequest(String joinRequestId) async {
    await _client.rpc(
      'cancel_join_request',
      params: {'p_join_request_id': joinRequestId},
    );
  }

  @override
  Future<List<RequestModel>> getUserActivities() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    // Find spots where user is the creator OR is an accepted participant
    // First get accepted join requests
    final joinResponses = await _client
        .from('request_participants')
        .select('request_id')
        .eq('user_id', userId);

    final joinedRequestIds = (joinResponses as List<dynamic>)
        .map((e) => e['request_id'] as String)
        .toList();

    // Query requests: creator OR in joined list
    var query = _client
        .from(ApiEndpoints.tableRequests)
        .select('*, profiles:user_id(*), request_images(*)');

    if (joinedRequestIds.isNotEmpty) {
      final idList = joinedRequestIds.map((id) => '"$id"').join(',');
      query = query.or('user_id.eq.$userId,id.in.($idList)');
    } else {
      query = query.eq('user_id', userId);
    }

    final response = await query.order('event_date_time', ascending: false);
    return (response as List<dynamic>)
        .map((e) => RequestModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> updateRequest(
    String spotId,
    Map<String, dynamic> updates,
  ) async {
    if (updates.isEmpty) return;
    await _client
        .from(ApiEndpoints.tableRequests)
        .update(updates)
        .eq('id', spotId);
  }

  @override
  Future<JoinRequestModel?> getUserJoinRequest(String spotId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return null;

    final response = await _client
        .from(ApiEndpoints.tableJoinRequests)
        .select()
        .eq('request_id', spotId)
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) return null;
    return JoinRequestModel.fromJson(response);
  }
}
