import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ReportRemoteDataSource {
  Future<void> submitReport(Map<String, dynamic> data);
}

class SupabaseReportDataSourceImpl implements ReportRemoteDataSource {
  final SupabaseClient _client;

  SupabaseReportDataSourceImpl({required SupabaseClient client})
    : _client = client;

  @override
  Future<void> submitReport(Map<String, dynamic> data) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not logged in');

    data['reporter_id'] = userId;
    data['status'] = 'pending';

    await _client.from('reports').insert(data);
  }
}
