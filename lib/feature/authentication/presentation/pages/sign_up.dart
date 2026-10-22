import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_theme.dart';
import 'package:flutter_application_1/core/widgets/custom_text_field.dart';
import 'package:flutter_application_1/core/widgets/primary_button.dart';
import 'package:flutter_application_1/feature/authentication/data/auth_repository.dart';
import 'package:flutter_application_1/feature/authentication/domain/user.dart';
import 'package:flutter_application_1/feature/authentication/presentation/pages/sign_in.dart';
import 'package:flutter_application_1/feature/authentication/widget/auth_header.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authRepository = AuthRepository();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_isLoading) return;

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showMessage('Please fill out all fields.', isError: true);
      return;
    }

    if (password != confirmPassword) {
      _showMessage('Passwords do not match.', isError: true);
      return;
    }

    if (password.length < 6) {
      _showMessage(
        'Password must be at least 6 characters long.',
        isError: true,
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _authRepository.signUp(
        User(name: name, email: email, password: password),
      );
      if (!mounted) return;

      _showMessage('Account created successfully.');
      final navigator = Navigator.of(context);
      if (navigator.canPop()) {
        navigator.pop();
      } else {
        navigator.pushReplacement(
          MaterialPageRoute<void>(builder: (_) => const SignInScreen()),
        );
      }
    } on Exception catch (error) {
      if (!mounted) return;
      _showMessage(
        error.toString().replaceFirst('Exception: ', ''),
        isError: true,
      );
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
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AuthHeader(subtitle: 'Create an Account'),
                  const SizedBox(height: 24),
                  _buildSignUpCard(),
                  const SizedBox(height: 16),
                  _buildSignInLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
          _buildNameField(),
          const SizedBox(height: 16),
          _buildEmailField(),
          const SizedBox(height: 16),
          _buildPasswordField(),
          const SizedBox(height: 16),
          _buildConfirmPasswordField(),
          const SizedBox(height: 12),
          _buildPasswordHint(),
          const SizedBox(height: 8),
          PrimaryButton(
            text: 'Sign Up',
            onPressed: _signUp,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return CustomTextField(
      label: 'Full Name',
      hintText: 'e.g. Muhammad Usman',
      prefixIcon: Icons.person_outline,
      controller: _nameController,
    );
  }

  Widget _buildEmailField() {
    return CustomTextField(
      label: 'Email',
      hintText: 'usman@example.com',
      prefixIcon: Icons.mail_outline,
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildPasswordField() {
    return CustomTextField(
      label: 'Password',
      hintText: 'Enter password',
      prefixIcon: Icons.lock_outline,
      controller: _passwordController,
      obscureText: _obscurePassword,
      suffixIcon: IconButton(
        tooltip: _obscurePassword ? 'Show password' : 'Hide password',
        onPressed: () {
          setState(() => _obscurePassword = !_obscurePassword);
        },
        icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return CustomTextField(
      label: 'Confirm Password',
      hintText: 'Re-enter password',
      prefixIcon: Icons.lock_outline,
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      suffixIcon: IconButton(
        tooltip: _obscureConfirmPassword
            ? 'Show confirm password'
            : 'Hide confirm password',
        onPressed: () {
          setState(() {
            _obscureConfirmPassword = !_obscureConfirmPassword;
          });
        },
        icon: Icon(
          _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
        ),
      ),
    );
  }

  Widget _buildPasswordHint() {
    return const Row(
      children: [
        Icon(Icons.info_outline, size: 16, color: AppColors.secondary),
        SizedBox(width: 4),
        Text(
          'Password must be at least 6 characters',
          style: AppTextStyles.helper,
        ),
      ],
    );
  }

  Widget _buildSignInLink() {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const Text(
          'Already have an account?',
          style: AppTextStyles.secondaryBody,
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Sign In',
            style: AppTextStyles.action,
          ),
        ),
      ],
    );
  }
}
