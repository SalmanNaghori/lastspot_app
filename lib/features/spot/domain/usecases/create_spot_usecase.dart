import '../repositories/spot_repository.dart';

class CreateSpotUseCase {
  final SpotRepository _repository;

  CreateSpotUseCase(this._repository);

  Future<void> call({
    required String sportCategory,
    required int totalSpots,
    required int neededSpots,
    required DateTime matchTime,
    required String venueName,
    String? googleMapsUrl,
    String? additionalNotes,
  }) async {
    return _repository.createSpot(
      sportCategory: sportCategory,
      totalSpots: totalSpots,
      neededSpots: neededSpots,
      matchTime: matchTime,
      venueName: venueName,
      googleMapsUrl: googleMapsUrl,
      additionalNotes: additionalNotes,
    );
  }
}
