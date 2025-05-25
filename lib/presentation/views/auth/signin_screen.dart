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
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Welcome back! Login successful'),
              ],
            ),
            backgroundColor: AppColors.successDarkMode,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
        context.go('/home');
      } else if (mounted) {
        // Login failed, show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 8),
                Text('Login failed. Check your credentials.'),
              ],
            ),
            backgroundColor: AppColors.errorDarkMode,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: _unfocus,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: true,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  isDarkMode ? AppColors.backgroundDarkSurface2 : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    isDarkMode ? AppColors.borderDarkSubtle : Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: IconButton(
              icon: Icon(
                Iconsax.arrow_left,
                color: isDarkMode
                    ? AppColors.textDarkPrimary
                    : AppColors.textLightPrimary,
                size: 20,
              ),
              onPressed: () => context.go('/home'),
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Welcome Header Section
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: isDarkMode
                            ? AppColors.darkBrandGradient
                            : AppColors.brandGradient,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: (isDarkMode
                                    ? AppColors.primaryLight
                                    : AppColors.primary)
                                .withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Iconsax.security_user,
                            color: Colors.white,
                            size: 40,
                          ),
                          Spacing.verticalM,
                          AppText.displayMedium(
                            'Welcome back!',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          Spacing.verticalXS,
                          AppText.bodyLarge(
                            'Sign in to continue your shopping journey',
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ],
                      ),
                    ),

                    Spacing.verticalXL,

                    // Form Section
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppColors.backgroundDarkSurface1
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDarkMode
                              ? AppColors.borderDarkSubtle
                              : Colors.grey[200]!,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isDarkMode
                                ? Colors.black.withOpacity(0.2)
                                : Colors.grey.withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          CustomFormField(
                            label: 'Username',
                            hint: 'Enter your username',
                            controller: _usernameController,
                            inputType: InputFieldType.text,
                            validator: _validateUsername,
                            textInputAction: TextInputAction.next,
                            autoFocus: true,
                            borderRadius: 16,
                            fillColor: isDarkMode
                                ? AppColors.backgroundDarkSurface2
                                : Colors.grey[50],
                            borderColor: isDarkMode
                                ? AppColors.borderDarkInput
                                : Colors.grey[300],
                            focusedBorderColor: isDarkMode
                                ? AppColors.primaryLight
                                : AppColors.primary,
                            prefixIcon: Icon(
                              Iconsax.user,
                              color: isDarkMode
                                  ? AppColors.textDarkSecondary
                                  : AppColors.textLightSecondary,
                            ),
                          ),
                          Spacing.verticalM,
                          CustomFormField(
                            label: 'Password',
                            hint: 'Enter your password',
                            controller: _passwordController,
                            inputType: InputFieldType.password,
                            obscureText: _obscurePassword,
                            borderRadius: 16,
                            fillColor: isDarkMode
                                ? AppColors.backgroundDarkSurface2
                                : Colors.grey[50],
                            borderColor: isDarkMode
                                ? AppColors.borderDarkInput
                                : Colors.grey[300],
                            focusedBorderColor: isDarkMode
                                ? AppColors.primaryLight
                                : AppColors.primary,
                            prefixIcon: Icon(
                              Iconsax.lock,
                              color: isDarkMode
                                  ? AppColors.textDarkSecondary
                                  : AppColors.textLightSecondary,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: _togglePasswordVisibility,
                              child: Icon(
                                _obscurePassword
                                    ? Iconsax.eye
                                    : Iconsax.eye_slash,
                                color: isDarkMode
                                    ? AppColors.textDarkSecondary
                                    : AppColors.textLightSecondary,
                              ),
                            ),
                            validator: _validatePassword,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _handleLogin(),
                          ),
                        ],
                      ),
                    ),

                    Spacing.verticalXL,

                    // Sign In Button
                    Container(
                      decoration: BoxDecoration(
                        gradient: isDarkMode
                            ? AppColors.darkBrandGradient
                            : AppColors.brandGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: (isDarkMode
                                    ? AppColors.primaryLight
                                    : AppColors.primary)
                                .withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: PrimaryButton(
                        size: ButtonSize.large,
                        backgroundColor: Colors.transparent,
                        text: 'Sign In',
                        onPressed: _handleLogin,
                        isLoading: _isLoading,
                        leadingIcon: Iconsax.login,
                      ),
                    ),

                    Spacing.verticalL,

                    // Demo Credentials Section
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? AppColors.backgroundDarkSurface2
                            : Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDarkMode
                              ? AppColors.borderDarkSubtle
                              : Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Iconsax.info_circle,
                                color: isDarkMode
                                    ? AppColors.infoDarkMode
                                    : AppColors.info,
                                size: 20,
                              ),
                              Spacing.horizontalXS,
                              AppText.titleSmall(
                                "Demo Login Credentials",
                                fontWeight: FontWeight.bold,
                                color: isDarkMode
                                    ? AppColors.textDarkHighEmphasis
                                    : AppColors.textLightPrimary,
                              ),
                            ],
                          ),
                          Spacing.verticalS,
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? AppColors.backgroundDarkSurface3
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isDarkMode
                                    ? AppColors.borderDarkInput
                                    : Colors.grey[300]!,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    AppText.bodyMedium(
                                      "Username: ",
                                      color: isDarkMode
                                          ? AppColors.textDarkSecondary
                                          : AppColors.textLightSecondary,
                                    ),
                                    AppText.bodyMedium(
                                      "johnd",
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode
                                          ? AppColors.primaryLight
                                          : AppColors.primary,
                                    ),
                                  ],
                                ),
                                Spacing.verticalXS2,
                                Row(
                                  children: [
                                    AppText.bodyMedium(
                                      "Password: ",
                                      color: isDarkMode
                                          ? AppColors.textDarkSecondary
                                          : AppColors.textLightSecondary,
                                    ),
                                    AppText.bodyMedium(
                                      "m38rmF\$",
                                      fontWeight: FontWeight.bold,
                                      color: isDarkMode
                                          ? AppColors.primaryLight
                                          : AppColors.primary,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Spacing.verticalXL,
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
