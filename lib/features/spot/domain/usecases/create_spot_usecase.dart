import 'dart:io';
import '../repositories/spot_repository.dart';

class CreateSpotUseCase {
  final SpotRepository _repository;

  CreateSpotUseCase(this._repository);

  Future<void> call({
    required String categoryId,
    required String title,
    String? description,
    required String locationName,
    required DateTime eventDateTime,
    required int maxParticipants,
    required double pricePerPerson,
    required List<File> images,
  }) async {
    return _repository.createRequest(
      categoryId: categoryId,
      title: title,
      description: description,
      locationName: locationName,
      eventDateTime: eventDateTime,
      maxParticipants: maxParticipants,
      pricePerPerson: pricePerPerson,
      images: images,
    );
  }
}
