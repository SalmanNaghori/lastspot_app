import 'package:lastspot_app/core/base_import.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _onResetPassword() {
    if (_formKey.currentState?.validate() ?? false) {
      AppUtils.hideKeyboard(context);
      context.read<AuthBloc>().add(
        ForgotPasswordRequested(email: _emailController.text.trim()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthOtpSent) {
          AppUtils.showSnackBar(context, context.loc.passwordResetSent);
          // The reset email returns to the mobile recovery callback.
          context.pop();
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
        automaticallyImplyLeading: false,
        leading: KhelBhaiBackButton.leading(context),
        backgroundColor: context.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
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
                      child: Icon(
                        Icons.lock_reset_rounded,
                        size: Dimensions.r40.dynamicH,
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
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      color: context.textPrimary,
                    ),
                  ),
                  SizedBox(height: Dimensions.r8.dynamicH),
                  Text(
                    context.loc.resetPasswordDesc,
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
                    textInputAction: TextInputAction.done,
                    validator: AppValidators.email(context.loc),
                  ),
                  SizedBox(height: Dimensions.r24.dynamicH),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;
                      return SizedBox(
                        height: Dimensions.r48.dynamicH * 1.15,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: context.primaryColor,
                            foregroundColor: AppColor.whiteColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                Dimensions.r14.dynamicR,
                              ),
                            ),
                          ),
                          onPressed: isLoading ? null : _onResetPassword,
                          child: isLoading
                              ? SizedBox(
                                  height: Dimensions.r20.dynamicH,
                                  width: Dimensions.r20.dynamicW,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColor.whiteColor,
                                  ),
                                )
                              : Text(
                                  context.loc.sendResetLink,
                                  style: TextStyle(
                                    fontSize: Dimensions.r16.dynamicSP,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      );
                    },
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
    super.dispose();
  }
}
