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
          mobile: AccountStatusContent(state: state),
          tablet: AccountStatusContent(state: state, isTablet: true),
        );
      },
    );
  }
}

class AccountStatusContent extends StatelessWidget {
  final AuthState state;
  final bool isTablet;

  const AccountStatusContent({
    super.key,
    required this.state,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    String title = 'Account Status';
    String message = 'There is an issue with your account.';
    IconData iconData = Icons.info_outline_rounded;
    Color iconColor = context.primaryColor;

    if (state is AuthSuspended) {
      title = context.loc.accountSuspendedTitle;
      message = context.loc.accountSuspendedDesc;
      iconData = Icons.warning_amber_rounded;
      iconColor = context.warningColor;
    } else if (state is AuthBanned) {
      title = context.loc.accountBannedTitle;
      message = context.loc.accountBannedDesc;
      iconData = Icons.block_rounded;
      iconColor = context.errorColor;
    } else if (state is AuthDeleted) {
      title = context.loc.accountDeletedTitle;
      message = context.loc.accountDeletedDesc;
      iconData = Icons.delete_outline_rounded;
      iconColor = context.errorColor;
    }

    return Scaffold(
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
                        color: iconColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        iconData,
                        size: Dimensions.r40.dynamicH,
                        color: iconColor,
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.r24.dynamicH),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: Dimensions.r24.dynamicSP,
                      fontWeight: FontWeight.w800,
                      color: context.textPrimary,
                    ),
                  ),
                  SizedBox(height: Dimensions.r12.dynamicH),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: Dimensions.r15.dynamicSP,
                      color: context.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: Dimensions.r40.dynamicH),
                  SizedBox(
                    height: Dimensions.r56.dynamicH,
                    child: FilledButton(
                      onPressed: () {
                        AppUtils.showSnackBar(
                          context,
                          context.loc.supportContactComingSoon,
                        );
                      },
                      child: Text(context.loc.contactSupport),
                    ),
                  ),
                  SizedBox(height: Dimensions.r16.dynamicH),
                  TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthLogoutRequested());
                    },
                    child: Text(
                      context.loc.logout,
                      style: TextStyle(
                        color: context.errorColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
