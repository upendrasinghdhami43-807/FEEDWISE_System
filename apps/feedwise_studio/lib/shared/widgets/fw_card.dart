import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class FWCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double borderRadius;
  final bool hoverable;
  final List<BoxShadow>? boxShadow;
  final Border? border;

  const FWCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.backgroundColor,
    this.borderRadius = 14,
    this.hoverable = false,
    this.boxShadow,
    this.border,
  });

  @override
  State<FWCard> createState() => _FWCardState();
}

class _FWCardState extends State<FWCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: widget.hoverable ? (_) => setState(() => _isHovered = true) : null,
      onExit: widget.hoverable ? (_) => setState(() => _isHovered = false) : null,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: widget.padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? AppColors.surfaceCardDark,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: widget.border ?? Border.all(
              color: _isHovered
                ? AppColors.primary500.withValues(alpha: 0.3)
                : AppColors.borderDark,
              width: 1,
            ),
            boxShadow: widget.boxShadow ?? [
              BoxShadow(
                color: Colors.black.withValues(alpha: _isHovered ? 0.3 : 0.15),
                blurRadius: _isHovered ? 24 : 12,
                offset: Offset(0, _isHovered ? 8 : 4),
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

// ─── Gradient Card ────────────────────────────────────────────────────────────

class FWGradientCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Gradient gradient;
  final double borderRadius;
  final VoidCallback? onTap;

  const FWGradientCard({
    super.key,
    required this.child,
    this.padding,
    this.gradient = const LinearGradient(
      colors: [Color(0xFF6C5CE7), Color(0xFF8B5CF6)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    this.borderRadius = 14,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C5CE7).withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────

class FWSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? action;

  const FWSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimaryDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    color: AppColors.textSecondaryDark,
                    fontSize: 13,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (action != null) action!,
      ],
    );
  }
}
