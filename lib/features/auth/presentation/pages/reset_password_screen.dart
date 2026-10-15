import 'package:lastspot_app/core/base_import.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<AuthBloc>().add(
      PasswordRecoveryUpdateRequested(password: _passwordController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: context.textPrimary),
        title: Text(context.loc.resetPassword),
      ),
      body: SafeArea(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final recoveryCanUpdate =
                state is AuthPasswordRecoveryReady ||
                state is AuthPasswordRecoveryUpdating ||
                state is AuthPasswordRecoveryUpdateFailed;
            if (state is AuthPasswordRecoveryInvalid || !recoveryCanUpdate) {
              return const ResetPasswordInvalidLink();
            }

            final isUpdating = state is AuthPasswordRecoveryUpdating;
            final errorMessage = state is AuthPasswordRecoveryUpdateFailed
                ? (state.message == 'no_internet'
                      ? context.loc.noInternetError
                      : state.message)
                : null;

            return Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(Dimensions.r24.dynamicW),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Container(
                            width: Dimensions.r72.dynamicW,
                            height: Dimensions.r72.dynamicH,
                            decoration: BoxDecoration(
                              color: context.primaryColor.withValues(
                                alpha: 0.1,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.lock_reset_rounded,
                              size: Dimensions.r36.dynamicH,
                              color: context.primaryColor,
                            ),
                          ),
                        ),
                        SizedBox(height: Dimensions.r20.dynamicH),
                        Text(
                          context.loc.resetPassword,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: Dimensions.r28.dynamicSP,
                            fontWeight: FontWeight.w800,
                            color: context.textPrimary,
                          ),
                        ),
                        SizedBox(height: Dimensions.r8.dynamicH),
                        Text(
                          'Choose a new password for your LastSpot account.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: Dimensions.r15.dynamicSP,
                            color: context.textSecondary,
                          ),
                        ),
                        SizedBox(height: Dimensions.r32.dynamicH),
                        AppTextField(
                          labelText: 'New Password',
                          controller: _passwordController,
                          isPassword: true,
                          obscureText: !_showPassword,
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          onTogglePassword: () =>
                              setState(() => _showPassword = !_showPassword),
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
                        AppTextField(
                          labelText: context.loc.confirmPassword,
                          controller: _confirmPasswordController,
                          isPassword: true,
                          obscureText: !_showConfirmPassword,
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          onTogglePassword: () => setState(
                            () => _showConfirmPassword = !_showConfirmPassword,
                          ),
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return context.loc.passwordRequired;
                            }
                            if (value != _passwordController.text) {
                              return context.loc.passwordsDoNotMatch;
                            }
                            return null;
                          },
                        ),
                        if (errorMessage != null) ...[
                          SizedBox(height: Dimensions.r16.dynamicH),
                          Text(
                            errorMessage,
                            style: TextStyle(
                              color: context.colorScheme.error,
                              fontSize: Dimensions.r13.dynamicSP,
                            ),
                          ),
                        ],
                        SizedBox(height: Dimensions.r32.dynamicH),
                        SizedBox(
                          height: Dimensions.r56.dynamicH,
                          child: FilledButton(
                            onPressed: isUpdating ? null : _submit,
                            child: isUpdating
                                ? SizedBox(
                                    height: Dimensions.r20.dynamicH,
                                    width: Dimensions.r20.dynamicH,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Update Password'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

class ResetPasswordInvalidLink extends StatelessWidget {
  const ResetPasswordInvalidLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(Dimensions.r24.dynamicW),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: Dimensions.r72.dynamicW,
                  height: Dimensions.r72.dynamicH,
                  decoration: BoxDecoration(
                    color: context.errorColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.link_off_rounded,
                    size: Dimensions.r36.dynamicH,
                    color: context.errorColor,
                  ),
                ),
              ),
              SizedBox(height: Dimensions.r20.dynamicH),
              Text(
                'This password reset link is invalid or has expired. '
                'Request a new link to continue.',
                textAlign: TextAlign.center,
                style: context.titleLarge?.copyWith(
                  color: context.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.r18.dynamicSP,
                ),
              ),
              SizedBox(height: Dimensions.r24.dynamicH),
              SizedBox(
                height: Dimensions.r56.dynamicH,
                child: FilledButton(
                  onPressed: () => context.go(AppRoutes.forgotPassword),
                  child: Text(context.loc.sendResetLink),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
