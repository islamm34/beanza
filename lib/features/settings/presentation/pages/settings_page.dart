import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const AppAppBar(
        title: 'Settings',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSectionTitle(context, 'Notifications'),
            _buildSwitchTile(
              'Push Notifications',
              _pushNotifications,
              (value) => setState(() => _pushNotifications = value),
            ),
            _buildSwitchTile(
              'Email Notifications',
              _emailNotifications,
              (value) => setState(() => _emailNotifications = value),
            ),
            const Divider(),
            _buildSectionTitle(context, 'Preferences'),
            ListTile(
              leading: const Icon(Icons.brightness_auto_outlined),
              title: const Text('Appearance'),
              subtitle: Text(
                'System Default (${isDark ? 'Dark' : 'Light'} Mode)',
              ),
              trailing: const Icon(Icons.check, size: 20),
            ),
            _buildSwitchTile(
              'Location Services',
              _locationServices,
              (value) => setState(() => _locationServices = value),
            ),
            const Divider(),
            _buildSectionTitle(context, 'More'),
            _buildSettingsTile(
              Icons.info_outline,
              'About',
              'Version 1.0.0',
              () {},
            ),
            _buildSettingsTile(
              Icons.privacy_tip_outlined,
              'Privacy Policy',
              'Read our policies',
              () {},
            ),
            _buildSettingsTile(
              Icons.description_outlined,
              'Terms & Conditions',
              'Read our terms',
              () {},
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onError,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title),
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
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
