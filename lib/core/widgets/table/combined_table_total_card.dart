import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class CombinedTableTotalCard extends StatelessWidget {
  final double totalAmount;

  const CombinedTableTotalCard({
    Key? key,
    required this.totalAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF181816) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? const Color(0xFF3A2B18)
              : AppColors.caramel.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Combined Table Total',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textLight : AppColors.textDark,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'إجمالي الطاولة المشترك',
                style: TextStyle(
                  fontSize: 11,
                  color:
                      isDark ? AppColors.textLightMuted : AppColors.textMuted,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                totalAmount.toStringAsFixed(0),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.caramel,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'EGP',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color:
                      isDark ? AppColors.textLightMuted : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
