import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/controllers/table_session_controller.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/common/empty_state.dart';
import '../../../../core/widgets/table/combined_table_total_card.dart';
import '../../../../core/widgets/table/participant_order_card.dart';
import '../../../../core/widgets/table/send_table_order_button.dart';
import '../../../../core/widgets/table/split_bill_toggle_card.dart';
import '../../../../core/widgets/table/table_summary_stats.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final isSplitBillView = false.obs;

  static const List<Color> _companionAccentColors = [
    Color(0xFFE8A20C), // Amber/Orange
    Color(0xFF9C27B0), // Purple
    Color(0xFF00BCD4), // Teal
    Color(0xFFFF5722), // Deep Orange
  ];

  void _showSendOrderConfirmation(
      BuildContext context, TableSessionController tableCtrl) {
    if (tableCtrl.orderItems.isEmpty) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.caramel.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: AppColors.caramel,
                  size: 26,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Confirm Table ${tableCtrl.tableNumber} Order',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'تأكيد طلب طاولة ${tableCtrl.tableNumber}',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
              const SizedBox(height: 16),
              Text(
                'Submitting group order for ${tableCtrl.participantCount} participants (${tableCtrl.totalItemCount} drinks).',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(color: AppColors.textMuted, fontSize: 13),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.softSand.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Table Amount:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${tableCtrl.total.toStringAsFixed(0)} EGP',
                      style: const TextStyle(
                        color: AppColors.caramel,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Obx(
                () => SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: tableCtrl.isSubmittingOrder.value
                        ? null
                        : () async {
                            final success = await tableCtrl.submitTableOrder();
                            if (success) {
                              Navigator.pop(context);
                              Get.offAllNamed(Routes.ORDER_CONFIRMATION);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.espressoDark,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: tableCtrl.isSubmittingOrder.value
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Confirm and Send Order ☕',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tableCtrl = Get.find<TableSessionController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0A08) : AppColors.lightBg,
      body: SafeArea(
        child: Obx(() {
          final session = tableCtrl.currentSession.value;
          final _ = tableCtrl.orderItems.length; // Reactive list dependency

          if (session == null) {
            return EmptyState(
              icon: Icons.table_restaurant_outlined,
              title: 'No Active Table Session',
              message:
                  'Scan a table QR code to start or join a shared group table order!',
              actionLabel: 'Scan Table QR',
              onAction: () => Get.offAllNamed(Routes.SCANNER),
            );
          }

          final participants = session.participants;
          final meId = tableCtrl.currentParticipant.value?.participantId;

          // Order participants: Current participant first, followed by others
          final orderedParticipants = [
            ...participants.where((p) => p.participantId == meId),
            ...participants.where((p) => p.participantId != meId),
          ];

          return Column(
            children: [
              // 1. Custom Screen Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          Get.offAllNamed(Routes.HOME);
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color:
                              isDark ? const Color(0xFF181816) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF3A2B18)
                                : AppColors.caramel.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 18,
                          color:
                              isDark ? AppColors.textLight : AppColors.textDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Table ${tableCtrl.tableNumber} Cart',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.textLight
                                  : AppColors.textDark,
                            ),
                          ),
                          Text(
                            'سلة طاولة ${tableCtrl.tableNumber}',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark
                                  ? AppColors.textLightMuted
                                  : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // LIVE Status Indicator Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00D98B).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF00D98B).withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          CircleAvatar(
                            radius: 3,
                            backgroundColor: Color(0xFF00D98B),
                          ),
                          SizedBox(width: 5),
                          Text(
                            'LIVE',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00D98B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 3. Main Scrollable Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 20),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Summary Stats
                    TableSummaryStats(
                      guestCount: tableCtrl.participantCount,
                      itemCount: tableCtrl.totalItemCount,
                      totalAmount: tableCtrl.total,
                    ),

                    // Split Bill View Control
                    SplitBillToggleCard(
                      isEnabled: isSplitBillView.value,
                      onChanged: (val) => isSplitBillView.value = val,
                    ),

                    const SizedBox(height: 4),

                    // Participant Cards
                    ...orderedParticipants.asMap().entries.map((entry) {
                      final index = entry.key;
                      final p = entry.value;
                      final isMe = p.participantId == meId;
                      final items = tableCtrl.participantItems(p.participantId);
                      final subtotal =
                          tableCtrl.participantSubtotal(p.participantId);

                      final accentColor = isMe
                          ? const Color(0xFF00D98B)
                          : _companionAccentColors[
                              (index - 1) % _companionAccentColors.length];

                      return ParticipantOrderCard(
                        participant: p,
                        items: items,
                        subtotal: subtotal,
                        isCurrentUser: isMe,
                        accentColor: accentColor,
                        isSplitBillView: isSplitBillView.value,
                        isSessionSubmitted: tableCtrl.isSubmitted,
                        onToggleDone: () => tableCtrl
                            .toggleParticipantDoneStatus(p.participantId),
                        onIncrement: (id) =>
                            tableCtrl.incrementItemQuantity(id),
                        onDecrement: (id) =>
                            tableCtrl.decrementItemQuantity(id),
                        onRemove: (id) => tableCtrl.removeItem(id),
                      );
                    }).toList(),

                    // Combined Table Total Card
                    CombinedTableTotalCard(
                      totalAmount: tableCtrl.total,
                    ),
                  ],
                ),
              ),

              // 4. Sticky Send Order CTA Button
              SendTableOrderButton(
                totalItems: tableCtrl.totalItemCount,
                isLoading: tableCtrl.isSubmittingOrder.value,
                isSubmitted: tableCtrl.isSubmitted,
                allParticipantsDone: tableCtrl.allParticipantsDone,
                readinessMessage: tableCtrl.readinessMessage,
                onPressed: () => _showSendOrderConfirmation(context, tableCtrl),
              ),
            ],
          );
        }),
      ),
    );
  }
}
