import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lastspot_app/core/network/supabase_logger.dart';
import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getActiveCategories();
}

class SupabaseCategoryDataSourceImpl implements CategoryRemoteDataSource {
  final SupabaseClient _client;

  SupabaseCategoryDataSourceImpl({required SupabaseClient client})
    : _client = client;

  @override
  Future<List<CategoryModel>> getActiveCategories() async {
    return SupabaseLogger.execute(
      operationName: 'Category.getActiveCategories',
      operation: () async {
        final response = await _client
            .from('categories')
            .select()
            .eq('is_active', true)
            .order('display_order', ascending: true);

        return (response as List)
            .map((json) => CategoryModel.fromJson(json))
            .toList();
      },
    );
  }
}
