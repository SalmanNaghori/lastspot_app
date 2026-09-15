import 'dart:io';
import '../repositories/spot_repository.dart';

class UpdateSpotUseCase {
  final SpotRepository repository;

  UpdateSpotUseCase({required this.repository});

  Future<void> call({
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
  }) {
    return repository.updateRequest(
      spotId: spotId,
      categoryId: categoryId,
      cityId: cityId,
      title: title,
      description: description,
      locationName: locationName,
      eventDateTime: eventDateTime,
      maxParticipants: maxParticipants,
      pricePerPerson: pricePerPerson,
      newImages: newImages,
    );
  }
}
