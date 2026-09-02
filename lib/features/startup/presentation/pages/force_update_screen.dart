import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/dimensions.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../bloc/startup_state.dart';

class ForceUpdateScreen extends StatelessWidget {
  final StartupUpdateRequired updateData;

  const ForceUpdateScreen({
    super.key,
    required this.updateData,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildContent(context),
      tablet: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    // PopScope prevents back navigation (non-dismissible)
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.r24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.system_update_alt,
                  size: Dimensions.r64,
                  color: AppColor.primaryColor,
                ),
                const SizedBox(height: Dimensions.r24),
                Text(
                  updateData.messageData.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Dimensions.r24,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: Dimensions.r16),
                Text(
                  updateData.messageData.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Dimensions.r16,
                    color: context.textSecondary,
                  ),
                ),
                const SizedBox(height: Dimensions.r24),
                if (updateData.messageData.releaseNotes.isNotEmpty) ...[
                  Text(
                    "What's New:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: context.textPrimary,
                    ),
                  ),
                  const SizedBox(height: Dimensions.r8),
                  ...updateData.messageData.releaseNotes.map(
                    (note) => Padding(
                      padding: const EdgeInsets.only(bottom: Dimensions.r4),
                      child: Text(
                        '• $note',
                        style: TextStyle(color: context.textSecondary),
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.r32),
                ],
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    foregroundColor: AppColor.whiteColor,
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.r16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.r12),
                    ),
                  ),
                  onPressed: () async {
                    final url = Uri.parse(updateData.storeUrl);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    }
                  },
                  child: const Text('Update Now'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
