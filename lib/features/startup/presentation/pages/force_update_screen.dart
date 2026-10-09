import 'package:url_launcher/url_launcher.dart';
import 'package:lastspot_app/core/base_import.dart';
import '../../data/models/app_settings_model.dart';

class ForceUpdateScreen extends StatelessWidget {
  final VersionMessage messageData;
  final String storeUrl;

  const ForceUpdateScreen({
    super.key,
    required this.messageData,
    required this.storeUrl,
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
                Icon(
                  Icons.system_update_alt,
                  size: Dimensions.r64,
                  color: context.primaryColor,
                ),
                const SizedBox(height: Dimensions.r24),
                Text(
                  messageData.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Dimensions.r24,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: Dimensions.r16),
                Text(
                  messageData.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Dimensions.r16,
                    color: context.textSecondary,
                  ),
                ),
                const SizedBox(height: Dimensions.r24),
                if (messageData.releaseNotes.isNotEmpty) ...[
                  Text(
                    "What's New:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: context.textPrimary,
                    ),
                  ),
                  const SizedBox(height: Dimensions.r8),
                  ...messageData.releaseNotes.map(
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
                    backgroundColor: context.primaryColor,
                    foregroundColor: AppColor.whiteColor,
                    padding: const EdgeInsets.symmetric(
                      vertical: Dimensions.r16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Dimensions.r12),
                    ),
                  ),
                  onPressed: () async {
                    final url = Uri.parse(storeUrl);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
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
