import 'package:equatable/equatable.dart';

enum ReportStatus { pending, reviewing, resolved, dismissed }

class ReportEntity extends Equatable {
  final String id;
  final String reporterId;
  final String? reportedUserId;
  final String? requestId;
  final String? messageId;
  final String reason;
  final String? description;
  final ReportStatus status;
  final String? adminNote;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  const ReportEntity({
    required this.id,
    required this.reporterId,
    this.reportedUserId,
    this.requestId,
    this.messageId,
    required this.reason,
    this.description,
    required this.status,
    this.adminNote,
    required this.createdAt,
    this.resolvedAt,
  });

  @override
  List<Object?> get props => [
    id,
    reporterId,
    reportedUserId,
    requestId,
    messageId,
    reason,
    description,
    status,
    adminNote,
    createdAt,
    resolvedAt,
  ];
}
