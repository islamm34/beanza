import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/controllers/wallet_controller.dart';
import '../../../../app/theme/app_colors.dart';

import '../../../../core/widgets/common/app_app_bar.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final walletController = Get.find<WalletController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppAppBar(
        title: 'wallet_title'.tr,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wallet Card Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [AppColors.espressoDark, Color(0xFF4A2E20)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.espressoDark.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'digital_card_label'.tr,
                        style: const TextStyle(
                          color: AppColors.caramel,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const Icon(Icons.wifi_rounded, color: Colors.white54),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => Text(
                      '${walletController.balance.value.toStringAsFixed(2)} ${'egp'.tr}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '**** **** **** 8842',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          letterSpacing: 2,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => walletController.topUp(20.00),
                        icon: const Icon(Icons.add_rounded,
                            size: 16, color: AppColors.espressoDark),
                        label: Text(
                          'top_up_btn'.tr,
                          style: const TextStyle(
                            color: AppColors.espressoDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.caramel,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Recent Transactions Section Title
            Text(
              'recent_transactions_title'.tr,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // Transactions List
            Obx(
              () => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: walletController.transactions.length,
                itemBuilder: (context, index) {
                  final tx = walletController.transactions[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color:
                          isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkSecondaryBg
                            : AppColors.softSand,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: tx.isTopUp
                                ? AppColors.success.withOpacity(0.15)
                                : AppColors.caramel.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            tx.isTopUp
                                ? Icons.arrow_downward_rounded
                                : Icons.local_cafe_rounded,
                            color: tx.isTopUp
                                ? AppColors.success
                                : AppColors.caramel,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tx.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${tx.date.hour}:${tx.date.minute.toString().padLeft(2, '0')}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColors.getTextMutedColor(
                                          Theme.of(context).brightness),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${tx.isTopUp ? '+' : ''}${tx.amount.abs().toStringAsFixed(2)} ${'egp'.tr}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: tx.isTopUp
                                ? AppColors.success
                                : AppColors.getTextColor(
                                    Theme.of(context).brightness),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
