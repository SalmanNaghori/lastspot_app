import 'package:lastspot_app/core/base_import.dart';

import 'report_screen_mobile.dart';
import 'report_screen_tablet.dart';
import '../bloc/report_cubit.dart';
import '../../../../core/di/service_locator.dart';

class ReportScreen extends StatelessWidget {
  final String? reportedUserId;
  final String? reportedActivityId;
  final String? reportedMessageId;

  const ReportScreen({
    super.key,
    this.reportedUserId,
    this.reportedActivityId,
    this.reportedMessageId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ReportCubit>(),
      child: ResponsiveLayout(
        mobile: ReportScreenMobile(
          reportedUserId: reportedUserId,
          reportedActivityId: reportedActivityId,
          reportedMessageId: reportedMessageId,
        ),
        tablet: ReportScreenTablet(
          reportedUserId: reportedUserId,
          reportedActivityId: reportedActivityId,
          reportedMessageId: reportedMessageId,
        ),
      ),
    );
  }
}
