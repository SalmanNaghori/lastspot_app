import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/post_model.dart';
import '../models/join_request_model.dart';

abstract class SpotRemoteDataSource {
  Future<List<PostModel>> getFeedPosts({String? category});
  Future<void> createPost(Map<String, dynamic> postData);
  Future<PostModel> getSpotDetails(String postId);
  Future<List<JoinRequestModel>> getConfirmedPlayers(String postId);
  Stream<List<JoinRequestModel>> streamPendingRequests(String postId);
  Future<void> requestToJoin(String postId);
  Future<void> updateRequestStatus(String requestId, String status);
}

class SupabaseSpotDataSourceImpl implements SpotRemoteDataSource {
  final SupabaseClient _client;

  SupabaseSpotDataSourceImpl({required SupabaseClient client}) : _client = client;

  @override
  Future<List<PostModel>> getFeedPosts({String? category}) async {
    var query = _client
        .from('posts')
        .select('*, profiles:host_id(*)')
        .eq('status', 'active');

    if (category != null && category.isNotEmpty) {
      query = query.eq('sport_category', category);
    }

    final response = await query.order('match_time', ascending: true);
    return (response as List<dynamic>)
        .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> createPost(Map<String, dynamic> postData) async {
    await _client.from('posts').insert(postData);
  }

  @override
  Future<PostModel> getSpotDetails(String postId) async {
    final response = await _client
        .from('posts')
        .select('*, profiles:host_id(*)')
        .eq('id', postId)
        .single();
    return PostModel.fromJson(response);
  }

  @override
  Future<List<JoinRequestModel>> getConfirmedPlayers(String postId) async {
    final response = await _client
        .from('join_requests')
        .select('*, profiles:user_id(*)')
        .eq('post_id', postId)
        .eq('status', 'accepted');
        
    return (response as List<dynamic>)
        .map((e) => JoinRequestModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Stream<List<JoinRequestModel>> streamPendingRequests(String postId) {
    return _client
        .from('join_requests')
        .stream(primaryKey: ['id'])
        .eq('post_id', postId)
        .eq('status', 'pending')
        .map((list) => list
            .map((e) => JoinRequestModel.fromJson(e))
            .toList());
  }

  @override
  Future<void> requestToJoin(String postId) async {
    await _client.rpc('request_to_join', params: {
      'p_post_id': postId,
    });
  }

  @override
  Future<void> updateRequestStatus(String requestId, String status) async {
    await _client.rpc('update_request_status', params: {
      'p_request_id': requestId,
      'p_status': status,
    });
  }
}
