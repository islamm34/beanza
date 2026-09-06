import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glassy/glassy_card.dart';
import 'package:glassy/glassy_config.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/common/app_app_bar.dart';

class AddressItem {
  final String id;
  final String label; // Home, Work, Gym, Custom
  final String address;
  final bool isDefault;

  const AddressItem({
    required this.id,
    required this.label,
    required this.address,
    this.isDefault = false,
  });
}

class AddressesPage extends StatefulWidget {
  const AddressesPage({Key? key}) : super(key: key);

  @override
  State<AddressesPage> createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  List<AddressItem> _addresses = [
    const AddressItem(
      id: 'addr_1',
      label: 'Home',
      address: '123 5th Avenue, Apt 4B, New York, NY 10001',
      isDefault: true,
    ),
    const AddressItem(
      id: 'addr_2',
      label: 'Work',
      address: '742 Evergreen Terrace, Suite 200, New York, NY 10002',
      isDefault: false,
    ),
  ];

  void _showAddAddressDialog() {
    final labelCtrl = TextEditingController(text: 'Home');
    final addressCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Add New Address'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: labelCtrl,
                decoration: InputDecoration(
                  labelText: 'Label (e.g. Home, Work)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addressCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Full Delivery Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (addressCtrl.text.trim().isEmpty) return;
                setState(() {
                  _addresses.add(
                    AddressItem(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      label: labelCtrl.text.trim(),
                      address: addressCtrl.text.trim(),
                      isDefault: _addresses.isEmpty,
                    ),
                  );
                });
                Navigator.pop(context);
                Get.snackbar(
                  'Address Added 📍',
                  'New delivery address saved.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.espressoDark,
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(16),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.espressoDark,
              ),
              child: const Text('Save Address'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const AppAppBar(
        title: 'Saved Addresses',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Delivery Locations',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Manage addresses for quick coffee delivery checkout',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.getTextMutedColor(
                        Theme.of(context).brightness,
                      ),
                    ),
              ),
              const SizedBox(height: 20),
              ..._addresses.map((item) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: GlassyCard(
                    config: GlassyConfig(
                      radius: 18,
                      backgroundColor:
                          isDark ? AppColors.darkCardBg : Colors.white,
                      backgroundOpacity: isDark ? 0.65 : 0.75,
                      borderColor: item.isDefault
                          ? AppColors.caramel
                          : (isDark ? Colors.white : AppColors.espressoDark),
                      borderOpacity:
                          item.isDefault ? 0.80 : (isDark ? 0.15 : 0.10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.caramel.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              item.label.toLowerCase() == 'home'
                                  ? Icons.home_rounded
                                  : Icons.work_rounded,
                              color: AppColors.caramel,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      item.label,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (item.isDefault) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.caramel,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: const Text(
                                          'DEFAULT',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.espressoDark,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.address,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.getTextMutedColor(
                                      Theme.of(context).brightness,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton<String>(
                            onSelected: (val) {
                              if (val == 'default') {
                                setState(() {
                                  _addresses = _addresses.map((a) {
                                    return AddressItem(
                                      id: a.id,
                                      label: a.label,
                                      address: a.address,
                                      isDefault: a.id == item.id,
                                    );
                                  }).toList();
                                });
                              } else if (val == 'delete') {
                                setState(() {
                                  _addresses
                                      .removeWhere((a) => a.id == item.id);
                                });
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'default',
                                child: Text('Set as Default'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete Address'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: _showAddAddressDialog,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side:
                        const BorderSide(color: AppColors.caramel, width: 1.5),
                  ),
                  icon: const Icon(Icons.add_location_alt_rounded,
                      color: AppColors.caramel),
                  label: const Text(
                    'Add New Address',
                    style: TextStyle(
                      color: AppColors.caramel,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
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
}
