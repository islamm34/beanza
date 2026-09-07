import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/controllers/rewards_controller.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/common/app_app_bar.dart';
import '../../../../core/widgets/common/cafe_card.dart';

class RewardsPage extends StatelessWidget {
  const RewardsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rewardsController = Get.find<RewardsController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.gold : AppColors.goldLight;
    final greenColor =
        isDark ? AppColors.primaryGreen : AppColors.primaryGreenLight;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppAppBar(
        title: 'rewards_title'.tr,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Premium Gold Highlighted Card at Top
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF2C1F10), const Color(0xFF16120C)]
                        : [const Color(0xFFFFF7E8), const Color(0xFFF3E7D3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: goldColor.withValues(alpha: isDark ? 0.6 : 0.4),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: goldColor.withValues(alpha: isDark ? 0.22 : 0.12),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'silver_member_badge'.tr,
                              style: TextStyle(
                                color: goldColor,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Obx(
                              () => Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    '${rewardsController.points.value}',
                                    style: TextStyle(
                                      color: isDark
                                          ? AppColors.darkTextPrimary
                                          : AppColors.lightTextPrimary,
                                      fontSize: 34,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'beans_unit'.tr,
                                    style: TextStyle(
                                      color: goldColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: goldColor.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.workspace_premium_rounded,
                              color: goldColor, size: 36),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Progress Bar to Gold Tier
                    Obx(() {
                      final current = rewardsController.points.value;
                      final target = 500;
                      final progress = (current % target) / target.toDouble();
                      final remaining = target - (current % target);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 9,
                              backgroundColor:
                                  isDark ? Colors.white12 : Colors.black12,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(goldColor),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'next_tier_label'.tr,
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                  fontSize: 11.5,
                                ),
                              ),
                              Text(
                                'beans_to_level_up'
                                    .trParams({'count': '$remaining'}),
                                style: TextStyle(
                                  color: goldColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.5,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 2. Redeemable Rewards (Horizontal Row of Small Cards)
              Text(
                'available_rewards_title'.tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 140,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildRewardCard(
                      title: 'reward_free_espresso'.tr,
                      points: 150,
                      icon: Icons.coffee_rounded,
                      isDark: isDark,
                      goldColor: goldColor,
                      greenColor: greenColor,
                    ),
                    _buildRewardCard(
                      title: 'reward_croissant'.tr,
                      points: 200,
                      icon: Icons.bakery_dining_rounded,
                      isDark: isDark,
                      goldColor: goldColor,
                      greenColor: greenColor,
                    ),
                    _buildRewardCard(
                      title: 'reward_free_latte'.tr,
                      points: 300,
                      icon: Icons.local_cafe_rounded,
                      isDark: isDark,
                      goldColor: goldColor,
                      greenColor: greenColor,
                    ),
                    _buildRewardCard(
                      title: 'reward_cheesecake'.tr,
                      points: 450,
                      icon: Icons.cake_rounded,
                      isDark: isDark,
                      goldColor: goldColor,
                      greenColor: greenColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 3. Achievements Section
              Text(
                'achievements_title'.tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ...[
                {
                  'title': 'ach_connoisseur_title'.tr,
                  'subtitle': 'ach_connoisseur_desc'.tr,
                  'badge': 'gold_tier_badge'.tr,
                  'icon': Icons.emoji_events_rounded,
                },
                {
                  'title': 'ach_table_host_title'.tr,
                  'subtitle': 'ach_table_host_desc'.tr,
                  'badge': 'badge_unlocked'.tr,
                  'icon': Icons.groups_rounded,
                },
                {
                  'title': 'ach_early_bird_title'.tr,
                  'subtitle': 'ach_early_bird_desc'.tr,
                  'badge': 'badge_completed'.tr,
                  'icon': Icons.wb_sunny_rounded,
                },
              ].map((ach) {
                return CafeCard(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color:
                              goldColor.withValues(alpha: isDark ? 0.20 : 0.14),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(ach['icon'] as IconData,
                            color: goldColor, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ach['title'] as String,
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightTextPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              ach['subtitle'] as String,
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CafeBadge(
                        text: ach['badge'] as String,
                        isGold: true,
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRewardCard({
    required String title,
    required int points,
    required IconData icon,
    required bool isDark,
    required Color goldColor,
    required Color greenColor,
  }) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: goldColor.withValues(alpha: isDark ? 0.2 : 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: goldColor, size: 20),
          ),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$points ${'pts_unit'.tr}',
                  style: TextStyle(
                    color: goldColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: greenColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('redeem_btn'.tr,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
