import '../entities/request_entity.dart';
import '../repositories/spot_repository.dart';

class GetSpotsUseCase {
  final SpotRepository _repository;

  GetSpotsUseCase(this._repository);

  Future<List<RequestEntity>> call({String? category, String? cityId}) async {
    return _repository.getFeedRequests(categoryId: category, cityId: cityId);
  }
}
