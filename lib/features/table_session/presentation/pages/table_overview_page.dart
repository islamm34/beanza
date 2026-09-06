import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/controllers/table_session_controller.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/common/cafe_card.dart';
import '../../../../core/widgets/common/empty_state.dart';
import '../../../../core/widgets/table/combined_table_total_card.dart';
import '../../../../core/widgets/table/participant_order_card.dart';
import '../../../../core/widgets/table/send_table_order_button.dart';
import '../../../../core/widgets/table/split_bill_toggle_card.dart';
import '../widgets/join_approval_bottom_sheet.dart';

class TableOverviewPage extends StatefulWidget {
  const TableOverviewPage({Key? key}) : super(key: key);

  @override
  State<TableOverviewPage> createState() => _TableOverviewPageState();
}

class _TableOverviewPageState extends State<TableOverviewPage> {
  final isSplitBillView = false.obs;

  static const List<Color> _companionAccentColors = [
    Color(0xFFD0932F),
    Color(0xFF31A93D),
    Color(0xFF29B6F6),
    Color(0xFFAB47BC),
  ];

  void _showLeaveTableDialog(
      BuildContext context, TableSessionController controller) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        title: Text(
          'Leave Table Session?',
          style: TextStyle(
            color:
                isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Leaving will remove you from this table session. Your items will remain in the group order until submitted.',
          style: TextStyle(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.leaveTableSession();
              Navigator.pop(context);
              Get.offAllNamed(Routes.SCANNER);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Leave Table'),
          ),
        ],
      ),
    );
  }

  void _showSendOrderConfirmation(
      BuildContext context, TableSessionController tableCtrl) {
    if (tableCtrl.orderItems.isEmpty) return;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
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
                  color: AppColors.primaryGreen.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: AppColors.primaryGreen,
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
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Submitting group order for ${tableCtrl.participantCount} participants (${tableCtrl.totalItemCount} drinks).',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkCardElevated
                      : AppColors.lightSecondaryBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color:
                        isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Table Amount:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${tableCtrl.total.toStringAsFixed(2)} EGP',
                      style: const TextStyle(
                        color: AppColors.gold,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Obx(
                () => PrimaryButton(
                  isLoading: tableCtrl.isSubmittingOrder.value,
                  label: 'Confirm and Send Order ☕',
                  onPressed: () async {
                    final success = await tableCtrl.submitTableOrder();
                    if (success && context.mounted) {
                      Navigator.pop(context);
                      Get.offAllNamed(Routes.ORDER_CONFIRMATION);
                    }
                  },
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
    final goldColor = isDark ? AppColors.gold : AppColors.goldLight;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: SafeArea(
        child: Obx(() {
          final session = tableCtrl.currentSession.value;
          final _ = tableCtrl.orderItems.length;

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

          final orderedParticipants = [
            ...participants.where((p) => p.participantId == meId),
            ...participants.where((p) => p.participantId != meId),
          ];

          return Column(
            children: [
              // 1. Top Row: Back button, Table name, QR/Share action
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkCardElevated
                              : AppColors.lightSecondaryBg,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder,
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 16,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          Get.offAllNamed(Routes.HOME);
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Table ${tableCtrl.tableNumber}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                          Text(
                            '${tableCtrl.participantCount} Connected Members • أعضاء متصلون',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (kDebugMode)
                      IconButton(
                        key: const Key('trigger_incoming_request_debug_button'),
                        icon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: goldColor.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                            border: Border.all(color: goldColor, width: 1.2),
                          ),
                          child: Icon(
                            Icons.person_add_alt_1_rounded,
                            color: goldColor,
                            size: 16,
                          ),
                        ),
                        tooltip: 'Prototype: Preview Join Request',
                        onPressed: () {
                          JoinApprovalBottomSheet.show(
                            context: context,
                            requesterName: 'Youssef',
                            tableNumber: tableCtrl.tableNumber,
                            onApprove: () {
                              Get.snackbar(
                                'Request Approved • تمت الموافقة',
                                'Youssef has been approved to join Table ${tableCtrl.tableNumber}.',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: const Color(0xFF31A93D),
                                colorText: Colors.white,
                              );
                            },
                            onReject: () {
                              Get.snackbar(
                                'Request Declined • تم الرفض',
                                'Youssef was not approved.',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: const Color(0xFFD95656),
                                colorText: Colors.white,
                              );
                            },
                          );
                        },
                      ),
                    // QR / Share Icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                            goldColor.withValues(alpha: isDark ? 0.18 : 0.12),
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: goldColor.withValues(alpha: 0.5)),
                      ),
                      child: Icon(
                        Icons.qr_code_2_rounded,
                        color: goldColor,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Member Avatars Horizontally with Names
              SizedBox(
                height: 84,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: orderedParticipants.length,
                  itemBuilder: (context, index) {
                    final p = orderedParticipants[index];
                    final isMe = p.participantId == meId;

                    return Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: isMe
                                    ? AppColors.primaryGreen
                                    : _companionAccentColors[
                                        index % _companionAccentColors.length],
                                child: Text(
                                  p.displayName.isNotEmpty
                                      ? p.displayName[0].toUpperCase()
                                      : 'U',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              if (p.isDone)
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check_circle_rounded,
                                      color: AppColors.primaryGreen,
                                      size: 14,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isMe ? '${p.displayName} (You)' : p.displayName,
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                              fontSize: 11,
                              fontWeight:
                                  isMe ? FontWeight.bold : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // 3. Live Activity & Group Orders List
              Expanded(
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Live Activity Card
                    CafeCard(
                      isElevated: true,
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryGreen
                                  .withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.bolt_rounded,
                              color: AppColors.primaryGreen,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Live: ${orderedParticipants.first.displayName} is viewing menu • ${tableCtrl.totalItemCount} items in cart',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    SplitBillToggleCard(
                      isEnabled: isSplitBillView.value,
                      onChanged: (val) => isSplitBillView.value = val,
                    ),
                    const SizedBox(height: 8),

                    ...orderedParticipants.asMap().entries.map((entry) {
                      final index = entry.key;
                      final p = entry.value;
                      final isMe = p.participantId == meId;
                      final items = tableCtrl.participantItems(p.participantId);
                      final subtotal =
                          tableCtrl.participantSubtotal(p.participantId);

                      final accentColor = isMe
                          ? AppColors.primaryGreen
                          : _companionAccentColors[
                              index % _companionAccentColors.length];

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
                    }),

                    CombinedTableTotalCard(
                      totalAmount: tableCtrl.total,
                    ),
                    const SizedBox(height: 12),

                    // Navigation Action: View Menu & Secondary Actions
                    PrimaryButton(
                      label: 'View Menu & Add Drinks ☕',
                      icon: const Icon(Icons.menu_book_rounded,
                          color: Colors.white, size: 18),
                      onPressed: () => Get.toNamed(Routes.HOME),
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Get.snackbar(
                                'Table Share',
                                'Share QR or Table #${tableCtrl.tableNumber} with your friends!',
                                backgroundColor: isDark
                                    ? AppColors.darkCardBg
                                    : AppColors.lightCardBg,
                                colorText: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightTextPrimary,
                              );
                            },
                            icon:
                                const Icon(Icons.person_add_outlined, size: 16),
                            label: const Text('Invite Friend'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () =>
                                _showLeaveTableDialog(context, tableCtrl),
                            icon: const Icon(Icons.logout_rounded,
                                size: 16, color: AppColors.error),
                            label: const Text('Leave Table',
                                style: TextStyle(color: AppColors.error)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),

              // Sticky Bottom Action if items exist
              if (tableCtrl.totalItemCount > 0)
                SendTableOrderButton(
                  totalItems: tableCtrl.totalItemCount,
                  isLoading: tableCtrl.isSubmittingOrder.value,
                  isSubmitted: tableCtrl.isSubmitted,
                  allParticipantsDone: tableCtrl.allParticipantsDone,
                  readinessMessage: tableCtrl.readinessMessage,
                  onPressed: () =>
                      _showSendOrderConfirmation(context, tableCtrl),
                ),
            ],
          );
        }),
      ),
    );
  }
}
