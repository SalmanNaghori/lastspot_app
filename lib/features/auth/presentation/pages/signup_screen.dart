import 'package:lastspot_app/core/base_import.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _termsAccepted = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  final _formKey = GlobalKey<FormState>();

  void _onSignup() {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_termsAccepted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.loc.acceptTermsError)));
        return;
      }
      context.read<AuthBloc>().add(
        AuthSignupRequested(
          fullName: _nameController.text.trim(),
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
        } else if (state is AuthSuspended || state is AuthBanned || state is AuthDeleted) {
          context.go(AppRoutes.accountStatus);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: ResponsiveLayout(mobile: _buildContent(context), tablet: _buildContent(context)),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: context.textPrimary),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.r24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    context.loc.createAccount,
                    style: TextStyle(fontSize: Dimensions.r32, fontWeight: FontWeight.bold, color: context.textPrimary),
                  ),
                  const SizedBox(height: Dimensions.r8),
                  Text(
                    context.loc.joinCommunitySubtitle,
                    style: TextStyle(fontSize: Dimensions.r16, color: context.textSecondary),
                  ),
                  const SizedBox(height: Dimensions.r32),
                  // Full Name
                  AppTextField(
                    controller: _nameController,
                    labelText: context.loc.fullName,
                    prefixIcon: const Icon(Icons.person_outline),
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return context.loc.fullNameRequired;
                      return null;
                    },
                  ),
                  const SizedBox(height: Dimensions.r16),
                  // Email
                  AppTextField(
                    controller: _emailController,
                    labelText: context.loc.email,
                    prefixIcon: const Icon(Icons.email_outlined),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return context.loc.emailRequired;
                      if (!RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                      ).hasMatch(value)) {
                        return context.loc.invalidEmail;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: Dimensions.r16),
                  // Password
                  AppTextField(
                    controller: _passwordController,
                    labelText: context.loc.password,
                    prefixIcon: const Icon(Icons.lock_outline),
                    isPassword: true,
                    obscureText: _obscurePassword,
                    onTogglePassword: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) return context.loc.passwordRequired;
                      if (value.length < 6) return context.loc.passwordLengthError;
                      return null;
                    },
                  ),
                  const SizedBox(height: Dimensions.r16),
                  // Confirm Password
                  AppTextField(
                    controller: _confirmPasswordController,
                    labelText: context.loc.confirmPassword,
                    prefixIcon: const Icon(Icons.lock_outline),
                    isPassword: true,
                    obscureText: _obscureConfirmPassword,
                    onTogglePassword: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value != _passwordController.text) return context.loc.passwordsDoNotMatch;
                      return null;
                    },
                  ),
                  // Terms
                  CheckboxListTile(
                    title: Text(context.loc.acceptTerms),
                    value: _termsAccepted,
                    onChanged: (val) {
                      setState(() {
                        _termsAccepted = val ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: Dimensions.r32),
                  // Signup Button
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryColor,
                          foregroundColor: AppColor.whiteColor,
                          padding: const EdgeInsets.symmetric(vertical: Dimensions.r16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.r16)),
                        ),
                        onPressed: state is AuthLoading ? null : _onSignup,
                        child: state is AuthLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: context.textPrimary),
                              )
                            : Text(context.loc.signup, style: TextStyle(fontSize: Dimensions.r16, fontWeight: FontWeight.bold)),
                      );
                    },
                  ),
                  const SizedBox(height: Dimensions.r24),
                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(context.loc.alreadyHaveAccount, style: TextStyle(color: context.textSecondary)),
                      GestureDetector(
                        onTap: () => context.go(AppRoutes.login),
                        child: Text(
                          context.loc.login,
                          style: TextStyle(
                            color: AppColor.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimensions.r32),
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
