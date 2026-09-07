import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final double? width;
  final double height;
  final TextStyle? textStyle;
  final Widget? icon;
  final bool isEnabled;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double borderRadius;

  const PrimaryButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.width,
    this.height = 52,
    this.textStyle,
    this.icon,
    this.isEnabled = true,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final greenColor =
        isDark ? AppColors.primaryGreen : AppColors.primaryGreenLight;
    final activeBg = backgroundColor ?? greenColor;
    final activeFg = foregroundColor ?? Colors.white;

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled && !isLoading ? onPressed : null,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            decoration: BoxDecoration(
              color: isEnabled
                  ? activeBg
                  : (isDark
                      ? const Color(0xFF222622)
                      : const Color(0xFFDDD8CE)),
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: isEnabled
                  ? [
                      BoxShadow(
                        color: activeBg.withValues(alpha: isDark ? 0.35 : 0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: isLoading
                ? Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(activeFg),
                        strokeWidth: 2.2,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        icon!,
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Text(
                          label,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: textStyle ??
                              TextStyle(
                                color: isEnabled
                                    ? activeFg
                                    : (isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary),
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                letterSpacing: 0.3,
                              ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
