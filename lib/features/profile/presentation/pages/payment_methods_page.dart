import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/controllers/table_session_controller.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/common/app_app_bar.dart';
import '../../../../core/widgets/common/cafe_card.dart';

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({Key? key}) : super(key: key);

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  int _selectedSplitOption =
      1; // 0: Equally, 1: By Person, 2: By Item, 3: Custom
  String _selectedPaymentMethod = 'Apple Pay';

  final List<String> _splitOptions = [
    'Equally',
    'By Person',
    'By Item',
    'Custom'
  ];

  static const List<Color> _avatarColors = [
    Color(0xFF31A93D),
    Color(0xFFD0932F),
    Color(0xFF29B6F6),
    Color(0xFFAB47BC),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.gold : AppColors.goldLight;
    final greenColor =
        isDark ? AppColors.primaryGreen : AppColors.primaryGreenLight;

    TableSessionController? tableCtrl;
    if (Get.isRegistered<TableSessionController>()) {
      tableCtrl = Get.find<TableSessionController>();
    }

    final participants = tableCtrl?.currentSession.value?.participants ?? [];
    final totalAmount = tableCtrl?.total ?? 185.00;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppAppBar(
        title: 'Payment & Split • تقسيم الحساب',
        showCartAction: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Split Options at Top
              Text(
                'Split Mode / طريقة التقسيم',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: List.generate(_splitOptions.length, (idx) {
                  final opt = _splitOptions[idx];
                  final isSelected = _selectedSplitOption == idx;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedSplitOption = idx),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? goldColor.withValues(
                                    alpha: isDark ? 0.22 : 0.16)
                                : (isDark
                                    ? AppColors.darkCardElevated
                                    : AppColors.lightSecondaryBg),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? goldColor
                                  : (isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder),
                              width: isSelected ? 1.5 : 1.0,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              opt,
                              style: TextStyle(
                                color: isSelected
                                    ? (isDark
                                        ? AppColors.goldBright
                                        : goldColor)
                                    : (isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary),
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),

              // 2. Member Breakdown List
              Text(
                'Table Members Breakdown / حساب الأعضاء',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 10),

              if (participants.isNotEmpty)
                ...participants.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final p = entry.value;
                  final pSubtotal =
                      tableCtrl!.participantSubtotal(p.participantId);
                  final amount = _selectedSplitOption == 0
                      ? (totalAmount / participants.length)
                      : pSubtotal;
                  final percentage = totalAmount > 0
                      ? ((amount / totalAmount) * 100).toInt()
                      : 0;
                  final isPaid = p.isDone;

                  return CafeCard(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor:
                              _avatarColors[idx % _avatarColors.length],
                          child: Text(
                            p.displayName.isNotEmpty
                                ? p.displayName[0].toUpperCase()
                                : 'U',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.displayName,
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.lightTextPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '$percentage% of table total',
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${amount.toStringAsFixed(2)} EGP',
                              style: TextStyle(
                                color: goldColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isPaid
                                      ? Icons.check_circle_rounded
                                      : Icons.pending_rounded,
                                  size: 13,
                                  color: isPaid ? greenColor : goldColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isPaid ? 'Paid' : 'Pending',
                                  style: TextStyle(
                                    color: isPaid ? greenColor : goldColor,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                })
              else
                CafeCard(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Your Total Payment:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${totalAmount.toStringAsFixed(2)} EGP',
                          style: TextStyle(
                              color: goldColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                    ],
                  ),
                ),
              const SizedBox(height: 14),

              // Total Table Amount Banner
              CafeCard(
                isElevated: true,
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Table Amount / الإجمالي',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    Text(
                      '${totalAmount.toStringAsFixed(2)} EGP',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: goldColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 3. Payment Methods
              Text(
                'Select Payment Method / وسيلة الدفع',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 10),
              ...[
                {
                  'name': 'Apple Pay',
                  'icon': Icons.contactless_rounded,
                  'subtitle': 'Instant Biometric Checkout'
                },
                {
                  'name': 'Credit / Debit Card',
                  'icon': Icons.credit_card_rounded,
                  'subtitle': 'Visa, Mastercard, Meeza'
                },
                {
                  'name': 'Cash to Waiter',
                  'icon': Icons.payments_rounded,
                  'subtitle': 'Pay directly at table'
                },
              ].map((m) {
                final isSelected = _selectedPaymentMethod == m['name'];
                return CafeCard(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  borderColor: isSelected ? goldColor : null,
                  onTap: () => setState(
                      () => _selectedPaymentMethod = m['name'] as String),
                  child: Row(
                    children: [
                      Icon(m['icon'] as IconData,
                          color: isSelected
                              ? goldColor
                              : (isDark ? Colors.white70 : Colors.black87),
                          size: 24),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              m['name'] as String,
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightTextPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13.5,
                              ),
                            ),
                            Text(
                              m['subtitle'] as String,
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
                      if (isSelected)
                        Icon(Icons.check_circle_rounded,
                            color: greenColor, size: 20),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),

      // 4. Large Green Payment Button at Bottom
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 1.2,
            ),
          ),
        ),
        child: SafeArea(
          child: PrimaryButton(
            label:
                'Pay Now (${totalAmount.toStringAsFixed(2)} EGP) • دفع الحساب',
            onPressed: () {
              Get.snackbar(
                'Payment Successful',
                'Thank you! Your payment via $_selectedPaymentMethod has been approved.',
                backgroundColor:
                    isDark ? AppColors.darkCardBg : AppColors.lightCardBg,
                colorText: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              );
            },
          ),
        ),
      ),
    );
  }
}
