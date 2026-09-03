import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/request_entity.dart';
import '../../domain/entities/join_request_entity.dart';
import '../../domain/repositories/spot_repository.dart';
import '../datasources/spot_remote_datasource.dart';

class SpotRepositoryImpl implements SpotRepository {
  final SpotRemoteDataSource _remoteDataSource;
  final SupabaseClient _supabaseClient;

  SpotRepositoryImpl({
    required SpotRemoteDataSource remoteDataSource,
    required SupabaseClient supabaseClient,
  }) : _remoteDataSource = remoteDataSource,
       _supabaseClient = supabaseClient;

  @override
  Future<List<RequestEntity>> getFeedPosts({String? categoryId}) async {
    return _remoteDataSource.getFeedPosts(categoryId: categoryId);
  }

  @override
  Future<RequestEntity> getSpotDetails(String spotId) async {
    return _remoteDataSource.getSpotDetails(spotId);
  }

  @override
  Future<List<JoinRequestEntity>> getConfirmedPlayers(String spotId) async {
    return _remoteDataSource.getConfirmedPlayers(spotId);
  }

  @override
  Stream<List<JoinRequestEntity>> streamPendingRequests(String spotId) {
    return _remoteDataSource.streamPendingRequests(spotId);
  }

  @override
  Future<void> createRequest({
    required String categoryId,
    required String title,
    String? description,
    required String locationName,
    required DateTime eventDateTime,
    required int maxParticipants,
    required double pricePerPerson,
    required List<File> images,
  }) async {
    final userId = _supabaseClient.auth.currentUser!.id;

    final requestData = {
      'user_id': userId,
      'category_id': categoryId,
      'title': title,
      'description': description,
      'location_name': locationName,
      'latitude': 0.0, // Default as per plan
      'longitude': 0.0, // Default as per plan
      'event_date_time': eventDateTime.toIso8601String(),
      'max_participants': maxParticipants,
      'current_participants': 1, // Creator is the first participant
      'price_per_person': pricePerPerson,
      'status': 'open', // Enum value string
    };

    await _remoteDataSource.createRequest(requestData, images);
  }

  @override
  Future<void> requestToJoin(String spotId) async {
    return _remoteDataSource.requestToJoin(spotId);
  }

  @override
  Future<void> updateJoinRequestStatus({
    required String joinRequestId,
    required String status,
  }) async {
    return _remoteDataSource.updateRequestStatus(joinRequestId, status);
  }
}
