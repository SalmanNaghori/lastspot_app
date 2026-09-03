import '../entities/request_entity.dart';
import '../repositories/spot_repository.dart';

class GetSpotsUseCase {
  final SpotRepository _repository;

  GetSpotsUseCase(this._repository);

  Future<List<RequestEntity>> call({String? category}) async {
    return _repository.getFeedPosts(categoryId: category);
  }
}
