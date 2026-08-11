import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  String _selectedLanguage = 'English (US)';

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Choose Theme Mode'),
          children: [
            SimpleDialogOption(
              onPressed: () {
                setState(() => _selectedTheme = ThemeMode.system);
                Get.changeThemeMode(ThemeMode.system);
                Navigator.pop(context);
              },
              child: const Row(
                children: [
                  Icon(Icons.brightness_auto_rounded, color: AppColors.caramel),
                  SizedBox(width: 12),
                  Text('System Default'),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                setState(() => _selectedTheme = ThemeMode.light);
                Get.changeThemeMode(ThemeMode.light);
                Navigator.pop(context);
              },
              child: const Row(
                children: [
                  Icon(Icons.light_mode_rounded, color: AppColors.caramel),
                  SizedBox(width: 12),
                  Text('Light Mode'),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                setState(() => _selectedTheme = ThemeMode.dark);
                Get.changeThemeMode(ThemeMode.dark);
                Navigator.pop(context);
              },
              child: const Row(
                children: [
                  Icon(Icons.dark_mode_rounded, color: AppColors.caramel),
                  SizedBox(width: 12),
                  Text('Dark Mode'),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Select Language'),
          children: [
            SimpleDialogOption(
              onPressed: () {
                setState(() => _selectedLanguage = 'English (US)');
                Get.updateLocale(const Locale('en', 'US'));
                Navigator.pop(context);
              },
              child: const Text('English (US)'),
            ),
            SimpleDialogOption(
              onPressed: () {
                setState(() => _selectedLanguage = 'العربية (Arabic)');
                Get.updateLocale(const Locale('ar', 'SA'));
                Navigator.pop(context);
              },
              child: const Text('العربية (Arabic)'),
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
    return Scaffold(
      appBar: const AppAppBar(
        title: 'App Settings',
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          children: [
            _buildSectionTitle(context, 'Notifications'),
            _buildSwitchTile(
              'Push Notifications',
              'Receive order updates and coffee deals',
              _pushNotifications,
              (value) => setState(() => _pushNotifications = value),
            ),
            _buildSwitchTile(
              'Email Receipts & Offers',
              'Get digital receipts and rewards in email',
              _emailNotifications,
              (value) => setState(() => _emailNotifications = value),
            ),
            const Divider(height: 24),

            _buildSectionTitle(context, 'Preferences'),
            ListTile(
              leading: const Icon(Icons.brightness_auto_outlined, color: AppColors.caramel),
              title: const Text('App Theme Mode', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(_getThemeName()),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: _showThemeDialog,
            ),
            ListTile(
              leading: const Icon(Icons.language_rounded, color: AppColors.caramel),
              title: const Text('App Language', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(_selectedLanguage),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: _showLanguageDialog,
            ),
            _buildSwitchTile(
              'Location Services',
              'Enable store locator & nearby cafe suggestions',
              _locationServices,
              (value) => setState(() => _locationServices = value),
            ),
            const Divider(height: 24),

            _buildSectionTitle(context, 'About & Support'),
            _buildSettingsTile(
              Icons.info_outline_rounded,
              'About Brewora',
              'Version 1.0.0 (Build 102)',
              () {
                Get.snackbar(
                  'Brewora v1.0.0 ☕',
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
              'Privacy Policy',
              'Read how we handle your data',
              () {
                Get.snackbar(
                  'Privacy Policy 🔒',
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
              'Terms & Conditions',
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
                  label: const Text(
                    'Logout Account',
                    style: TextStyle(fontWeight: FontWeight.bold),
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
        return 'System Default';
      case ThemeMode.light:
        return 'Light Mode';
      case ThemeMode.dark:
        return 'Dark Mode';
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
