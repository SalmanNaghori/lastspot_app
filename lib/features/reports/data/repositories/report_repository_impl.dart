import '../../domain/repositories/report_repository.dart';
import '../datasources/report_remote_datasource.dart';

class ReportRepositoryImpl implements ReportRepository {
  final ReportRemoteDataSource remoteDataSource;

  ReportRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> submitReport({
    required String reason,
    String? description,
    String? reportedUserId,
    String? requestId,
    String? messageId,
  }) async {
    final Map<String, dynamic> data = {
      'reason': reason,
      if (description != null && description.isNotEmpty)
        'description': description,
      if (reportedUserId != null) 'reported_user_id': reportedUserId,
      if (requestId != null) 'request_id': requestId,
      if (messageId != null) 'message_id': messageId,
    };

    await remoteDataSource.submitReport(data);
  }
}
