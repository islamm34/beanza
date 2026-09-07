import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/controllers/profile_controller.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/common/app_app_bar.dart';
import '../../../../core/widgets/common/cafe_card.dart';
import '../../../../core/widgets/common/user_avatar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  void _showHelpSupportSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.gold : AppColors.goldLight;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: (isDark ? Colors.white : Colors.black)
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  'help_and_support'.tr,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: goldColor.withValues(alpha: 0.15),
                    child: Icon(Icons.email_outlined, color: goldColor),
                  ),
                  title: Text('email_support'.tr),
                  subtitle: const Text('support@brewora.co'),
                  onTap: () {
                    Navigator.pop(ctx);
                    Get.snackbar(
                      'email_support'.tr,
                      'support@brewora.co',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: goldColor,
                      colorText: AppColors.espressoDark,
                    );
                  },
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: goldColor.withValues(alpha: 0.15),
                    child: Icon(Icons.chat_bubble_outline_rounded,
                        color: goldColor),
                  ),
                  title: Text('live_cafe_concierge'.tr),
                  subtitle: Text('available_hours'.tr),
                  onTap: () {
                    Navigator.pop(ctx);
                    Get.toNamed(Routes.HOSPITALITY_HUB);
                  },
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: goldColor.withValues(alpha: 0.15),
                    child: Icon(Icons.menu_book_rounded, color: goldColor),
                  ),
                  title: Text('faq_ordering_guide'.tr),
                  subtitle: Text('learn_about_tables_rounds'.tr),
                  onTap: () {
                    Navigator.pop(ctx);
                    Get.snackbar(
                      'faq_ordering_guide'.tr,
                      'learn_about_tables_rounds'.tr,
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: goldColor,
                      colorText: AppColors.espressoDark,
                    );
                  },
                ),
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    key: const Key('close_help_support_button'),
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(
                      'close'.tr,
                      style: TextStyle(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          title: Text(
            'logout_confirm_title'.tr,
            style: TextStyle(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'logout_confirm_content'.tr,
            style: TextStyle(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('cancel'.tr),
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
              child: Text('logout_button'.tr),
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
    final goldColor = isDark ? AppColors.gold : AppColors.goldLight;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppAppBar(
        title: 'profile_and_settings'.tr,
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code_rounded, color: goldColor),
            onPressed: () => Get.toNamed(Routes.MY_QR),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 36),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // 1. User Avatar, Name, and Edit Profile Header
              Obx(() {
                final user = profileController.user.value;
                return CafeCard(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      UserAvatar(
                        size: 64,
                        customImagePath: user.profileImage,
                        userName: user.name,
                        onTap: () => Get.toNamed(Routes.EDIT_PROFILE),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Get.toNamed(Routes.EDIT_PROFILE),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                user.email,
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                  fontSize: 12.5,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: goldColor.withValues(
                                      alpha: isDark ? 0.18 : 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'silver_tier_member'.tr,
                                  style: TextStyle(
                                    color: isDark
                                        ? AppColors.goldBright
                                        : goldColor,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        key: const Key('edit_profile_button'),
                        icon: Icon(Icons.edit_outlined,
                            size: 20, color: goldColor),
                        tooltip: 'edit_profile_title'.tr,
                        onPressed: () => Get.toNamed(Routes.EDIT_PROFILE),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 18),

              // 2. Menu Items in Rounded Card
              CafeCard(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  children: [
                    _buildMenuItem(
                      context,
                      icon: Icons.receipt_long_rounded,
                      title: 'order_history_title'.tr,
                      onTap: () => Get.toNamed(Routes.ORDERS),
                      isDark: isDark,
                      goldColor: goldColor,
                    ),
                    _buildDivider(isDark),
                    _buildMenuItem(
                      context,
                      icon: Icons.favorite_rounded,
                      title: 'favorites_title'.tr,
                      onTap: () => Get.toNamed(Routes.FAVORITES),
                      isDark: isDark,
                      goldColor: goldColor,
                    ),
                    _buildDivider(isDark),
                    _buildMenuItem(
                      context,
                      icon: Icons.payment_rounded,
                      title: 'payment_methods_title'.tr,
                      onTap: () => Get.toNamed(Routes.PAYMENT_METHODS),
                      isDark: isDark,
                      goldColor: goldColor,
                    ),
                    _buildDivider(isDark),
                    _buildMenuItem(
                      context,
                      icon: Icons.location_on_rounded,
                      title: 'addresses_title'.tr,
                      onTap: () => Get.toNamed(Routes.ADDRESSES),
                      isDark: isDark,
                      goldColor: goldColor,
                    ),
                    _buildDivider(isDark),
                    _buildMenuItem(
                      context,
                      icon: Icons.notifications_none_rounded,
                      title: 'notifications_title'.tr,
                      onTap: () => Get.toNamed(Routes.NOTIFICATIONS),
                      isDark: isDark,
                      goldColor: goldColor,
                    ),
                    _buildDivider(isDark),
                    _buildMenuItem(
                      context,
                      icon: Icons.settings_rounded,
                      title: 'settings_title'.tr,
                      onTap: () => Get.toNamed(Routes.SETTINGS),
                      isDark: isDark,
                      goldColor: goldColor,
                    ),
                    _buildDivider(isDark),
                    _buildMenuItem(
                      context,
                      itemKey: const Key('help_support_tile'),
                      icon: Icons.help_outline_rounded,
                      title: 'help_and_support'.tr,
                      onTap: () => _showHelpSupportSheet(context),
                      isDark: isDark,
                      goldColor: goldColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 3. Separate Red Log Out Button at Bottom
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () => _showLogoutDialog(context),
                  icon: const Icon(Icons.logout_rounded,
                      color: AppColors.error, size: 20),
                  label: Text(
                    'logout_button'.tr,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.5,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: AppColors.error.withValues(alpha: 0.5),
                      width: 1.2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    Key? itemKey,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isDark,
    required Color goldColor,
  }) {
    return ListTile(
      key: itemKey,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: goldColor.withValues(alpha: isDark ? 0.18 : 0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: goldColor, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          color:
              isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 14,
        color:
            isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
      indent: 56,
      endIndent: 16,
    );
  }
}
