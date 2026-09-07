import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/controllers/language_controller.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/common/app_app_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _locationServices = true;
  ThemeMode _selectedTheme = ThemeMode.system;

  LanguageController get _languageController => Get.find<LanguageController>();

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('choose_theme_mode'.tr),
          children: [
            SimpleDialogOption(
              onPressed: () {
                setState(() => _selectedTheme = ThemeMode.system);
                Get.changeThemeMode(ThemeMode.system);
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  const Icon(Icons.brightness_auto_rounded, color: AppColors.caramel),
                  const SizedBox(width: 12),
                  Text('theme_system'.tr),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                setState(() => _selectedTheme = ThemeMode.light);
                Get.changeThemeMode(ThemeMode.light);
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  const Icon(Icons.light_mode_rounded, color: AppColors.caramel),
                  const SizedBox(width: 12),
                  Text('theme_light'.tr),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                setState(() => _selectedTheme = ThemeMode.dark);
                Get.changeThemeMode(ThemeMode.dark);
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  const Icon(Icons.dark_mode_rounded, color: AppColors.caramel),
                  const SizedBox(width: 12),
                  Text('theme_dark'.tr),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('select_language_title'.tr),
          children: [
            SimpleDialogOption(
              onPressed: () {
                _languageController.changeLanguage('en');
                Navigator.pop(context);
              },
              child: Text('english_language'.tr),
            ),
            SimpleDialogOption(
              onPressed: () {
                _languageController.changeLanguage('ar');
                Navigator.pop(context);
              },
              child: Text('arabic_language'.tr),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('logout_confirm_title'.tr),
          content: Text('logout_confirm_content'.tr),
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
    return Scaffold(
      appBar: AppAppBar(
        title: 'settings_title'.tr,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          children: [
            _buildSectionTitle(context, 'notifications_title'.tr),
            _buildSwitchTile(
              'push_notifications'.tr,
              'Receive order updates and coffee deals',
              _pushNotifications,
              (value) => setState(() => _pushNotifications = value),
            ),
            _buildSwitchTile(
              'email_notifications'.tr,
              'Get digital receipts and rewards in email',
              _emailNotifications,
              (value) => setState(() => _emailNotifications = value),
            ),
            const Divider(height: 24),
            _buildSectionTitle(context, 'settings_title'.tr),
            ListTile(
              leading: const Icon(Icons.brightness_auto_outlined,
                  color: AppColors.caramel),
              title: Text('theme_mode_title'.tr,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(_getThemeName()),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: _showThemeDialog,
            ),
            Obx(() => ListTile(
              leading:
                  const Icon(Icons.language_rounded, color: AppColors.caramel),
              title: Text('language_title'.tr,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(_languageController.isArabic
                  ? 'arabic_language'.tr
                  : 'english_language'.tr),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: _showLanguageDialog,
            )),
            _buildSwitchTile(
              'location_services'.tr,
              'Enable store locator & nearby cafe suggestions',
              _locationServices,
              (value) => setState(() => _locationServices = value),
            ),
            const Divider(height: 24),
            _buildSectionTitle(context, 'help_and_support'.tr),
            _buildSettingsTile(
              Icons.info_outline_rounded,
              'about_app'.tr,
              'Version 1.0.0 (Build 102)',
              () {
                Get.snackbar(
                  'about_app'.tr,
                  'Artisan Coffee Platform built with Flutter & Glassmorphism.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.espressoDark,
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(16),
                );
              },
            ),
            _buildSettingsTile(
              Icons.privacy_tip_outlined,
              'privacy_policy'.tr,
              'Read how we handle your data',
              () {
                Get.snackbar(
                  'privacy_policy'.tr,
                  'Your personal data is encrypted and safe with Brewora.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.espressoDark,
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(16),
                );
              },
            ),
            _buildSettingsTile(
              Icons.description_outlined,
              'terms_of_service'.tr,
              'Read user terms of service',
              () {},
            ),
            const Divider(height: 24),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _showLogoutDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error.withValues(alpha: 0.10),
                    foregroundColor: AppColors.error,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  label: Text(
                    'logout_button'.tr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getThemeName() {
    switch (_selectedTheme) {
      case ThemeMode.system:
        return 'theme_system'.tr;
      case ThemeMode.light:
        return 'theme_light'.tr;
      case ThemeMode.dark:
        return 'theme_dark'.tr;
    }
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.caramel,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      activeColor: AppColors.caramel,
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildSettingsTile(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppColors.caramel),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      onTap: onTap,
    );
  }
}
