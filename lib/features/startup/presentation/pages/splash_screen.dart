import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_color.dart';
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
          context.go('/auth-check');
        } else if (state is StartupMaintenanceMode) {
          context.go('/maintenance', extra: {
            'title': state.title,
            'message': state.message,
          });
        } else if (state is StartupUpdateRequired) {
          if (state.isForced) {
            context.go('/force-update', extra: state);
          } else {
            // Soft update: show dialog, then proceed
            _showSoftUpdateDialog(context, state);
          }
        }
      },
      child: const Scaffold(
        backgroundColor: AppColor.primaryColor,
        body: Center(
          child: CircularProgressIndicator(
            color: AppColor.whiteColor,
          ),
        ),
      ),
    );
  }

  void _showSoftUpdateDialog(BuildContext context, StartupUpdateRequired state) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
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
                Navigator.pop(context);
                context.go('/auth-check'); // Proceed anyway
              },
              child: const Text('Maybe Later'),
            ),
            ElevatedButton(
              onPressed: () {
                // Launch store url
                // Note: using url_launcher requires careful handling
                // We'll leave it as a placeholder for the actual launch logic
                // LaunchHelper.launchUrl(state.storeUrl);
                Navigator.pop(context);
                context.go('/auth-check');
              },
              child: const Text('Update Now'),
            ),
          ],
        );
      },
    );
  }
}
