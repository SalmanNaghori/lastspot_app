import 'package:lastspot_app/core/base_import.dart';

import '../bloc/report_cubit.dart';
import '../bloc/report_state.dart';
import 'package:lastspot_app/core/widgets/custom_app_bar.dart';

class ReportScreenMobile extends StatefulWidget {
  final String? reportedUserId;
  final String? reportedActivityId;
  final String? reportedMessageId;

  const ReportScreenMobile({
    super.key,
    this.reportedUserId,
    this.reportedActivityId,
    this.reportedMessageId,
  });

  @override
  State<ReportScreenMobile> createState() => _ReportScreenMobileState();
}

class _ReportScreenMobileState extends State<ReportScreenMobile> {
  final TextEditingController _descController = TextEditingController();
  String? _selectedReason;

  final List<String> _reasons = [
    'Spam',
    'Harassment',
    'Fake Activity',
    'Inappropriate Content',
    'Fraud/Scam',
    'Unsafe Behavior',
    'Other',
  ];

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  void _submit() {
    AppUtils.hideKeyboard(context);
    if (_selectedReason == null) {
      AppUtils.showSnackBar(
        context,
        context.loc.reportReasonRequired,
        isError: true,
      );
      return;
    }

    context.read<ReportCubit>().submitReport(
      reason: _selectedReason!,
      description: _descController.text.trim(),
      reportedUserId: widget.reportedUserId,
      requestId: widget.reportedActivityId,
      messageId: widget.reportedMessageId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.loc;

    return BlocListener<ReportCubit, ReportState>(
      listener: (context, state) {
        if (state is ReportSuccess) {
          AppUtils.showSnackBar(context, loc.reportSubmittedSuccess);
          context.pop();
        } else if (state is ReportError) {
          AppUtils.showSnackBar(context, state.message, isError: true);
        }
      },
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        appBar: CustomAppBar.defaultAppBar(
          context: context,
          title: loc.reportActivityAction,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(Dimensions.r24.dynamicW),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.whyReporting,
                        style: context.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: Dimensions.r16.dynamicH),
                      Container(
                        decoration: BoxDecoration(
                          color: context.surfaceColor,
                          borderRadius: BorderRadius.circular(
                            Dimensions.r16.dynamicR,
                          ),
                          border: Border.all(color: context.borderColor),
                        ),
                        child: Column(
                          children: _reasons.map((reason) {
                            final isSelected = _selectedReason == reason;
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedReason = reason;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.r16.dynamicW,
                                  vertical: Dimensions.r16.dynamicH,
                                ),
                                decoration: BoxDecoration(
                                  border: reason != _reasons.last
                                      ? Border(
                                          bottom: BorderSide(
                                            color: context.borderColor,
                                          ),
                                        )
                                      : null,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isSelected
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_unchecked,
                                      color: isSelected
                                          ? context.primaryColor
                                          : context.textSecondary,
                                    ),
                                    SizedBox(width: Dimensions.r12.dynamicW),
                                    Expanded(
                                      child: Text(
                                        reason,
                                        style: context.bodyLarge?.copyWith(
                                          color: isSelected
                                              ? context.textPrimary
                                              : context.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: Dimensions.r24.dynamicH),
                      Text(
                        loc.additionalDetailsOptional,
                        style: context.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: Dimensions.r16.dynamicH),
                      TextField(
                        controller: _descController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: loc.reportDescHint,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              Dimensions.r16.dynamicR,
                            ),
                            borderSide: BorderSide(color: context.borderColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              Dimensions.r16.dynamicR,
                            ),
                            borderSide: BorderSide(color: context.borderColor),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              Dimensions.r16.dynamicR,
                            ),
                            borderSide: BorderSide(
                              color: context.primaryColor,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: context.surfaceColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(Dimensions.r24.dynamicW),
                child: BlocBuilder<ReportCubit, ReportState>(
                  builder: (context, state) {
                    final isLoading = state is ReportLoading;
                    return SizedBox(
                      width: double.infinity,
                      height: Dimensions.r56.dynamicH,
                      child: FilledButton(
                        onPressed: isLoading ? null : _submit,
                        child: isLoading
                            ? SizedBox(
                                height: Dimensions.r24.dynamicH,
                                width: Dimensions.r24.dynamicH,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(loc.submitReport),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
