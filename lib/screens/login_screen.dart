import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/api_service.dart';
import '../utils/app_colors.dart';
import '../widgets/parqit_logo.dart';
import '../widgets/parqit_text_field.dart';
import '../widgets/primary_button.dart';
import 'home_screen.dart';

/// Screen 2 — Login Screen
///
/// Flow:
///  1. User enters 10-digit phone number → taps "Send OTP"
///     → calls ApiService.sendOtp() (mock)
///  2. OTP input field slides in → user enters OTP → taps "Verify"
///     → calls ApiService.verifyOtp() (mock, accepts '1234')
///  3. On success → navigates to HomeScreen with a fade transition.
///
/// API calls: ALL through ApiService — never directly in this file.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _apiService = ApiService();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();

  bool _otpSent = false;
  bool _isSendingOtp = false;
  bool _isVerifying = false;
  String? _phoneError;
  String? _otpError;

  // Animation controller for OTP section slide-in
  late final AnimationController _otpAnimController;
  late final Animation<double> _otpFadeAnim;
  late final Animation<Offset> _otpSlideAnim;

  @override
  void initState() {
    super.initState();
    _otpAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _otpFadeAnim = CurvedAnimation(
      parent: _otpAnimController,
      curve: Curves.easeOut,
    );
    _otpSlideAnim = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _otpAnimController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _otpAnimController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  Future<void> _handleSendOtp() async {
    final phone = _phoneController.text.trim();
    setState(() {
      _phoneError = null;
      _isSendingOtp = true;
    });

    try {
      await _apiService.sendOtp(phone);
      if (!mounted) return;
      setState(() {
        _otpSent = true;
        _isSendingOtp = false;
      });
      _otpAnimController.forward();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _phoneError = e.toString();
        _isSendingOtp = false;
      });
    }
  }

  Future<void> _handleVerifyOtp() async {
    final phone = _phoneController.text.trim();
    final otp = _otpController.text.trim();

    setState(() {
      _otpError = null;
      _isVerifying = true;
    });

    try {
      await _apiService.verifyOtp(phone, otp);
      if (!mounted) return;
      _navigateToHome();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _otpError = e.toString();
        _isVerifying = false;
      });
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void _handleResendOtp() {
    setState(() {
      _otpSent = false;
      _otpError = null;
      _otpController.clear();
      _otpAnimController.reset();
    });
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final topPadding = MediaQuery.paddingOf(context).top;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.brandGradient),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            24,
            topPadding + 32,
            24,
            40,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenSize.height - topPadding - 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Logo ────────────────────────────────────────────────────
                Center(
                  child: ParqitLogo(
                    iconSize: (screenSize.shortestSide * 0.18).clamp(64.0, 96.0),
                    showTagline: false,
                  ),
                ),

                SizedBox(height: screenSize.height * 0.055),

                // ── Heading ─────────────────────────────────────────────────
                Text(
                  'Welcome back',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your mobile number to get started.',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 36),

                // ── Phone Number Field ────────────────────────────────────────
                _PhonePrefix(
                  child: ParqitTextField(
                    label: 'Mobile Number',
                    hint: '10-digit number',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    prefixIcon: Icons.phone_outlined,
                    errorText: _phoneError,
                    enabled: !_otpSent && !_isSendingOtp,
                    maxLength: 10,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _handleSendOtp(),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Send OTP Button ───────────────────────────────────────────
                PrimaryButton(
                  label: _otpSent ? 'OTP Sent ✓' : 'Send OTP',
                  isLoading: _isSendingOtp,
                  onPressed: _otpSent ? null : _handleSendOtp,
                ),

                // ── OTP Section (animated slide-in) ───────────────────────────
                if (_otpSent)
                  SlideTransition(
                    position: _otpSlideAnim,
                    child: FadeTransition(
                      opacity: _otpFadeAnim,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 32),

                          // Divider with label
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: AppColors.inputBorder,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  'OTP sent to +91 ${_phoneController.text.trim()}',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: AppColors.inputBorder,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // OTP field
                          ParqitTextField(
                            label: 'Enter OTP',
                            hint: '4-digit OTP',
                            controller: _otpController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            prefixIcon: Icons.lock_outline_rounded,
                            errorText: _otpError,
                            enabled: !_isVerifying,
                            maxLength: 4,
                            autofocus: true,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => _handleVerifyOtp(),
                          ),

                          const SizedBox(height: 20),

                          // Verify button
                          PrimaryButton(
                            label: 'Verify',
                            isLoading: _isVerifying,
                            onPressed: _handleVerifyOtp,
                          ),

                          const SizedBox(height: 16),

                          // Resend OTP
                          Center(
                            child: TextButton(
                              onPressed: _isVerifying ? null : _handleResendOtp,
                              child: Text(
                                'Resend OTP',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppColors.accentCyan,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 40),

                // ── Footer ───────────────────────────────────────────────────
                Center(
                  child: Text(
                    'By continuing, you agree to our Terms & Privacy Policy.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textMuted,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Private helper — adds +91 country code prefix to the phone field
// ---------------------------------------------------------------------------
class _PhonePrefix extends StatelessWidget {
  const _PhonePrefix({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Offset the text field to make room for prefix inside
        Padding(
          padding: const EdgeInsets.only(left: 56),
          child: child,
        ),
        // +91 prefix badge sitting inside the field area
        Positioned(
          left: 0,
          top: 25, // align with the input field (below the label)
          child: Container(
            width: 52,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              border: const Border(
                top: BorderSide(color: AppColors.inputBorder),
                left: BorderSide(color: AppColors.inputBorder),
                bottom: BorderSide(color: AppColors.inputBorder),
              ),
            ),
            child: Center(
              child: Text(
                '+91',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
