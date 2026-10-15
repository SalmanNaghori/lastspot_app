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
      mobile: ForceUpdateContent(messageData: messageData, storeUrl: storeUrl),
      tablet: ForceUpdateContent(
        messageData: messageData,
        storeUrl: storeUrl,
        isTablet: true,
      ),
    );
  }
}

class ForceUpdateContent extends StatelessWidget {
  final VersionMessage messageData;
  final String storeUrl;
  final bool isTablet;

  const ForceUpdateContent({
    super.key,
    required this.messageData,
    required this.storeUrl,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    // PopScope prevents back navigation (non-dismissible)
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(Dimensions.r24.dynamicW),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isTablet ? 500 : 440),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: Dimensions.r80.dynamicW,
                        height: Dimensions.r80.dynamicH,
                        decoration: BoxDecoration(
                          color: context.primaryColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.system_update_alt_rounded,
                          size: Dimensions.r40.dynamicH,
                          color: context.primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(height: Dimensions.r24.dynamicH),
                    Text(
                      messageData.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: Dimensions.r24.dynamicSP,
                        fontWeight: FontWeight.w800,
                        color: context.textPrimary,
                      ),
                    ),
                    SizedBox(height: Dimensions.r12.dynamicH),
                    Text(
                      messageData.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: Dimensions.r15.dynamicSP,
                        color: context.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: Dimensions.r24.dynamicH),
                    if (messageData.releaseNotes.isNotEmpty) ...[
                      Text(
                        "What's New:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Dimensions.r14.dynamicSP,
                          color: context.textPrimary,
                        ),
                      ),
                      SizedBox(height: Dimensions.r8.dynamicH),
                      ...messageData.releaseNotes.map(
                        (note) => Padding(
                          padding: EdgeInsets.only(
                            bottom: Dimensions.r4.dynamicH,
                          ),
                          child: Text(
                            '• $note',
                            style: TextStyle(
                              color: context.textSecondary,
                              fontSize: Dimensions.r13.dynamicSP,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: Dimensions.r32.dynamicH),
                    ],
                    SizedBox(
                      height: Dimensions.r56.dynamicH,
                      child: FilledButton(
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
