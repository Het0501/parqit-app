import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

/// Reusable primary CTA button for PARQIT.
///
/// Features:
///  • Gradient background (blue → cyan) when enabled.
///  • Subtle shimmer pressed effect via InkWell.
///  • Shows a [CircularProgressIndicator] when [isLoading] is true.
///  • Disabled state with reduced opacity when [onPressed] is null or loading.
///
/// Usage:
///   PrimaryButton(label: 'Send OTP', onPressed: _handleSendOtp)
///   PrimaryButton(label: 'Verify', onPressed: _handleVerify, isLoading: true)
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  bool get _isEnabled => onPressed != null && !isLoading;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: _isEnabled ? 1.0 : 0.55,
      child: Container(
        height: 54,
        decoration: BoxDecoration(
          gradient: _isEnabled
              ? const LinearGradient(
                  colors: [AppColors.accentBlue, AppColors.accentCyan],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          color: _isEnabled ? null : AppColors.inputBorder,
          borderRadius: BorderRadius.circular(14),
          boxShadow: _isEnabled
              ? [
                  BoxShadow(
                    color: AppColors.accentCyan.withValues(alpha: 0.28),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _isEnabled ? onPressed : null,
            borderRadius: BorderRadius.circular(14),
            splashColor: Colors.white.withValues(alpha: 0.12),
            highlightColor: Colors.white.withValues(alpha: 0.06),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryDark,
                        ),
                      ),
                    )
                  : Text(
                      label,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _isEnabled
                            ? AppColors.primaryDark
                            : AppColors.textSecondary,
                        letterSpacing: 0.3,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
