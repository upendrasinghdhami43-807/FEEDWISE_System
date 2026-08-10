import 'package:flutter/material.dart';
import '../../app/theme/theme.dart';

enum FWButtonVariant { primary, secondary, outline, ghost, danger }

enum FWButtonSize { small, medium, large }

class FWButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final FWButtonVariant variant;
  final FWButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;

  const FWButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = FWButtonVariant.primary,
    this.size = FWButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: _iconSize),
                const SizedBox(width: 6),
              ],
              Text(label, style: _textStyle),
            ],
          );

    final buttonChild = isFullWidth
        ? SizedBox(width: double.infinity, child: Center(child: child))
        : child;

    return switch (variant) {
      FWButtonVariant.primary => ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary500,
            foregroundColor: Colors.white,
            padding: _padding,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
            minimumSize: isFullWidth ? const Size.fromHeight(48) : null,
          ),
          child: buttonChild,
        ),
      FWButtonVariant.secondary => ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary400,
            foregroundColor: Colors.white,
            padding: _padding,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
            minimumSize: isFullWidth ? const Size.fromHeight(48) : null,
          ),
          child: buttonChild,
        ),
      FWButtonVariant.outline => OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary500,
            padding: _padding,
            side: const BorderSide(color: AppColors.primary500, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
            minimumSize: isFullWidth ? const Size.fromHeight(48) : null,
          ),
          child: buttonChild,
        ),
      FWButtonVariant.ghost => TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary500,
            padding: _padding,
            minimumSize: isFullWidth ? const Size.fromHeight(48) : null,
          ),
          child: buttonChild,
        ),
      FWButtonVariant.danger => ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.evidenceMissing,
            foregroundColor: Colors.white,
            padding: _padding,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
            minimumSize: isFullWidth ? const Size.fromHeight(48) : null,
          ),
          child: buttonChild,
        ),
    };
  }

  EdgeInsets get _padding => switch (size) {
        FWButtonSize.small => const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        FWButtonSize.medium => const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        FWButtonSize.large => const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      };

  double get _iconSize => switch (size) {
        FWButtonSize.small => 14,
        FWButtonSize.medium => 16,
        FWButtonSize.large => 20,
      };

  TextStyle get _textStyle => switch (size) {
        FWButtonSize.small => AppTypography.labelSmall,
        FWButtonSize.medium => AppTypography.labelMedium,
        FWButtonSize.large => AppTypography.labelLarge,
      };
}
