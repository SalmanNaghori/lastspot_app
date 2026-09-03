import 'dart:io';

import 'package:lastspot_app/core/network/supabase_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/join_request_model.dart';
import '../models/request_model.dart';

abstract class SpotRemoteDataSource {
  Future<List<RequestModel>> getFeedPosts({String? categoryId});
  Future<void> createRequest(
    Map<String, dynamic> requestData,
    List<File> images,
  );
  Future<RequestModel> getSpotDetails(String requestId);
  Future<List<JoinRequestModel>> getConfirmedPlayers(String requestId);
  Stream<List<JoinRequestModel>> streamPendingRequests(String requestId);
  Future<void> requestToJoin(String requestId);
  Future<void> updateRequestStatus(String joinRequestId, String status);
}

class SupabaseSpotDataSourceImpl implements SpotRemoteDataSource {
  final SupabaseClient _client;

  SupabaseSpotDataSourceImpl({required SupabaseClient client})
    : _client = client;

  @override
  Future<List<RequestModel>> getFeedPosts({String? categoryId}) async {
    return SupabaseLogger.execute(
      operationName: 'Spot.getFeedPosts',
      requestData: {'categoryId': categoryId},
      operation: () async {
        var query = _client
            .from('requests')
            .select('*, profiles:user_id(*), request_images(*)')
            .eq('status', 'open');

        if (categoryId != null && categoryId.isNotEmpty) {
          query = query.eq('category_id', categoryId);
        }

        final response = await query.order('event_date_time', ascending: true);
        return (response as List<dynamic>)
            .map((e) => RequestModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  @override
  Future<void> createRequest(
    Map<String, dynamic> requestData,
    List<File> images,
  ) async {
    return SupabaseLogger.execute(
      operationName: 'Spot.createRequest',
      requestData: {...requestData, 'image_count': images.length},
      operation: () async {
        // 1. Insert the request
        final response = await _client
            .from('requests')
            .insert(requestData)
            .select()
            .single();
        final requestId = response['id'] as String;

        // 2. Upload images and insert into request_images
        for (int i = 0; i < images.length; i++) {
          final file = images[i];
          final fileName = '${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
          final storagePath = '$requestId/$fileName';

          await _client.storage
              .from('request_images')
              .upload(storagePath, file);

          final publicUrl = _client.storage
              .from('request_images')
              .getPublicUrl(storagePath);

          await _client.from('request_images').insert({
            'request_id': requestId,
            'storage_path':
                publicUrl, // or storagePath depending on schema needs
            'sort_order': i,
          });
        }
      },
    );
  }

  @override
  Future<RequestModel> getSpotDetails(String requestId) async {
    return SupabaseLogger.execute(
      operationName: 'Spot.getSpotDetails',
      requestData: {'requestId': requestId},
      operation: () async {
        final response = await _client
            .from('requests')
            .select('*, profiles:user_id(*), request_images(*)')
            .eq('id', requestId)
            .single();
        return RequestModel.fromJson(response);
      },
    );
  }

  @override
  Future<List<JoinRequestModel>> getConfirmedPlayers(String requestId) async {
    return SupabaseLogger.execute(
      operationName: 'Spot.getConfirmedPlayers',
      requestData: {'requestId': requestId},
      operation: () async {
        final response = await _client
            .from('join_requests')
            .select('*, profiles:user_id(*)')
            .eq('request_id', requestId) // Updated from post_id to request_id
            .eq('status', 'accepted');

        return (response as List<dynamic>)
            .map((e) => JoinRequestModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
  }

  @override
  Stream<List<JoinRequestModel>> streamPendingRequests(String requestId) {
    return _client
        .from('join_requests')
        .stream(primaryKey: ['id'])
        .eq('request_id', requestId) // Updated from post_id to request_id
        .eq('status', 'pending')
        .map((list) => list.map((e) => JoinRequestModel.fromJson(e)).toList());
  }

  @override
  Future<void> requestToJoin(String requestId) async {
    return SupabaseLogger.execute(
      operationName: 'Spot.requestToJoin',
      requestData: {'requestId': requestId},
      operation: () => _client.rpc(
        'request_to_join',
        params: {
          'p_request_id': requestId, // Assuming RPC expects this, or p_post_id
        },
      ),
    );
  }

  @override
  Future<void> updateRequestStatus(String requestId, String status) async {
    return SupabaseLogger.execute(
      operationName: 'Spot.updateRequestStatus',
      requestData: {'requestId': requestId, 'status': status},
      operation: () => _client.rpc(
        'update_request_status',
        params: {'p_request_id': requestId, 'p_status': status},
      ),
    );
  }
}
