import '../repositories/report_repository.dart';

class SubmitReportUseCase {
  final ReportRepository repository;

  SubmitReportUseCase(this.repository);

  Future<void> call({
    required String reason,
    String? description,
    String? reportedUserId,
    String? requestId,
    String? messageId,
  }) async {
    return repository.submitReport(
      reason: reason,
      description: description,
      reportedUserId: reportedUserId,
      requestId: requestId,
      messageId: messageId,
    );
  }
}
