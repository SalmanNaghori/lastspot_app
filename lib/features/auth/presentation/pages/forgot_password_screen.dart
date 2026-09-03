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
      context.read<AuthBloc>().add(ForgotPasswordRequested(email: _emailController.text.trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthOtpSent) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.loc.passwordResetSent)));
          // Optional: navigate to OTP screen if handling deep links,
          // or just go back to login with success message.
          context.pop();
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
            padding: const EdgeInsets.all(Dimensions.r24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    context.loc.resetPassword,
                    style: TextStyle(fontSize: Dimensions.r32, fontWeight: FontWeight.bold, color: context.textPrimary),
                  ),
                  const SizedBox(height: Dimensions.r8),
                  Text(
                    context.loc.resetPasswordDesc,
                    style: TextStyle(fontSize: Dimensions.r16, color: context.textSecondary),
                  ),
                  const SizedBox(height: Dimensions.r32),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: context.loc.email,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(Dimensions.r12)),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Email is required';
                      if (!RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                      ).hasMatch(value)) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: Dimensions.r32),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryColor,
                          foregroundColor: AppColor.whiteColor,
                          padding: const EdgeInsets.symmetric(vertical: Dimensions.r16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.r12)),
                        ),
                        onPressed: state is AuthLoading ? null : _onResetPassword,
                        child: state is AuthLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: context.textPrimary),
                              )
                            : Text(context.loc.sendResetLink),
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
