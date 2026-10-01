import '../../../../core/network/base/base_repository.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_datasource.dart';

class CategoryRepositoryImpl extends BaseRepository
    implements CategoryRepository {
  final CategoryRemoteDataSource _remoteDataSource;

  CategoryRepositoryImpl({required CategoryRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<List<CategoryEntity>> getActiveCategories() {
    return executeApiRaw(
      operationName: ApiEndpoints.categoryGetAll,
      operation: () => _remoteDataSource.getActiveCategories(),
    );
  }
}
