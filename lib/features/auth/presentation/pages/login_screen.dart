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
  bool _obscurePassword = true;

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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(Dimensions.r24.dynamicW),
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
                            : context.primaryContainer,
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
                      child: Assets.images.categories.football.image(
                        fit: BoxFit.contain,
                        cacheWidth: 200,
                        cacheHeight: 200,
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.r16.dynamicH),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: Dimensions.r28.dynamicSP,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                      children: [
                        TextSpan(
                          text: AppString.appNamePrefix,
                          style: TextStyle(color: context.textPrimary),
                        ),
                        TextSpan(
                          text: AppString.appNameSuffix,
                          style: TextStyle(color: context.primaryColor),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Dimensions.r8.dynamicH),
                  Text(
                    context.loc.loginSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: Dimensions.r15.dynamicSP,
                      color: context.textSecondary,
                    ),
                  ),
                  SizedBox(height: Dimensions.r32.dynamicH),
                  AppTextField(
                    controller: _emailController,
                    labelText: context.loc.email,
                    prefixIcon: const Icon(Icons.email_outlined),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: AppValidators.email(context.loc),
                  ),
                  SizedBox(height: Dimensions.r16.dynamicH),
                  AppTextField(
                    controller: _passwordController,
                    labelText: context.loc.password,
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    isPassword: true,
                    obscureText: _obscurePassword,
                    onTogglePassword: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    textInputAction: TextInputAction.done,
                    validator: AppValidators.password(context.loc),
                  ),
                  SizedBox(height: Dimensions.r8.dynamicH),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        context.safePush(AppRoutes.forgotPassword);
                      },
                      child: Text(
                        context.loc.forgotPassword,
                        style: TextStyle(
                          color: context.textSecondary,
                          fontSize: Dimensions.r13.dynamicSP,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.r20.dynamicH),
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
                          onPressed: state is AuthLoading ? null : _onLogin,
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
                                  context.loc.login,
                                  style: TextStyle(
                                    fontSize: Dimensions.r16.dynamicSP,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: Dimensions.r16.dynamicH),
                  TextButton(
                    onPressed: () {
                      context.safePush(AppRoutes.signup);
                    },
                    child: Text(
                      context.loc.dontHaveAccount,
                      style: TextStyle(
                        color: context.primaryColor,
                        fontSize: Dimensions.r14.dynamicSP,
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
