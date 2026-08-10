import 'package:flutter/material.dart';
import 'package:feedwise_mobile/app/theme/theme.dart';

class FWCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final Border? border;
  final double? borderRadius;
  final Gradient? gradient;

  const FWCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = backgroundColor ??
        (isDark ? AppColors.surfaceCardDark : AppColors.surfaceCardLight);
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.lg),
        child: Ink(
          decoration: BoxDecoration(
            color: gradient == null ? bgColor : null,
            gradient: gradient,
            borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.lg),
            border: border ?? Border.all(color: borderColor, width: 1),
          ),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppSpacing.cardPadding),
            child: child,
          ),
        ),
      ),
    );
  }
}

class FWGradientCard extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final VoidCallback? onTap;
  final EdgeInsets? padding;

  const FWGradientCard({
    super.key,
    required this.child,
    required this.gradient,
    this.onTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return FWCard(
      onTap: onTap,
      padding: padding,
      gradient: gradient,
      border: Border.all(color: Colors.transparent),
      child: child,
    );
  }
}
