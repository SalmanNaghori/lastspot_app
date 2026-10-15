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
        AppUtils.showSnackBar(
          context,
          context.loc.acceptTermsError,
          isError: true,
        );
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
        } else if (state is AuthSuspended ||
            state is AuthBanned ||
            state is AuthDeleted) {
          context.go(AppRoutes.accountStatus);
        } else if (state is AuthError) {
          AppUtils.showSnackBar(context, state.message, isError: true);
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
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: context.textPrimary),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.r24.dynamicW),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: Dimensions.r80.dynamicW,
                      height: Dimensions.r80.dynamicH,
                      decoration: BoxDecoration(
                        color: context.isDarkMode
                            ? context.surfaceContainer
                            : const Color(0xFFF0FDF4),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: context.primaryColor.withValues(alpha: 0.18),
                            blurRadius: Dimensions.r20.dynamicR,
                            offset: const Offset(0, 6),
                          ),
                        ],
                        border: Border.all(
                          color: context.primaryColor.withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                      ),
                      padding: EdgeInsets.all(Dimensions.r12.dynamicW),
                      child: AppAssets.cricketEquipmentGen.image(
                        fit: BoxFit.contain,
                        cacheWidth: 200,
                        cacheHeight: 200,
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.r16.dynamicH),
                  Text(
                    context.loc.createAccount,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: Dimensions.r28.dynamicSP,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      color: context.textPrimary,
                    ),
                  ),
                  SizedBox(height: Dimensions.r8.dynamicH),
                  Text(
                    context.loc.joinCommunitySubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: Dimensions.r15.dynamicSP,
                      color: context.textSecondary,
                    ),
                  ),
                  SizedBox(height: Dimensions.r24.dynamicH),
                  // Full Name
                  AppTextField(
                    controller: _nameController,
                    labelText: context.loc.fullName,
                    prefixIcon: const Icon(Icons.person_outline),
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return context.loc.fullNameRequired;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: Dimensions.r16.dynamicH),
                  // Email
                  AppTextField(
                    controller: _emailController,
                    labelText: context.loc.email,
                    prefixIcon: const Icon(Icons.email_outlined),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return context.loc.emailRequired;
                      }
                      if (!RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                      ).hasMatch(value)) {
                        return context.loc.invalidEmail;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: Dimensions.r16.dynamicH),
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
                      if (value == null || value.isEmpty) {
                        return context.loc.passwordRequired;
                      }
                      if (value.length < 6) {
                        return context.loc.passwordLengthError;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: Dimensions.r16.dynamicH),
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
                      if (value != _passwordController.text) {
                        return context.loc.passwordsDoNotMatch;
                      }
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
                  SizedBox(height: Dimensions.r24.dynamicH),
                  // Signup Button
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return SizedBox(
                        height: Dimensions.r48.dynamicH * 1.15,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: context.primaryColor,
                            foregroundColor: AppColor.whiteColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                Dimensions.r16.dynamicR,
                              ),
                            ),
                            elevation: 0,
                          ),
                          onPressed: state is AuthLoading ? null : _onSignup,
                          child: state is AuthLoading
                              ? SizedBox(
                                  height: Dimensions.r20.dynamicH,
                                  width: Dimensions.r20.dynamicW,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColor.whiteColor,
                                  ),
                                )
                              : Text(
                                  context.loc.signup,
                                  style: TextStyle(
                                    fontSize: Dimensions.r16.dynamicSP,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: Dimensions.r24.dynamicH),
                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        context.loc.alreadyHaveAccount,
                        style: TextStyle(color: context.textSecondary),
                      ),
                      GestureDetector(
                        onTap: () => context.go(AppRoutes.login),
                        child: Text(
                          context.loc.login,
                          style: TextStyle(
                            color: context.primaryColor,
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
