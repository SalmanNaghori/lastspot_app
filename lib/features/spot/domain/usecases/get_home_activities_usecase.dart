import '../entities/request_entity.dart';
import '../repositories/spot_repository.dart';

class GetHomeActivitiesUseCase {
  final SpotRepository _repository;

  GetHomeActivitiesUseCase(this._repository);

  Future<List<RequestEntity>> call({String? cityId}) async {
    return _repository.getFeedRequests(cityId: cityId);
  }
}
