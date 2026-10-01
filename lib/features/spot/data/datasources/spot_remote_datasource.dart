import 'dart:io';

import 'package:lastspot_app/core/network/api_endpoints.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/join_request_model.dart';
import '../models/request_model.dart';

abstract class SpotRemoteDataSource {
  Future<List<RequestModel>> getFeedPosts({String? categoryId, String? cityId});
  Future<List<RequestModel>> getExplorePosts({
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
  Future<void> requestToJoin(String requestId);
  Future<void> updateRequestStatus(String joinRequestId, String status);
  Future<List<RequestModel>> getUserActivities();
  Future<void> updateRequest(String spotId, Map<String, dynamic> updates);
  Future<JoinRequestModel?> getUserJoinRequest(String spotId);
}

class SupabaseSpotDataSourceImpl implements SpotRemoteDataSource {
  final SupabaseClient _client;

  SupabaseSpotDataSourceImpl({required SupabaseClient client})
    : _client = client;

  @override
  Future<List<RequestModel>> getFeedPosts({String? categoryId, String? cityId}) async {
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
  Future<List<RequestModel>> getExplorePosts({
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
    final response = await _client
        .from(ApiEndpoints.tableRequests)
        .insert(requestData)
        .select()
        .single();
    final requestId = response['id'] as String;

    // Add creator to join_requests as accepted
    await _client.from(ApiEndpoints.tableJoinRequests).insert({
      'request_id': requestId,
      'user_id': requestData['user_id'],
      'status': 'accepted',
    });

    // 2. Upload images and insert into request_images
    for (int i = 0; i < images.length; i++) {
      final file = images[i];
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
      final storagePath = '$requestId/$fileName';

      await _client.storage.from('request_images').upload(storagePath, file);

      final publicUrl = _client.storage
          .from('request_images')
          .getPublicUrl(storagePath);

      await _client.from('request_images').insert({
        'request_id': requestId,
        'storage_path': publicUrl, // or storagePath depending on schema needs
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
        .from(ApiEndpoints.tableJoinRequests)
        .select('*, profiles:user_id(*)')
        .eq('request_id', requestId) // Updated from post_id to request_id
        .eq('status', 'accepted');

    return (response as List<dynamic>)
        .map((e) => JoinRequestModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Stream<List<JoinRequestModel>> streamPendingRequests(String requestId) {
    return _client
        .from(ApiEndpoints.tableJoinRequests)
        .stream(primaryKey: ['id'])
        .eq('request_id', requestId) // Updated from post_id to request_id
        .eq('status', 'pending')
        .map((list) => list.map((e) => JoinRequestModel.fromJson(e)).toList());
  }

  @override
  Future<void> requestToJoin(String requestId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not logged in');

    await _client.from(ApiEndpoints.tableJoinRequests).insert({
      'request_id': requestId,
      'user_id': userId,
      'status': 'pending',
    });
  }

  @override
  Future<void> updateRequestStatus(String requestId, String status) async {
    await _client.rpc(
      'update_request_status',
      params: {'p_request_id': requestId, 'p_status': status},
    );
  }

  @override
  Future<List<RequestModel>> getUserActivities() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    // Find spots where user is the creator OR is an accepted participant
    // First get accepted join requests
    final joinResponses = await _client
        .from(ApiEndpoints.tableJoinRequests)
        .select('request_id')
        .eq('user_id', userId)
        .eq('status', 'accepted');

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
