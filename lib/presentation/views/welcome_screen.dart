import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lyqx/presentation/components/button_base.dart';
import 'package:lyqx/theme/app_colors.dart';

import '../components/app_text.dart';
import '../components/primary_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/welcome_image.png',
            fit: BoxFit.cover,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(
                    flex: 4,
                  ),
                  SizedBox(
                    width: 70,
                    height: 70,
                    child: Image.asset('assets/images/Branding.png'),
                  ),
                  const SizedBox(height: 10),
                  AppText.displayLarge('Fake Store'),
                  const SizedBox(height: 30),
                  PrimaryButton(
                    size: ButtonSize.large,
                    text: 'Login',
                    backgroundColor: AppColors.backgroundDark,
                    onPressed: () {
                      context.go('/signin');
                    },
                  ),
                  Spacer(
                    flex: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
