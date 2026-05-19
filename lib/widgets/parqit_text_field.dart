import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

/// Reusable premium text input field for PARQIT.
///
/// Features:
///  • Dark-filled input matching the brand design system.
///  • Animated cyan focus border via [FocusNode].
///  • Optional prefix icon.
///  • Optional error text shown below the field.
///  • Keyboard type and input formatters for phone / OTP modes.
///
/// Usage:
///   ParqitTextField(
///     label: 'Phone Number',
///     hint: '10-digit mobile number',
///     controller: _phoneController,
///     keyboardType: TextInputType.phone,
///     prefixIcon: Icons.phone_outlined,
///   )
class ParqitTextField extends StatefulWidget {
  const ParqitTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.prefixIcon,
    this.errorText,
    this.enabled = true,
    this.autofocus = false,
    this.maxLength,
    this.textInputAction = TextInputAction.done,
    this.onSubmitted,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final IconData? prefixIcon;
  final String? errorText;
  final bool enabled;
  final bool autofocus;
  final int? maxLength;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  State<ParqitTextField> createState() => _ParqitTextFieldState();
}

class _ParqitTextFieldState extends State<ParqitTextField> {
  late final FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()
      ..addListener(() {
        if (mounted) {
          setState(() => _isFocused = _focusNode.hasFocus);
        }
      });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Color get _borderColor {
    if (widget.errorText != null) return AppColors.error;
    if (_isFocused) return AppColors.accentCyan;
    return AppColors.inputBorder;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: _isFocused ? AppColors.accentCyan : AppColors.textSecondary,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),

        // Input field
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: AppColors.inputFill,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _borderColor,
              width: _isFocused ? 1.5 : 1.0,
            ),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: AppColors.accentCyan.withValues(alpha: 0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            enabled: widget.enabled,
            autofocus: widget.autofocus,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.inputFormatters,
            maxLength: widget.maxLength,
            textInputAction: widget.textInputAction,
            onSubmitted: widget.onSubmitted,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
              letterSpacing: 0.5,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: GoogleFonts.inter(
                fontSize: 15,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(
                      widget.prefixIcon,
                      color: _isFocused
                          ? AppColors.accentCyan
                          : AppColors.textMuted,
                      size: 20,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              counterText: '', // hide the maxLength counter
            ),
          ),
        ),

        // Error text
        if (widget.errorText != null) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: AppColors.error,
                size: 13,
              ),
              const SizedBox(width: 4),
              Text(
                widget.errorText!,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.error,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
