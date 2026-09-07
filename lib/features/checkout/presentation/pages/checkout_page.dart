import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/controllers/cart_controller.dart';
import '../../../../app/controllers/orders_controller.dart';
import '../../../../app/controllers/table_session_controller.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/common/app_app_bar.dart';
import '../../../../core/widgets/common/cafe_card.dart';
import 'order_confirmation_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  static const List<Color> _avatarColors = [
    Color(0xFF31A93D),
    Color(0xFFD0932F),
    Color(0xFF29B6F6),
    Color(0xFFAB47BC),
  ];

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final ordersController = Get.find<OrdersController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goldColor = isDark ? AppColors.gold : AppColors.goldLight;
    final greenColor =
        isDark ? AppColors.primaryGreen : AppColors.primaryGreenLight;

    TableSessionController? tableCtrl;
    if (Get.isRegistered<TableSessionController>()) {
      tableCtrl = Get.find<TableSessionController>();
    }

    final hasTable = tableCtrl != null && tableCtrl.hasActiveSession;
    final participants =
        hasTable ? (tableCtrl.currentSession.value?.participants ?? []) : [];
    final subtotal = hasTable ? tableCtrl.total : cartController.total;
    const discount = 0.00;
    final grandTotal = subtotal - discount;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppAppBar(
        title: hasTable
            ? 'review_table_order_title'
                .trParams({'table': tableCtrl.tableNumber.toString()})
            : 'review_order_title'.tr,
        showCartAction: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Estimated Preparation Time Card
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkCardElevated
                      : AppColors.lightSecondaryBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: goldColor.withValues(alpha: 0.5),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                            goldColor.withValues(alpha: isDark ? 0.20 : 0.14),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.timer_outlined,
                          color: goldColor, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'estimated_prep_time_val'
                                .trParams({'time': '10 - 15'}),
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.5,
                            ),
                          ),
                          Text(
                            'prep_time_subtitle'.tr,
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
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // 2. Ordered Items Grouped by Person
              Text(
                'order_summary_title'.tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 10),

              if (hasTable && participants.isNotEmpty) ...[
                ...participants.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final p = entry.value;
                  final items = tableCtrl!.participantItems(p.participantId);
                  final personSubtotal =
                  tableCtrl.participantSubtotal(p.participantId);
                  if (items.isEmpty) return const SizedBox.shrink();

                  return CafeCard(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Person Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor:
                                      _avatarColors[idx % _avatarColors.length],
                                  child: Text(
                                    p.displayName.isNotEmpty
                                        ? p.displayName[0].toUpperCase()
                                        : 'U',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
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
                                const SizedBox(width: 6),
                                Text(
                                  '(' +
                                      'items_count'.trParams(
                                          {'count': '${items.length}'}) +
                                      ')',
                                  style: TextStyle(
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${personSubtotal.toStringAsFixed(2)} ${'egp'.tr}',
                              style: TextStyle(
                                color: goldColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Divider(
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder),
                        ...items.map((item) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${item.quantity}x ${item.product.localizedName} (${item.selectedSize.localizedName})',
                                    style: TextStyle(
                                      color: isDark
                                          ? AppColors.darkTextPrimary
                                          : AppColors.lightTextPrimary,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${item.totalPrice.toStringAsFixed(2)} ${'egp'.tr}',
                                  style: TextStyle(
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary,
                                    fontSize: 12.5,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                }),
              ] else ...[
                ...cartController.cartItems.map((item) {
                  return CafeCard(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${item.quantity}x ${item.product.localizedName} (${item.selectedSize.localizedName})',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13.5,
                          ),
                        ),
                        Text(
                          '${item.totalPrice.toStringAsFixed(2)} ${'egp'.tr}',
                          style: TextStyle(
                            color: goldColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.5,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
              const SizedBox(height: 16),

              // 3. Order Calculations Card
              CafeCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('subtotal'.tr,
                            style: TextStyle(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary)),
                        Text('${subtotal.toStringAsFixed(2)} ${'egp'.tr}',
                            style: TextStyle(
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightTextPrimary)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('discount'.tr,
                            style: TextStyle(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary)),
                        Text('0.00 ${'egp'.tr}',
                            style: TextStyle(color: greenColor)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Divider(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'grand_total'.tr,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        Text(
                          '${grandTotal.toStringAsFixed(2)} ${'egp'.tr}',
                          style: TextStyle(
                            color: goldColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // 4. Sticky Bottom Action Buttons
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
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('continue_editing'.tr),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  label: hasTable ? 'send_order_btn'.tr : 'place_order_btn'.tr,
                  onPressed: () async {
                    if (hasTable && tableCtrl != null) {
                      await tableCtrl.submitTableOrder();
                      Get.offAll(() => const OrderConfirmationPage(
                            orderId: 'TBL-1201',
                            totalAmount: 14.50,
                          ));
                    } else {
                      final order = ordersController.placeOrder(
                        items: cartController.cartItems,
                        subtotal: cartController.subtotal,
                        tax: cartController.tax,
                        deliveryFee: cartController.deliveryFee,
                        total: cartController.total,
                        deliveryAddress: 'In-Cafe Table',
                      );
                      Get.offAll(() => OrderConfirmationPage(
                            orderId: order.id,
                            totalAmount: order.total,
                          ));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
