import 'package:url_launcher/url_launcher.dart';
import 'package:lastspot_app/core/base_import.dart';
import '../bloc/startup_bloc.dart';
import '../bloc/startup_event.dart';
import '../bloc/startup_state.dart';

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
        if (state is StartupSuccess) {
          // Proceed to Auth check (we will handle auth routing next)
          context.go(AppRoutes.authCheck);
        } else if (state is StartupMaintenanceMode) {
          context.go(
            AppRoutes.maintenance,
            extra: {'title': state.title, 'message': state.message},
          );
        } else if (state is StartupUpdateRequired) {
          if (state.isForced) {
            context.go(AppRoutes.forceUpdate, extra: state);
          } else {
            // Soft update: show dialog, then proceed
            _showSoftUpdateDialog(context, state);
          }
        }
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
    StartupUpdateRequired state,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(state.messageData.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(state.messageData.message),
              const SizedBox(height: 16),
              ...state.messageData.releaseNotes.map((note) => Text('• $note')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final startupBloc = context.read<StartupBloc>();
                Navigator.pop(dialogContext);
                if (state.latestVersion != null) {
                  startupBloc.add(StartupUpdateSkipped(state.latestVersion!));
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
                if (state.storeUrl.isNotEmpty) {
                  final uri = Uri.tryParse(state.storeUrl);
                  if (uri != null && await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                }
                if (state.latestVersion != null) {
                  startupBloc.add(StartupUpdateSkipped(state.latestVersion!));
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
