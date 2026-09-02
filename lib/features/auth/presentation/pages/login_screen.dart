import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_color.dart';
import '../../../../core/constants/dimensions.dart';
import '../../../../core/widgets/responsive_layout.dart';
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

  void _onLogin() {
    context.read<AuthBloc>().add(
          AuthLoginRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          context.go('/home');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'LastSpot',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Dimensions.r32,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primaryColor,
                  ),
                ),
                const SizedBox(height: Dimensions.r8),
                Text(
                  'Find your activity partner instantly.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: Dimensions.r16,
                    color: context.textSecondary,
                  ),
                ),
                const SizedBox(height: Dimensions.r48),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.r12),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: Dimensions.r16),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(Dimensions.r12),
                    ),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: Dimensions.r8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      context.push('/forgot-password');
                    },
                    child: Text(
                      'Forgot Password?',
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
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.r16),
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
                          : const Text('Login'),
                    );
                  },
                ),
                const SizedBox(height: Dimensions.r16),
                TextButton(
                  onPressed: () {
                    context.push('/signup');
                  },
                  child: const Text(
                    'Don\'t have an account? Sign up',
                    style: TextStyle(color: AppColor.primaryColor),
                  ),
                ),
              ],
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
