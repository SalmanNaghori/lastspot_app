import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/submit_report_usecase.dart';
import 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final SubmitReportUseCase _submitReportUseCase;

  ReportCubit(this._submitReportUseCase) : super(ReportInitial());

  Future<void> submitReport({
    required String reason,
    String? description,
    String? reportedUserId,
    String? requestId,
    String? messageId,
  }) async {
    emit(ReportLoading());
    try {
      await _submitReportUseCase.call(
        reason: reason,
        description: description,
        reportedUserId: reportedUserId,
        requestId: requestId,
        messageId: messageId,
      );
      emit(ReportSuccess());
    } on SocketException {
      emit(
        const ReportError(
          'No internet connection. Please check your network and try again.',
        ),
      );
    } catch (e) {
      emit(const ReportError('Failed to submit report. Please try again.'));
    }
  }
}
