import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_spacing.dart';

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double? width;
  final double height;
  final TextStyle? textStyle;
  final Widget? icon;
  final bool isEnabled;
  final Color? borderColor;
  final Color? backgroundColor;

  const SecondaryButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.width,
    this.height = 52,
    this.textStyle,
    this.icon,
    this.isEnabled = true,
    this.borderColor,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = borderColor ?? AppColors.coffeeBrown;
    final bgColor = backgroundColor ?? 
        (isDark ? AppColors.darkCardBg : AppColors.lightBg);

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: AppRadius.buttonRadius,
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: AppRadius.buttonRadius,
              border: Border.all(
                color: isEnabled ? border : Colors.grey,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  icon!,
                  const SizedBox(width: AppSpacing.sm),
                ],
                Text(
                  label,
                  style: textStyle ??
                      Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: isEnabled ? border : Colors.grey,
                            fontWeight: FontWeight.w600,
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
