import 'dart:io';
import 'package:lastspot_app/core/network/base/base_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/request_entity.dart';
import '../../domain/entities/join_request_entity.dart';
import '../../domain/repositories/spot_repository.dart';
import '../datasources/spot_remote_datasource.dart';

class SpotRepositoryImpl extends BaseRepository implements SpotRepository {
  final SpotRemoteDataSource _remoteDataSource;
  final SupabaseClient _supabaseClient;

  SpotRepositoryImpl({
    required SpotRemoteDataSource remoteDataSource,
    required SupabaseClient supabaseClient,
  }) : _remoteDataSource = remoteDataSource,
       _supabaseClient = supabaseClient;

  @override
  Future<List<RequestEntity>> getFeedRequests({
    String? categoryId,
    String? cityId,
  }) {
    return executeApiRaw(
      operationName: ApiEndpoints.spotGetFeed,
      requestData: {'categoryId': categoryId, 'cityId': cityId},
      operation: () => _remoteDataSource.getFeedRequests(
        categoryId: categoryId,
        cityId: cityId,
      ),
    );
  }

  @override
  Future<List<RequestEntity>> getExploreRequests({
    required String cityId,
    String? categoryId,
    String? searchQuery,
    int limit = 20,
    int offset = 0,
  }) {
    return executeApiRaw(
      operationName: ApiEndpoints.spotGetExplore,
      requestData: {
        'cityId': cityId,
        'categoryId': categoryId,
        'searchQuery': searchQuery,
        'limit': limit,
        'offset': offset,
      },
      operation: () => _remoteDataSource.getExploreRequests(
        cityId: cityId,
        categoryId: categoryId,
        searchQuery: searchQuery,
        limit: limit,
        offset: offset,
      ),
    );
  }

  @override
  Future<RequestEntity> getSpotDetails(String spotId) {
    return executeApiRaw(
      operationName: ApiEndpoints.spotGetDetails,
      requestData: {'spotId': spotId},
      operation: () => _remoteDataSource.getSpotDetails(spotId),
    );
  }

  @override
  Future<List<JoinRequestEntity>> getConfirmedPlayers(String spotId) {
    return executeApiRaw(
      operationName: ApiEndpoints.spotGetConfirmedPlayers,
      requestData: {'spotId': spotId},
      operation: () => _remoteDataSource.getConfirmedPlayers(spotId),
    );
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
  }) {
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
      'price_per_person': pricePerPerson,
      'status': 'open',
      'city_id': cityId,
    };

    return executeApiRaw(
      operationName: ApiEndpoints.spotCreate,
      requestData: {...requestData, 'image_count': images.length},
      operation: () => _remoteDataSource.createRequest(requestData, images),
    );
  }

  @override
  Future<void> requestToJoin(String spotId, {String message = ''}) {
    return executeApiRaw(
      operationName: ApiEndpoints.spotRequestJoin,
      requestData: {'spotId': spotId, 'message': message},
      operation: () =>
          _remoteDataSource.requestToJoin(spotId, message: message),
    );
  }

  @override
  Future<void> acceptJoinRequest(String joinRequestId) {
    return executeApiRaw(
      operationName: 'acceptJoinRequest',
      requestData: {'joinRequestId': joinRequestId},
      operation: () => _remoteDataSource.acceptJoinRequest(joinRequestId),
    );
  }

  @override
  Future<void> rejectJoinRequest(String joinRequestId) {
    return executeApiRaw(
      operationName: 'rejectJoinRequest',
      requestData: {'joinRequestId': joinRequestId},
      operation: () => _remoteDataSource.rejectJoinRequest(joinRequestId),
    );
  }

  @override
  Future<void> cancelJoinRequest(String joinRequestId) {
    return executeApiRaw(
      operationName: 'cancelJoinRequest',
      requestData: {'joinRequestId': joinRequestId},
      operation: () => _remoteDataSource.cancelJoinRequest(joinRequestId),
    );
  }

  @override
  Future<List<RequestEntity>> getUserActivities() {
    return executeApiRaw(
      operationName: ApiEndpoints.spotGetUserActivities,
      operation: () => _remoteDataSource.getUserActivities(),
    );
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
    if (eventDateTime != null)
      updates['event_date_time'] = eventDateTime.toIso8601String();
    if (maxParticipants != null) updates['max_participants'] = maxParticipants;
    if (pricePerPerson != null) updates['price_per_person'] = pricePerPerson;

    // Note: updating images would require deleting old images and uploading new ones in the datasource.
    // For now, we only update the simple text fields as requested by the basic edit flow.
    // A robust image update requires modifying updateRequest in remoteDataSource to handle the newImages list.

    return executeApiRaw(
      operationName: ApiEndpoints.spotUpdate,
      requestData: {'spotId': spotId, ...updates},
      operation: () => _remoteDataSource.updateRequest(spotId, updates),
    );
  }

  @override
  Future<JoinRequestEntity?> getUserJoinRequest(String spotId) {
    return executeApiRaw(
      operationName: 'spotGetUserJoinRequest',
      requestData: {'spotId': spotId},
      operation: () => _remoteDataSource.getUserJoinRequest(spotId),
    );
  }

  @override
  Future<List<JoinRequestEntity>> getReceivedJoinRequests() {
    return executeApiRaw(
      operationName: 'getReceivedJoinRequests',
      requestData: {},
      operation: () => _remoteDataSource.getReceivedJoinRequests(),
    );
  }

  @override
  Future<List<JoinRequestEntity>> getSentJoinRequests() {
    return executeApiRaw(
      operationName: 'getSentJoinRequests',
      requestData: {},
      operation: () => _remoteDataSource.getSentJoinRequests(),
    );
  }
}
