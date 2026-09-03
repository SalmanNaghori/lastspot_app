import 'package:lastspot_app/core/base_import.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  @override
  void initState() {
    super.initState();
    // Dispatch AuthCheckRequested on startup to determine navigation
    context.read<AuthBloc>().add(AuthCheckRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          context.go(AppRoutes.home);
        } else if (state is Unauthenticated || state is AuthError) {
          context.go(AppRoutes.login);
        } else if (state is AuthProfileIncomplete) {
          context.go(AppRoutes.profileSetup);
        } else if (state is AuthSuspended ||
            state is AuthBanned ||
            state is AuthDeleted) {
          context.go(AppRoutes.accountStatus);
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
}
