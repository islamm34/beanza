import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Widget? action;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? iconColor;
  final double iconSize;

  const EmptyState({
    Key? key,
    required this.icon,
    required this.title,
    String? description,
    String? message,
    this.action,
    this.actionLabel,
    this.onAction,
    this.iconColor,
    this.iconSize = 80,
  })  : description = description ?? message ?? '',
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget? effectiveAction = action;
    if (effectiveAction == null && actionLabel != null && onAction != null) {
      effectiveAction = ElevatedButton(
        onPressed: onAction,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.espressoDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          actionLabel!,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: iconSize, color: iconColor ?? AppColors.caramel),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (this.description.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                this.description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.getTextMutedColor(
                        Theme.of(context).brightness,
                      ),
                    ),
              ),
            ],
            if (effectiveAction != null) ...[
              const SizedBox(height: AppSpacing.lg),
              effectiveAction,
            ],
          ],
        ),
      ),
    );
  }
}
