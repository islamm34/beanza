import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/controllers/profile_controller.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/common/app_app_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Logout from Brewora?'),
          content: const Text(
            'Are you sure you want to log out of your coffee account?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Get.offAllNamed(Routes.AUTH);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppAppBar(
        title: 'My Profile',
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Get.toNamed(Routes.SETTINGS),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // User Header Profile Card
            Obx(() {
              final user = profileController.user.value;
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkSecondaryBg
                        : AppColors.softSand,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.caramel.withValues(alpha: 0.2),
                        border: Border.all(
                          color: AppColors.caramel,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 36,
                        color: AppColors.caramel,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user.email,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: AppColors.getTextMutedColor(
                                      Theme.of(context).brightness),
                                ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.caramel.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              '☕ Brewora Gold Member',
                              style: TextStyle(
                                color: AppColors.caramel,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),

            // Profile Menu Links
            _buildProfileTile(
              context,
              icon: Icons.favorite_border_rounded,
              title: 'Favorite Coffee',
              subtitle: 'Manage your saved coffee items',
              onTap: () => Get.toNamed(Routes.FAVORITES),
            ),
            _buildProfileTile(
              context,
              icon: Icons.receipt_long_rounded,
              title: 'Order History',
              subtitle: 'View active and past orders',
              onTap: () => Get.toNamed(Routes.ORDERS),
            ),
            _buildProfileTile(
              context,
              icon: Icons.location_on_outlined,
              title: 'Delivery Addresses',
              subtitle: 'Manage saved delivery locations',
              onTap: () => Get.toNamed(Routes.ADDRESSES),
            ),
            _buildProfileTile(
              context,
              icon: Icons.payment_rounded,
              title: 'Payment Methods',
              subtitle: 'Manage saved credit cards & options',
              onTap: () => Get.toNamed(Routes.PAYMENT_METHODS),
            ),
            _buildProfileTile(
              context,
              icon: Icons.account_balance_wallet_rounded,
              title: 'Brewora Wallet',
              subtitle: 'Check balance & transactions',
              onTap: () => Get.toNamed(Routes.WALLET),
            ),
            _buildProfileTile(
              context,
              icon: Icons.stars_rounded,
              title: 'Rewards & Points',
              subtitle: '350 Loyalty Points available',
              onTap: () => Get.toNamed(Routes.REWARDS),
            ),
            _buildProfileTile(
              context,
              icon: Icons.qr_code_scanner_rounded,
              title: 'Scan History',
              subtitle: 'View saved coffee QR code scans',
              onTap: () => Get.toNamed(Routes.SCAN_HISTORY),
            ),
            _buildProfileTile(
              context,
              icon: Icons.settings_outlined,
              title: 'Settings & Appearance',
              subtitle: 'App preferences and system theme',
              onTap: () => Get.toNamed(Routes.SETTINGS),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () => _showLogoutDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error.withValues(alpha: 0.10),
                  foregroundColor: AppColors.error,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.logout_rounded, size: 18),
                label: const Text(
                  'Logout Account',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkSecondaryBg : AppColors.softSand,
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.caramel.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.caramel, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.getTextMutedColor(Theme.of(context).brightness),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: onTap,
      ),
    );
  }
}
