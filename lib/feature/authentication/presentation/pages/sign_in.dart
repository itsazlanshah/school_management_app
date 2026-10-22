import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';
import 'package:flutter_application_1/core/widgets/custom_text_field.dart';
import 'package:flutter_application_1/core/widgets/primary_button.dart';
import 'package:flutter_application_1/feature/authentication/data/auth_repository.dart';
import 'package:flutter_application_1/feature/authentication/presentation/pages/sign_up.dart';
import 'package:flutter_application_1/feature/authentication/widget/auth_header.dart';
import 'package:flutter_application_1/feature/home_screen/presentation/pages/home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authRepository = AuthRepository();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_isLoading) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      _showMessage('Please fill out both email and password.', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _authRepository.signIn(email, password);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
      );
    } on Exception {
      if (!mounted) return;
      _showMessage('Invalid email or password.', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError
              ? AppColors.error
              : AppColors.tertiaryContainer,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AuthHeader(),
                  const SizedBox(height: 24),
                  _buildSignInCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sign In', style: AppTextStyles.title),
          const SizedBox(height: 4),
          const Text(
            'Enter your credentials to continue',
            style: AppTextStyles.body,
          ),
          const SizedBox(height: 20),
          _buildEmailField(),
          const SizedBox(height: 16),
          _buildPasswordField(),
          const SizedBox(height: 8),
          _buildRememberMeRow(),
          const SizedBox(height: 8),
          PrimaryButton(
            text: 'Sign In',
            onPressed: _signIn,
            isLoading: _isLoading,
          ),
          const SizedBox(height: 16),
          _buildSignUpRow(),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return CustomTextField(
      label: 'Email Address',
      hintText: 'admin@school.com',
      prefixIcon: Icons.mail_outline,
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildPasswordField() {
    return CustomTextField(
      label: 'Password',
      hintText: '••••••••',
      prefixIcon: Icons.lock_outline,
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      suffixIcon: IconButton(
        tooltip: _isPasswordVisible ? 'Hide password' : 'Show password',
        onPressed: () {
          setState(() => _isPasswordVisible = !_isPasswordVisible);
        },
        icon: Icon(
          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
        ),
      ),
    );
  }

  Widget _buildRememberMeRow() {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Checkbox(
                value: _rememberMe,
                onChanged: (value) {
                  setState(() => _rememberMe = value ?? false);
                },
                activeColor: AppColors.primaryContainer,
              ),
              const Flexible(
                child: Text('Remember Me', style: AppTextStyles.body),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () => _showMessage('Password reset is not available yet.'),
          child: const Text('Forgot Password?', style: AppTextStyles.action),
        ),
      ],
    );
  }

  Widget _buildSignUpRow() {
    return Center(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text("Don't have an account? ", style: AppTextStyles.body),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const SignUpScreen()),
              );
            },
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Sign Up', style: AppTextStyles.action),
          ),
        ],
      ),
    );
  }
}
