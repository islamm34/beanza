import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/common/app_app_bar.dart';
import '../../../../core/widgets/common/cafe_card.dart';

class CafeDashboardPage extends StatefulWidget {
  const CafeDashboardPage({Key? key}) : super(key: key);

  @override
  State<CafeDashboardPage> createState() => _CafeDashboardPageState();
}

class _CafeDashboardPageState extends State<CafeDashboardPage> {
  int _navIndex = 0;

  final List<Map<String, dynamic>> _liveOrders = [
    {
      'table': 'Table 12',
      'round': 'Round 1',
      'time': '4 mins ago',
      'status': 'Preparing',
      'isGold': true,
      'items': '2x Cappuccino, 1x V60'
    },
    {
      'table': 'Table 08',
      'round': 'Round 2',
      'time': '8 mins ago',
      'status': 'Ready',
      'isGreen': true,
      'items': '1x Flat White, 1x Croissant'
    },
    {
      'table': 'Table 04',
      'round': 'Round 1',
      'time': '12 mins ago',
      'status': 'Ready',
      'isGreen': true,
      'items': '2x Iced Latte, 1x Cheesecake'
    },
    {
      'table': 'Table 15',
      'round': 'Round 3',
      'time': '25 mins ago',
      'status': 'Completed',
      'isNeutral': true,
      'items': '3x Americano'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.gold : AppColors.goldLight;
    final greenColor =
        isDark ? AppColors.primaryGreen : AppColors.primaryGreenLight;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppAppBar(
        title: 'Café Live Dashboard • لوحة التحكم',
        showCartAction: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Context Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Brewora Artisan Branch 1',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      Text(
                        'Live Shift Status • 8 Active Tables',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: greenColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: greenColor.withValues(alpha: 0.5)),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.circle,
                            color: AppColors.brightGreen, size: 8),
                        SizedBox(width: 6),
                        Text('LIVE',
                            style: TextStyle(
                                color: AppColors.brightGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // 2. Three Summary Cards: Preparing (Gold), Ready (Green), Completed Today (Neutral)
              Row(
                children: [
                  // Preparing Card
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 12),
                      decoration: BoxDecoration(
                        color:
                            goldColor.withValues(alpha: isDark ? 0.18 : 0.12),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: goldColor.withValues(alpha: 0.5),
                            width: 1.2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Preparing',
                              style: TextStyle(
                                  color: goldColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.5)),
                          const SizedBox(height: 4),
                          Text('4 Orders',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Ready Card
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 12),
                      decoration: BoxDecoration(
                        color:
                            greenColor.withValues(alpha: isDark ? 0.18 : 0.12),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: greenColor.withValues(alpha: 0.5),
                            width: 1.2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ready',
                              style: TextStyle(
                                  color: greenColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.5)),
                          const SizedBox(height: 4),
                          Text('3 Orders',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Completed Card
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkCardElevated
                            : AppColors.lightSecondaryBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder,
                            width: 1.2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Completed Today',
                              style: TextStyle(
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10)),
                          const SizedBox(height: 4),
                          Text('48 Orders',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 3. Live Orders Section
              Text(
                'Live Table Orders Queue / طابور الطلبات',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 12),

              ..._liveOrders.map((ord) {
                final isG = ord['isGreen'] == true;
                final isGold = ord['isGold'] == true;

                return CafeCard(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                ord['table'] as String,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '• ${ord['round']}',
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          CafeBadge(
                            text: ord['status'] as String,
                            isGreen: isG,
                            isGold: isGold,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        ord['items'] as String,
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ord['time'] as String,
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),

      // 4. Dashboard Bottom Navigation Bar
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDashNavItem(
                  0, Icons.dashboard_rounded, 'Dashboard', greenColor, isDark),
              _buildDashNavItem(
                  1, Icons.receipt_long_rounded, 'Orders', greenColor, isDark),
              _buildDashNavItem(
                  2, Icons.restaurant_menu_rounded, 'Menu', greenColor, isDark),
              _buildDashNavItem(
                  3, Icons.analytics_outlined, 'Analytics', greenColor, isDark),
              _buildDashNavItem(
                  4, Icons.more_horiz_rounded, 'More', greenColor, isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashNavItem(
      int index, IconData icon, String label, Color activeColor, bool isDark) {
    final isSelected = _navIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _navIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? Colors.white
                  : (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
