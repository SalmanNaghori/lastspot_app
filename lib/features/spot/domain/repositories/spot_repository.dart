import '../entities/spot_entity.dart';
import '../entities/join_request_entity.dart';

abstract class SpotRepository {
  Future<List<SpotEntity>> getFeedSpots({String? category});
  
  Future<SpotEntity> getSpotDetails(String spotId);
  
  Stream<List<JoinRequestEntity>> streamPendingRequests(String spotId);
  
  Future<List<JoinRequestEntity>> getConfirmedPlayers(String spotId);
  
  Future<void> createSpot({
    required String sportCategory,
    required int totalSpots,
    required int neededSpots,
    required DateTime matchTime,
    required String venueName,
    String? googleMapsUrl,
    String? additionalNotes,
  });
  
  Future<void> requestToJoin(String spotId);
  
  Future<void> updateJoinRequestStatus({
    required String joinRequestId,
    required String status,
  });
}
