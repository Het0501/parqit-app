import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

/// Reusable PARQIT logo widget.
///
/// Renders:
///  • A glowing gradient "P" icon inside a rounded square.
///  • The PARQIT wordmark with a white-to-cyan gradient.
///  • An optional tagline beneath.
///
/// Usage:
///   const ParqitLogo()            // default size (96 px icon)
///   ParqitLogo(iconSize: 80)      // custom icon size
class ParqitLogo extends StatelessWidget {
  const ParqitLogo({
    super.key,
    this.iconSize = 96.0,
    this.showTagline = true,
  });

  final double iconSize;
  final bool showTagline;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Glowing icon box ────────────────────────────────────────────────
        Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(iconSize * 0.24),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.accentBlue, AppColors.accentCyan],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentCyan.withValues(alpha: 0.45),
                blurRadius: 32,
                spreadRadius: 4,
              ),
              BoxShadow(
                color: AppColors.accentBlue.withValues(alpha: 0.30),
                blurRadius: 16,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Text(
              'P',
              style: GoogleFonts.inter(
                fontSize: iconSize * 0.52,
                fontWeight: FontWeight.w900,
                color: AppColors.primaryDark,
                height: 1.0,
              ),
            ),
          ),
        ),

        SizedBox(height: iconSize * 0.28),

        // ── Wordmark with gradient shader ──────────────────────────────────
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppColors.textPrimary, AppColors.accentCyan],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(bounds),
          blendMode: BlendMode.srcIn,
          child: Text(
            'PARQIT',
            style: AppTextStyles.logoTitle(fontSize: iconSize * 0.44),
          ),
        ),

        if (showTagline) ...[
          const SizedBox(height: 10),
          Text(
            'SMART PARKING · REIMAGINED',
            style: AppTextStyles.logoTagline,
          ),
        ],
      ],
    );
  }
}
