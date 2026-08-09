import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_spacing.dart';
class OrderCard extends StatelessWidget {
  final String orderId;
  final String cafeName;
  final double totalAmount;
  final String status;
  final DateTime orderDate;
  final int itemCount;
  final VoidCallback onTap;
  final VoidCallback? onReorderPressed;

  const OrderCard({
    Key? key,
    required this.orderId,
    required this.cafeName,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
    required this.itemCount,
    required this.onTap,
    this.onReorderPressed,
  }) : super(key: key);

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'completed':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'cancelled':
        return AppColors.error;
      case 'preparing':
        return AppColors.info;
      default:
        return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.darkCardBg : AppColors.lightCardBg;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.base),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: AppRadius.cardRadius,
          boxShadow: AppShadows.shadowSm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #$orderId',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      cafeName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.getTextMutedColor(
                              Theme.of(context).brightness,
                            ),
                          ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.base,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.1),
                    borderRadius: AppRadius.smallRadius,
                  ),
                  child: Text(
                    status,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getStatusColor(),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.base),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$itemCount item${itemCount != 1 ? 's' : ''}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.getTextMutedColor(
                          Theme.of(context).brightness,
                        ),
                      ),
                ),
                Text(
                  '\$${totalAmount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.coffeeBrown,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.base),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(orderDate),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.getTextMutedColor(
                          Theme.of(context).brightness,
                        ),
                      ),
                ),
                if (onReorderPressed != null)
                  GestureDetector(
                    onTap: onReorderPressed,
                    child: Text(
                      'Reorder',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.espressoDark,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }
}
