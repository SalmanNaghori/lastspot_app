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
    Color iconColor = context.primaryColor;

    if (state is AuthSuspended) {
      title = context.loc.accountSuspendedTitle;
      message = context.loc.accountSuspendedDesc;
      iconData = Icons.warning_amber_rounded;
      iconColor = context.warningColor;
    } else if (state is AuthBanned) {
      title = context.loc.accountBannedTitle;
      message = context.loc.accountBannedDesc;
      iconData = Icons.block;
      iconColor = context.errorColor;
    } else if (state is AuthDeleted) {
      title = context.loc.accountDeletedTitle;
      message = context.loc.accountDeletedDesc;
      iconData = Icons.delete_outline;
      iconColor = context.errorColor;
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
                  backgroundColor: context.primaryColor,
                  foregroundColor: AppColor.whiteColor,
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.r16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.r12),
                  ),
                ),
                onPressed: () {
                  // E.g., launch url for support or just show a snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(context.loc.supportContactComingSoon),
                    ),
                  );
                },
                child: Text(context.loc.contactSupport),
              ),
              const SizedBox(height: Dimensions.r16),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(AuthLogoutRequested());
                },
                child: Text(
                  context.loc.logout,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
