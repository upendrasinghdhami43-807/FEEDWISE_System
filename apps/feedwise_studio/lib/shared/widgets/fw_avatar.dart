import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class FWAvatar extends StatelessWidget {
  final String name;
  final double size;
  final Color? color;
  final String? imageUrl;

  const FWAvatar({
    super.key,
    required this.name,
    this.size = 36,
    this.color,
    this.imageUrl,
  });

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Color get _defaultColor {
    if (color != null) return color!;
    final colors = [
      AppColors.primary500,
      AppColors.secondary400,
      AppColors.tertiary500,
      AppColors.warning,
      AppColors.info,
    ];
    return colors[name.hashCode.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _defaultColor.withValues(alpha: 0.2),
        border: Border.all(color: _defaultColor.withValues(alpha: 0.4), width: 1.5),
        image: imageUrl != null
          ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover)
          : null,
      ),
      child: imageUrl == null
        ? Center(
            child: Text(
              _initials,
              style: TextStyle(
                color: _defaultColor,
                fontSize: size * 0.36,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        : null,
    );
  }
}

// ─── Progress Bar ─────────────────────────────────────────────────────────────

class FWProgressBar extends StatelessWidget {
  final double value; // 0-1
  final double height;
  final Color? color;
  final Color? backgroundColor;
  final bool showLabel;

  const FWProgressBar({
    super.key,
    required this.value,
    this.height = 6,
    this.color,
    this.backgroundColor,
    this.showLabel = false,
  });

  @override
  Widget build(BuildContext context) {
    final fg = color ?? AppColors.primary500;
    final v = value.clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabel)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              '${(v * 100).round()}%',
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryDark, fontWeight: FontWeight.w600),
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(height),
          child: LinearProgressIndicator(
            value: v,
            minHeight: height,
            color: fg,
            backgroundColor: backgroundColor ?? AppColors.surfaceElevatedDark,
          ),
        ),
      ],
    );
  }
}
