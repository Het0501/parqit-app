import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

/// Reusable PARQIT logo widget.
///
/// Renders:
///  • A glowing gradient "P" icon inside a rounded square with a premium glass reflection effect.
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
        // ── Glowing icon box with glassmorphism sheen ───────────────────────
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
                color: AppColors.accentCyan.withValues(alpha: 0.35),
                blurRadius: 40,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: AppColors.accentBlue.withValues(alpha: 0.25),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(iconSize * 0.24),
            child: Stack(
              children: [
                // Glowing background elements
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(iconSize * 0.24),
                    ),
                  ),
                ),
                // "P" text
                Center(
                  child: Text(
                    'P',
                    style: GoogleFonts.inter(
                      fontSize: iconSize * 0.54,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryDark,
                      height: 1.0,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          offset: const Offset(1, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
                // Subtle glass sheen overlay (diagonal reflection)
                Positioned.fill(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.35),
                            Colors.white.withValues(alpha: 0.05),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.45, 1.0],
                        ).createShader(bounds),
                        blendMode: BlendMode.dstIn,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withValues(alpha: 0.4),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.5],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
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
          const SizedBox(height: 12),
          Text(
            'SMART PARKING · REIMAGINED',
            style: AppTextStyles.logoTagline.copyWith(
              fontSize: (iconSize * 0.13).clamp(10.0, 14.0),
            ),
          ),
        ],
      ],
    );
  }
}
