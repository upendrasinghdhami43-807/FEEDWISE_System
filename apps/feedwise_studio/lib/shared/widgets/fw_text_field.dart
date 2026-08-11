import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class FWTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final int maxLines;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final Widget? prefix;
  final Widget? suffix;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool obscureText;
  final bool autofocus;
  final FocusNode? focusNode;

  const FWTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.prefix,
    this.suffix,
    this.readOnly = false,
    this.onTap,
    this.obscureText = false,
    this.autofocus = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              color: AppColors.textSecondaryDark,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
        ],
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          readOnly: readOnly,
          onTap: onTap,
          obscureText: obscureText,
          autofocus: autofocus,
          focusNode: focusNode,
          style: const TextStyle(
            color: AppColors.textPrimaryDark,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefix,
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}

// ─── Search Field ─────────────────────────────────────────────────────────────

class FWSearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;

  const FWSearchField({
    super.key,
    this.hint = 'Search...',
    required this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(color: AppColors.textPrimaryDark, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textTertiaryDark),
        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textTertiaryDark, size: 20),
        filled: true,
        fillColor: AppColors.surfaceElevatedDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary500, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
