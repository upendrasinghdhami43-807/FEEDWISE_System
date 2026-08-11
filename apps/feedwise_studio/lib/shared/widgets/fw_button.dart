import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

enum FWButtonVariant { primary, secondary, ghost, danger, success, warning }
enum FWButtonSize { small, medium, large }

class FWButton extends StatefulWidget {
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
  State<FWButton> createState() => _FWButtonState();
}

class _FWButtonState extends State<FWButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  final bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ({Color bg, Color fg, Color border}) _getColors() => switch (widget.variant) {
    FWButtonVariant.primary => (
      bg: AppColors.primary500,
      fg: Colors.white,
      border: Colors.transparent,
    ),
    FWButtonVariant.secondary => (
      bg: AppColors.primary500.withValues(alpha: 0.12),
      fg: AppColors.primary400,
      border: AppColors.primary500.withValues(alpha: 0.4),
    ),
    FWButtonVariant.ghost => (
      bg: Colors.transparent,
      fg: AppColors.textSecondaryDark,
      border: AppColors.borderDark,
    ),
    FWButtonVariant.danger => (
      bg: AppColors.secondary500,
      fg: Colors.white,
      border: Colors.transparent,
    ),
    FWButtonVariant.success => (
      bg: AppColors.success,
      fg: Colors.white,
      border: Colors.transparent,
    ),
    FWButtonVariant.warning => (
      bg: AppColors.warning,
      fg: Colors.white,
      border: Colors.transparent,
    ),
  };

  EdgeInsets get _padding => switch (widget.size) {
    FWButtonSize.small  => const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    FWButtonSize.medium => const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    FWButtonSize.large  => const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
  };

  double get _fontSize => switch (widget.size) {
    FWButtonSize.small  => 12,
    FWButtonSize.medium => 14,
    FWButtonSize.large  => 16,
  };

  double get _iconSize => switch (widget.size) {
    FWButtonSize.small  => 14,
    FWButtonSize.medium => 16,
    FWButtonSize.large  => 18,
  };

  @override
  Widget build(BuildContext context) {
    final colors = _getColors();
    final isDisabled = widget.onPressed == null && !widget.isLoading;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: child,
      ),
      child: GestureDetector(
        onTapDown: (_) {
          if (!isDisabled) _controller.forward();
        },
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        child: SizedBox(
          width: widget.isFullWidth ? double.infinity : null,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.isLoading || isDisabled ? null : widget.onPressed,
              borderRadius: BorderRadius.circular(10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: _padding,
                decoration: BoxDecoration(
                  color: isDisabled ? colors.bg.withValues(alpha: 0.4) : colors.bg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: colors.border, width: 1.5),
                  boxShadow: (widget.variant == FWButtonVariant.primary && !isDisabled) ? [
                    BoxShadow(
                      color: AppColors.primary500.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ] : null,
                ),
                child: widget.isLoading
                  ? SizedBox(
                      height: _fontSize + 4,
                      width: _fontSize + 4,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(colors.fg),
                      ),
                    )
                  : Row(
                      mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(widget.icon, size: _iconSize, color: colors.fg),
                          const SizedBox(width: 7),
                        ],
                        Text(
                          widget.label,
                          style: TextStyle(
                            color: isDisabled ? colors.fg.withValues(alpha: 0.5) : colors.fg,
                            fontSize: _fontSize,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
