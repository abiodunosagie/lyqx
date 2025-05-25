import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lyqx/presentation/components/button_base.dart';
import 'package:lyqx/theme/app_colors.dart';

import '../../../data/model/user_model.dart';
import '../../../viewmodel/auth_cubit.dart';
import '../../components/app_text.dart';
import '../../components/custom_form_field.dart';
import '../../components/primary_button.dart';
import '../../components/spacing.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your username';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Perform actual authentication via AuthCubit
      final user = User(
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final authCubit = context.read<AuthCubit>();
      final success = await authCubit.login(user);

      setState(() {
        _isLoading = false;
      });

      if (success && mounted) {
        // Login succeeded, navigate to home screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful!'),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/home');
      } else if (mounted) {
        // Login failed, show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login failed. Check your credentials.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _unfocus() {
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unfocus,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppText.displayMedium(
                        'Welcome back! Glad\nto see you, Again!'),
                    Spacing.verticalM,
                    CustomFormField(
                      label: 'Username',
                      hint: 'Enter your username',
                      controller: _usernameController,
                      inputType: InputFieldType.text,
                      validator: _validateUsername,
                      textInputAction: TextInputAction.next,
                      autoFocus: true,
                    ),
                    Spacing.verticalM,
                    CustomFormField(
                      label: 'Password',
                      hint: 'Enter your password',
                      controller: _passwordController,
                      inputType: InputFieldType.password,
                      obscureText: _obscurePassword,
                      suffixIcon: GestureDetector(
                        onTap: _togglePasswordVisibility,
                        child: Icon(
                          _obscurePassword ? Iconsax.eye : Iconsax.eye_slash,
                        ),
                      ),
                      validator: _validatePassword,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _handleLogin(),
                    ),
                    Spacing.verticalXL,
                    PrimaryButton(
                      size: ButtonSize.large,
                      backgroundColor: AppColors.backgroundDark,
                      text: 'Sign In',
                      onPressed: _handleLogin,
                      isLoading: _isLoading,
                    ),
                    Spacing.verticalL,
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppText.titleSmall(
                            "Demo Login Credentials:",
                            fontWeight: FontWeight.bold,
                          ),
                          Spacing.verticalXS2,
                          AppText.bodySmall("Username: johnd"),
                          Spacing.verticalXS2,
                          AppText.bodySmall("Password: m38rmF\$"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
