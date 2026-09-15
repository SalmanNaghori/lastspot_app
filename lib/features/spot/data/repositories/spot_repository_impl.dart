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
  Future<List<RequestEntity>> getExplorePosts({
    required String cityId,
    String? categoryId,
    String? searchQuery,
    int limit = 20,
    int offset = 0,
  }) async {
    return _remoteDataSource.getExplorePosts(
      cityId: cityId,
      categoryId: categoryId,
      searchQuery: searchQuery,
      limit: limit,
      offset: offset,
    );
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
    required String cityId,
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
      'city_id': cityId,
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

  @override
  Future<List<RequestEntity>> getUserActivities() async {
    return _remoteDataSource.getUserActivities();
  }

  @override
  Future<void> updateRequest({
    required String spotId,
    String? categoryId,
    String? cityId,
    String? title,
    String? description,
    String? locationName,
    DateTime? eventDateTime,
    int? maxParticipants,
    double? pricePerPerson,
    List<File>? newImages,
  }) async {
    final Map<String, dynamic> updates = {};
    if (categoryId != null) updates['category_id'] = categoryId;
    if (cityId != null) updates['city_id'] = cityId;
    if (title != null) updates['title'] = title;
    if (description != null) updates['description'] = description;
    if (locationName != null) updates['location_name'] = locationName;
    if (eventDateTime != null) updates['event_date_time'] = eventDateTime.toIso8601String();
    if (maxParticipants != null) updates['max_participants'] = maxParticipants;
    if (pricePerPerson != null) updates['price_per_person'] = pricePerPerson;

    // Note: updating images would require deleting old images and uploading new ones in the datasource.
    // For now, we only update the simple text fields as requested by the basic edit flow.
    // A robust image update requires modifying updateRequest in remoteDataSource to handle the newImages list.

    return _remoteDataSource.updateRequest(spotId, updates);
  }
}
