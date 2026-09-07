import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:glassy/glassy_card.dart';
import 'package:glassy/glassy_config.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../app/controllers/profile_controller.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/common/app_app_bar.dart';

class MyQrPage extends StatelessWidget {
  const MyQrPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const qrData = 'BREWORA-LOYALTY-PASS-USER-89412';

    return Scaffold(
      appBar: AppAppBar(
        title: 'loyalty_pass_title'.tr,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              // User Loyalty Header Card
              GlassyCard(
                config: GlassyConfig(
                  radius: 24,
                  backgroundColor: isDark ? AppColors.darkCardBg : Colors.white,
                  backgroundOpacity: isDark ? 0.65 : 0.75,
                  borderColor: isDark ? Colors.white : AppColors.espressoDark,
                  borderOpacity: isDark ? 0.15 : 0.10,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.caramel.withValues(alpha: 0.20),
                              border: Border.all(
                                  color: AppColors.caramel, width: 2),
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              color: AppColors.caramel,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(
                                  () => Text(
                                    profileController.user.value.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Obx(
                                  () => Text(
                                    'reward_points_available'.trParams({
                                      'points':
                                          '${profileController.user.value.rewardPoints}'
                                    }),
                                    style: const TextStyle(
                                      color: AppColors.caramel,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32, thickness: 1),

                      // QR Code Presentation
                      Text(
                        'scan_pass_instruction'.tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 13, color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 20),

                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: QrImageView(
                          data: qrData,
                          version: QrVersions.auto,
                          size: 200.0,
                          eyeStyle: const QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: AppColors.espressoDark,
                          ),
                          dataModuleStyle: const QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.square,
                            color: AppColors.espressoDark,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // User Code ID
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.10)
                              : AppColors.lightSecondaryBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'ID: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textMuted,
                              ),
                            ),
                            const Text(
                              'CAFF-89412-PASS',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(
                                  const ClipboardData(text: 'CAFF-89412-PASS'),
                                );
                                Get.snackbar(
                                  'copied'.tr,
                                  'pass_id_copied'.tr,
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: AppColors.espressoDark,
                                  colorText: Colors.white,
                                  margin: const EdgeInsets.all(16),
                                  duration: const Duration(seconds: 2),
                                );
                              },
                              child: const Icon(
                                Icons.copy_rounded,
                                size: 16,
                                color: AppColors.caramel,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Quick Actions Row
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Get.snackbar(
                          'loyalty_pass_title'.tr,
                          'scan_pass_instruction'.tr,
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.caramel,
                          colorText: AppColors.espressoDark,
                          margin: const EdgeInsets.all(16),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.share_rounded, size: 18),
                      label: Text('share_pass'.tr),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Get.snackbar(
                          'refresh_token'.tr,
                          'pass_id_copied'.tr,
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppColors.espressoDark,
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(16),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.espressoDark,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: Text('refresh_token'.tr),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
