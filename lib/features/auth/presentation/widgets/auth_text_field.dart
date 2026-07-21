import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Labeled outlined input used across the auth forms.
class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.suffixIcon,
    this.trailing,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onToggleObscure,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final IconData? suffixIcon;

  /// Optional widget on the right of the label row (e.g. "Forgot?").
  final Widget? trailing;

  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;

  /// When set, the suffix icon becomes a show/hide password toggle.
  final VoidCallback? onToggleObscure;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.bodyMd.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            ?trailing,
          ],
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validator: validator,
          style: AppTextStyles.bodyMd,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: onToggleObscure != null
                ? IconButton(
                    onPressed: onToggleObscure,
                    icon: Icon(
                      obscureText
                          ? Icons.lock_outline_rounded
                          : Icons.lock_open_rounded,
                      color: AppColors.textMuted,
                      size: 22,
                    ),
                  )
                : suffixIcon != null
                    ? Icon(suffixIcon, color: AppColors.textMuted, size: 22)
                    : null,
          ),
        ),
      ],
    );
  }
}
