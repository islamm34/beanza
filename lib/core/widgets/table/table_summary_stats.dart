import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class TableSummaryStats extends StatelessWidget {
  final int guestCount;
  final int itemCount;
  final double totalAmount;

  const TableSummaryStats({
    Key? key,
    required this.guestCount,
    required this.itemCount,
    required this.totalAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              context,
              value: '$guestCount',
              valueColor: AppColors.caramel,
              title: 'Guests',
              arabicTitle: 'الضيوف',
              isDark: isDark,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatCard(
              context,
              value: '$itemCount',
              valueColor: isDark ? Colors.white : AppColors.textDark,
              title: 'Items',
              arabicTitle: 'منتجات',
              isDark: isDark,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatCard(
              context,
              value: '${totalAmount.toStringAsFixed(0)} EGP',
              valueColor: const Color(0xFF00D98B),
              title: 'Total',
              arabicTitle: 'الإجمالي',
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String value,
    required Color valueColor,
    required String title,
    required String arabicTitle,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF181816) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? const Color(0xFF3A2B18)
              : AppColors.caramel.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textLight : AppColors.textDark,
            ),
          ),
          Text(
            arabicTitle,
            style: TextStyle(
              fontSize: 9,
              color: isDark ? AppColors.textLightMuted : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
