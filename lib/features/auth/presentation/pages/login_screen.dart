import 'package:lastspot_app/core/base_import.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          context.go(AppRoutes.home);
        } else if (state is AuthProfileIncomplete) {
          context.go(AppRoutes.profileSetup);
        } else if (state is AuthSuspended ||
            state is AuthBanned ||
            state is AuthDeleted) {
          context.go(AppRoutes.accountStatus);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: ResponsiveLayout(
        mobile: _buildContent(context),
        tablet: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Dimensions.r24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    AppString.appName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: Dimensions.r32,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primaryColor,
                    ),
                  ),
                  const SizedBox(height: Dimensions.r8),
                  Text(
                    context.loc.loginSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: Dimensions.r16,
                      color: context.textSecondary,
                    ),
                  ),
                  const SizedBox(height: Dimensions.r48),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: context.loc.email,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimensions.r12),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty)
                        return 'Email is required';
                      if (!RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                      ).hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: Dimensions.r16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: context.loc.password,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Dimensions.r12),
                      ),
                    ),
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _onLogin(),
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Password is required';
                      return null;
                    },
                  ),
                  const SizedBox(height: Dimensions.r8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        context.push(AppRoutes.forgotPassword);
                      },
                      child: Text(
                        context.loc.forgotPassword,
                        style: TextStyle(color: context.textSecondary),
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.r24),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryColor,
                          foregroundColor: AppColor.whiteColor,
                          padding: const EdgeInsets.symmetric(
                            vertical: Dimensions.r16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Dimensions.r12),
                          ),
                        ),
                        onPressed: state is AuthLoading ? null : _onLogin,
                        child: state is AuthLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColor.whiteColor,
                                ),
                              )
                            : Text(context.loc.login),
                      );
                    },
                  ),
                  const SizedBox(height: Dimensions.r16),
                  TextButton(
                    onPressed: () {
                      context.push(AppRoutes.signup);
                    },
                    child: Text(
                      context.loc.dontHaveAccount,
                      style: const TextStyle(color: AppColor.primaryColor),
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
