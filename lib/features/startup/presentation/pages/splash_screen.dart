import 'package:url_launcher/url_launcher.dart';
import 'package:lastspot_app/core/base_import.dart';
import '../bloc/startup_bloc.dart';
import '../bloc/startup_event.dart';
import '../bloc/startup_state.dart';
import '../../data/models/app_settings_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StartupBloc>().add(StartupInitialCheckRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StartupBloc, StartupState>(
      listener: (context, state) {
        state.maybeWhen(
          success: () {
            context.go(AppRoutes.authCheck);
          },
          maintenanceMode: (title, message) {
            context.go(
              AppRoutes.maintenance,
              extra: {'title': title, 'message': message},
            );
          },
          updateRequired: (messageData, storeUrl, isForced, latestVersion) {
            if (isForced) {
              context.go(AppRoutes.forceUpdate, extra: {
                'messageData': messageData,
                'storeUrl': storeUrl,
              });
            } else {
              _showSoftUpdateDialog(context, messageData, storeUrl, latestVersion);
            }
          },
          orElse: () {},
        );
      },
      child: const Scaffold(
        backgroundColor: AppColor.primaryColor,
        body: Center(
          child: CircularProgressIndicator(color: AppColor.whiteColor),
        ),
      ),
    );
  }

  void _showSoftUpdateDialog(
    BuildContext context,
    VersionMessage messageData,
    String storeUrl,
    String? latestVersion,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(messageData.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(messageData.message),
              const SizedBox(height: 16),
              ...messageData.releaseNotes.map((note) => Text('• $note')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final startupBloc = context.read<StartupBloc>();
                Navigator.pop(dialogContext);
                if (latestVersion != null) {
                  startupBloc.add(StartupUpdateSkipped(latestVersion));
                } else {
                  context.go(AppRoutes.authCheck);
                }
              },
              child: const Text('Maybe Later'),
            ),
            ElevatedButton(
              onPressed: () async {
                final startupBloc = context.read<StartupBloc>();
                Navigator.pop(dialogContext);
                if (storeUrl.isNotEmpty) {
                  final uri = Uri.tryParse(storeUrl);
                  if (uri != null && await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                }
                if (latestVersion != null) {
                  startupBloc.add(StartupUpdateSkipped(latestVersion));
                } else if (context.mounted) {
                  context.go(AppRoutes.authCheck);
                }
              },
              child: const Text('Update Now'),
            ),
          ],
        );
      },
    );
  }
}
