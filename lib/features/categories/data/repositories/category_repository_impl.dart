import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_datasource.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource _remoteDataSource;

  CategoryRepositoryImpl({required CategoryRemoteDataSource remoteDataSource}) 
      : _remoteDataSource = remoteDataSource;

  @override
  Future<List<CategoryEntity>> getActiveCategories() async {
    return _remoteDataSource.getActiveCategories();
  }
}
