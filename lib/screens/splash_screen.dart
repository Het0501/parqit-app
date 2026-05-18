import 'dart:math' as math;
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
///
/// Refinements:
///  • Premium physical bobbing/floating effect for the logo.
///  • Smooth, gentle pulsing on background ambient glow blobs.
///  • Responsive scale calculations based on device screen metrics.
///  • Enhanced bottom version text legibility.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _introController;
  late final AnimationController _floatController;
  late final AnimationController _glowPulseController;

  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _floatAnimation;
  late final Animation<double> _glowPulseAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Entrance / Intro Controller (900ms)
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _introController,
      curve: Curves.easeIn,
    );

    // Using a subtle elastic-out curve for that tactile, premium feel
    _scaleAnimation = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Cubic(0.2, 0.9, 0.1, 1.0), // Fast start, ultra smooth settle
      ),
    );

    // 2. Premium Continuous Bobbing/Floating Controller
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    _floatAnimation = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(
        parent: _floatController,
        curve: Curves.easeInOutSine,
      ),
    );

    // 3. Background Glow Pulsing Controller
    _glowPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );

    _glowPulseAnimation = Tween<double>(begin: 0.88, end: 1.12).animate(
      CurvedAnimation(
        parent: _glowPulseController,
        curve: Curves.easeInOutQuad,
      ),
    );

    // Start Intro Transition
    _introController.forward().then((_) {
      // Once intro is done, start the continuous micro-animations
      if (mounted) {
        _floatController.repeat(reverse: true);
        _glowPulseController.repeat(reverse: true);
      }
    });

    // Start background pulsing immediately for organic feel
    _glowPulseController.repeat(reverse: true);

    // Navigate to Login Screen after 2.2 seconds total delay to let smooth intro settle
    Future.delayed(const Duration(milliseconds: 2200), _navigateToLogin);
  }

  void _navigateToLogin() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 450),
      ),
    );
  }

  @override
  void dispose() {
    _introController.dispose();
    _floatController.dispose();
    _glowPulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Responsive scaling setup for logo sizes
    final screenSize = MediaQuery.sizeOf(context);
    final shortestSide = screenSize.shortestSide;
    
    // Scale logo dynamically but restrict it between premium limits (84.0px to 140.0px)
    final responsiveLogoSize = (shortestSide * 0.24).clamp(84.0, 140.0);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.brandGradient,
        ),
        child: Stack(
          children: [
            // ── Decorative Ambient Glow 1 (Top Right) ──────────────────────
            AnimatedBuilder(
              animation: _glowPulseAnimation,
              builder: (context, child) {
                return Positioned(
                  top: -100,
                  right: -100,
                  child: Transform.scale(
                    scale: _glowPulseAnimation.value,
                    child: _GlowCircle(
                      color: AppColors.accentBlue.withValues(alpha: 0.16),
                      size: 320,
                    ),
                  ),
                );
              },
            ),

            // ── Decorative Ambient Glow 2 (Bottom Left) ─────────────────────
            AnimatedBuilder(
              animation: _glowPulseAnimation,
              builder: (context, child) {
                return Positioned(
                  bottom: -80,
                  left: -80,
                  child: Transform.scale(
                    scale: _glowPulseAnimation.value * 0.95,
                    child: _GlowCircle(
                      color: AppColors.accentCyan.withValues(alpha: 0.11),
                      size: 260,
                    ),
                  ),
                );
              },
            ),

            // ── Centered Floating Logo ──────────────────────────────────────
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: AnimatedBuilder(
                    animation: _floatAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _floatAnimation.value),
                        child: ParqitLogo(
                          iconSize: responsiveLogoSize,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // ── Version Tag at Bottom ───────────────────────────────────────
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: math.max(32.0, screenSize.height * 0.05),
                ),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'v1.0.0',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary.withValues(alpha: 0.65),
                      letterSpacing: 2.0,
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
// Ambient Glow Blur Circle Widget
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
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: color.a),
            blurRadius: 80,
            spreadRadius: 20,
          ),
        ],
      ),
    );
  }
}
