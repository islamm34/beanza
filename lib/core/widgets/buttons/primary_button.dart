import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_spacing.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final double? width;
  final double height;
  final TextStyle? textStyle;
  final Widget? icon;
  final bool isEnabled;

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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled && !isLoading ? onPressed : null,
          borderRadius: AppRadius.buttonRadius,
          child: Container(
            decoration: BoxDecoration(
              color: isEnabled ? AppColors.espressoDark : Colors.grey,
              borderRadius: AppRadius.buttonRadius,
              boxShadow: AppShadows.shadowMd,
            ),
            child: isLoading
                ? const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(AppColors.cream),
                        strokeWidth: 2,
                      ),
                    ),
                  )
                : Row(
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
                                  color: AppColors.cream,
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
