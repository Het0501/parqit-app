import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

/// Screen 2 — Login Screen  (PLACEHOLDER — not yet built)
///
/// This stub exists solely as a navigation target from SplashScreen.
/// It will be fully implemented in the next task: ceo/login-screen.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.brandGradient),
        child: Center(
          child: Text(
            'Login Screen\n(Coming next)',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge,  // getter — not a const
          ),
        ),
      ),
    );
  }
}
