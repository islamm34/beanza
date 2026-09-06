import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';

enum TableFlowStep { qrScan, menu, cartAndSplit, managerView }

class TableFlowNavigation extends StatelessWidget {
  final TableFlowStep currentStep;

  const TableFlowNavigation({
    Key? key,
    this.currentStep = TableFlowStep.cartAndSplit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF141210)
            : AppColors.softSand.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? const Color(0xFF3A2B18)
              : AppColors.caramel.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          _buildNavItem(
            context,
            step: TableFlowStep.qrScan,
            icon: Icons.qr_code_scanner_rounded,
            title: 'QR Scan',
            arabicTitle: 'مسح QR',
            onTap: () => Get.toNamed(Routes.SCANNER),
          ),
          _buildNavItem(
            context,
            step: TableFlowStep.menu,
            icon: Icons.restaurant_menu_rounded,
            title: 'Menu',
            arabicTitle: 'القائمة',
            onTap: () => Get.offAllNamed(Routes.HOME),
          ),
          _buildNavItem(
            context,
            step: TableFlowStep.cartAndSplit,
            icon: Icons.shopping_cart_rounded,
            title: 'Cart & Split',
            arabicTitle: 'السلة',
            onTap: () {},
          ),
          _buildNavItem(
            context,
            step: TableFlowStep.managerView,
            icon: Icons.admin_panel_settings_rounded,
            title: 'Manager',
            arabicTitle: 'المدير',
            onTap: () {
              Get.snackbar(
                'Manager View',
                'Manager View is restricted to café staff.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppColors.espressoDark,
                colorText: Colors.white,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required TableFlowStep step,
    required IconData icon,
    required String title,
    required String arabicTitle,
    required VoidCallback onTap,
  }) {
    final isSelected = step == currentStep;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.caramel : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isSelected
                      ? AppColors.espressoDark
                      : (isDark
                          ? AppColors.textLightMuted
                          : AppColors.textMuted),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected
                        ? AppColors.espressoDark
                        : (isDark ? AppColors.textLight : AppColors.textDark),
                  ),
                ),
                Text(
                  arabicTitle,
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? AppColors.espressoDark.withValues(alpha: 0.8)
                        : (isDark
                            ? AppColors.textLightMuted
                            : AppColors.textMuted),
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
