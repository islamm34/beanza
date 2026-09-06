import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class CafeCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final VoidCallback? onTap;
  final bool isElevated;

  const CafeCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = 18,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.onTap,
    this.isElevated = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBg = isElevated
        ? (isDark ? AppColors.darkCardElevated : AppColors.lightCardElevated)
        : (isDark ? AppColors.darkCardBg : AppColors.lightCardBg);
    final defaultBorder = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    final container = Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? defaultBg,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? defaultBorder,
          width: borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: container,
        ),
      );
    }

    return container;
  }
}

class CafeOptionChip extends StatelessWidget {
  final String label;
  final String? subtitle;
  final String? trailing;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const CafeOptionChip({
    Key? key,
    required this.label,
    this.subtitle,
    this.trailing,
    required this.isSelected,
    required this.onTap,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.gold : AppColors.goldLight;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? goldColor.withValues(alpha: isDark ? 0.18 : 0.12)
              : (isDark
                  ? AppColors.darkCardElevated
                  : AppColors.lightSecondaryBg),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? goldColor
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 16,
                    color: isSelected
                        ? goldColor
                        : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary),
                  ),
                  const SizedBox(width: 6),
                ],
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: isSelected
                            ? (isDark ? AppColors.goldBright : goldColor)
                            : (isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary),
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                          fontSize: 10,
                        ),
                      ),
                  ],
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 6),
                  Text(
                    trailing!,
                    style: TextStyle(
                      color: isSelected
                          ? goldColor
                          : (isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CafeBadge extends StatelessWidget {
  final String text;
  final Color? color;
  final bool isGreen;
  final bool isGold;
  final IconData? icon;

  const CafeBadge({
    Key? key,
    required this.text,
    this.color,
    this.isGreen = false,
    this.isGold = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Color badgeColor = color ??
        (isGreen
            ? (isDark ? AppColors.primaryGreen : AppColors.primaryGreenLight)
            : (isGold
                ? (isDark ? AppColors.gold : AppColors.goldLight)
                : (isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary)));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: isDark ? 0.18 : 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: badgeColor.withValues(alpha: isDark ? 0.45 : 0.35),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: badgeColor),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              color: badgeColor,
              fontWeight: FontWeight.bold,
              fontSize: 11,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
