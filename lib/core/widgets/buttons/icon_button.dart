import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? iconColor;
  final Color? backgroundColor;
  final double size;
  final double iconSize;
  final bool isEnabled;
  final String? tooltip;

  const AppIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.iconColor,
    this.backgroundColor,
    this.size = 48,
    this.iconSize = 24,
    this.isEnabled = true,
    this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = backgroundColor ?? 
        (isDark ? AppColors.darkCardBg : AppColors.lightCardBg);
    final color = iconColor ?? AppColors.espressoDark;

    return Tooltip(
      message: tooltip ?? '',
      child: SizedBox(
        width: size,
        height: size,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? onPressed : null,
            borderRadius: AppRadius.circleRadius,
            child: Container(
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: AppRadius.circleRadius,
              ),
              child: Icon(
                icon,
                color: isEnabled ? color : Colors.grey,
                size: iconSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
