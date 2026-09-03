import '../entities/request_entity.dart';
import '../entities/join_request_entity.dart';
import 'dart:io';

abstract class SpotRepository {
  Future<List<RequestEntity>> getFeedPosts({String? categoryId});

  Future<RequestEntity> getSpotDetails(String spotId);

  Stream<List<JoinRequestEntity>> streamPendingRequests(String spotId);

  Future<List<JoinRequestEntity>> getConfirmedPlayers(String spotId);

  Future<void> createRequest({
    required String categoryId,
    required String title,
    String? description,
    required String locationName,
    required DateTime eventDateTime,
    required int maxParticipants,
    required double pricePerPerson,
    required List<File> images,
  });

  Future<void> requestToJoin(String spotId);

  Future<void> updateJoinRequestStatus({
    required String joinRequestId,
    required String status,
  });
}
