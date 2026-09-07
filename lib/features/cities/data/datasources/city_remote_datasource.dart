import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lastspot_app/core/network/supabase_logger.dart';
import '../models/city_model.dart';

abstract class CityRemoteDataSource {
  Future<List<CityModel>> getActiveCities();
}

class SupabaseCityDataSourceImpl implements CityRemoteDataSource {
  final SupabaseClient _client;

  SupabaseCityDataSourceImpl({required SupabaseClient client}) : _client = client;

  @override
  Future<List<CityModel>> getActiveCities() async {
    return SupabaseLogger.execute(
      operationName: 'City.getActiveCities',
      operation: () async {
        final response = await _client
            .from('cities')
            .select('id, name, state, is_active, display_order')
            .eq('is_active', true)
            .order('display_order', ascending: true)
            .order('name', ascending: true);

        return (response as List).map((e) => CityModel.fromJson(e)).toList();
      },
    );
  }
}
