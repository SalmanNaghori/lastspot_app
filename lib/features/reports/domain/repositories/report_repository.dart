abstract class ReportRepository {
  Future<void> submitReport({
    required String reason,
    String? description,
    String? reportedUserId,
    String? requestId,
    String? messageId,
  });
}
