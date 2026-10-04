import '../entities/request_entity.dart';
import '../entities/join_request_entity.dart';
import 'dart:io';

abstract class SpotRepository {
  Future<List<RequestEntity>> getFeedRequests({
    String? categoryId,
    String? cityId,
  });

  Future<List<RequestEntity>> getExploreRequests({
    required String cityId,
    String? categoryId,
    String? searchQuery,
    int limit = 20,
    int offset = 0,
  });

  Future<RequestEntity> getSpotDetails(String spotId);

  Stream<List<JoinRequestEntity>> streamPendingRequests(String spotId);

  Future<List<JoinRequestEntity>> getConfirmedPlayers(String spotId);

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
  });

  Future<void> requestToJoin(String spotId, {String message = ''});

  Future<void> acceptJoinRequest(String joinRequestId);

  Future<void> rejectJoinRequest(String joinRequestId);

  Future<void> cancelJoinRequest(String joinRequestId);

  Future<List<RequestEntity>> getUserActivities();

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
  });

  Future<JoinRequestEntity?> getUserJoinRequest(String spotId);
  Future<List<JoinRequestEntity>> getReceivedJoinRequests();
  Future<List<JoinRequestEntity>> getSentJoinRequests();
}
