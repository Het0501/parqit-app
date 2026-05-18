import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/parqit_logo.dart';
import 'login_screen.dart';

/// Screen 1 — Splash Screen
///
/// Responsibilities (README spec):
///  • Show the PARQIT logo centred on screen.
///  • Fade-in + scale entrance animation (900 ms).
///  • Wait 2 seconds total, then navigate to LoginScreen with a fade transition.
///  • No business logic. No API calls. Just brand.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Animation controller — 900 ms fade-in
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    // Start fade-in immediately
    _controller.forward();

    // After 2 seconds navigate to Login
    Future.delayed(const Duration(seconds: 2), _navigateToLogin);
  }

  void _navigateToLogin() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Full-screen gradient background
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.brandGradient,
        ),
        child: Stack(
          children: [
            // Decorative ambient glow — top right
            Positioned(
              top: -80,
              right: -80,
              child: _GlowCircle(
                color: AppColors.accentBlue.withValues(alpha: 0.18),
                size: 300,
              ),
            ),

            // Decorative ambient glow — bottom left
            Positioned(
              bottom: -60,
              left: -60,
              child: _GlowCircle(
                color: AppColors.accentCyan.withValues(alpha: 0.12),
                size: 240,
              ),
            ),

            // Centred logo with fade + scale entrance
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: const ParqitLogo(),
                ),
              ),
            ),

            // Version tag at bottom
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Text(
                    'v1.0.0',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: Color(0x66B0BEC5),
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Private helper widget — ambient glow blob
// ---------------------------------------------------------------------------
class _GlowCircle extends StatelessWidget {
  const _GlowCircle({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
