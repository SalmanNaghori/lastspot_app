import '../../domain/entities/spot_entity.dart';
import '../../domain/entities/join_request_entity.dart';
import '../../domain/repositories/spot_repository.dart';
import '../datasources/spot_remote_datasource.dart';

class SpotRepositoryImpl implements SpotRepository {
  final SpotRemoteDataSource _remoteDataSource;

  SpotRepositoryImpl({required SpotRemoteDataSource remoteDataSource}) 
      : _remoteDataSource = remoteDataSource;

  @override
  Future<List<SpotEntity>> getFeedSpots({String? category}) async {
    return _remoteDataSource.getFeedPosts(category: category);
  }

  @override
  Future<SpotEntity> getSpotDetails(String spotId) async {
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
  Future<void> createSpot({
    required String sportCategory,
    required int totalSpots,
    required int neededSpots,
    required DateTime matchTime,
    required String venueName,
    String? googleMapsUrl,
    String? additionalNotes,
  }) async {
    await _remoteDataSource.createPost({
      'sport_category': sportCategory,
      'total_spots': totalSpots,
      'needed_spots': neededSpots,
      'match_time': matchTime.toIso8601String(),
      'venue_name': venueName,
      'google_maps_url': googleMapsUrl,
      'additional_notes': additionalNotes,
    });
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
