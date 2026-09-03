import 'package:lastspot_app/core/base_import.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class AccountStatusScreen extends StatelessWidget {
  const AccountStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          context.go(AppRoutes.login);
        }
      },
      builder: (context, state) {
        return ResponsiveLayout(
          mobile: _buildContent(context, state),
          tablet: _buildContent(context, state),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, AuthState state) {
    String title = 'Account Status';
    String message = 'There is an issue with your account.';
    IconData iconData = Icons.info_outline;
    Color iconColor = AppColor.primaryColor;

    if (state is AuthSuspended) {
      title = 'Account Suspended';
      message =
          'Your account has been temporarily suspended due to a violation of our terms of service.';
      iconData = Icons.warning_amber_rounded;
      iconColor = Colors.orange;
    } else if (state is AuthBanned) {
      title = 'Account Banned';
      message =
          'Your account has been permanently banned due to severe violations of our policies.';
      iconData = Icons.block;
      iconColor = Colors.red;
    } else if (state is AuthDeleted) {
      title = 'Account Deleted';
      message =
          'This account has been deleted. If you believe this is a mistake, please contact support.';
      iconData = Icons.delete_outline;
      iconColor = Colors.red;
    }

    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.r24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(iconData, size: 80, color: iconColor),
              const SizedBox(height: Dimensions.r24),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Dimensions.r24,
                  fontWeight: FontWeight.bold,
                  color: context.textPrimary,
                ),
              ),
              const SizedBox(height: Dimensions.r16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Dimensions.r16,
                  color: context.textSecondary,
                ),
              ),
              const SizedBox(height: Dimensions.r48),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  foregroundColor: AppColor.whiteColor,
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.r16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.r12),
                  ),
                ),
                onPressed: () {
                  // E.g., launch url for support or just show a snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Support contact feature coming soon.'),
                    ),
                  );
                },
                child: const Text('Contact Support'),
              ),
              const SizedBox(height: Dimensions.r16),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(AuthLogoutRequested());
                },
                child: Text(
                  'Log Out',
                  style: TextStyle(color: context.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
